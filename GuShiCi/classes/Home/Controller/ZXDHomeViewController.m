
//  ZXDHomeViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/3/25.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDHomeViewController.h"
#import "UIBarButtonItem+Item.h"
#import "ZXDSettingViewController.h"
#import "ZXDCycleView.h"
#import "ZXDCycleData.h"
#import "MYCycleView.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <NetworkExtension/NetworkExtension.h>
#import "HomeButton.h"
#import "ZXDRecommendButton.h"
#import "ZXDRecommendCell.h"
#import "MJExtension.h"
#import "ZXDMusicViewController.h"
#import "ZXDRecordViewController.h"
#import "ZXDRecordListViewController.h"
#import "ZXDMakeOutViewController.h"
@interface ZXDHomeViewController ()

//@property (nonatomic, strong) MYCycleView *cycleView;

@property (nonatomic, strong) ZXDCycleData *cycStr;
@property (nonatomic, strong) ZXDCycleView *cell;
@property (nonatomic, strong) UITableViewCell *btnCell;
@property (nonatomic, strong) NSArray *dataArr;

@end
//不需要设置btn
//更换轮播图片
//btn的图片
//添加6个btn的内容

@implementation ZXDHomeViewController
//Btn数据
- (NSArray *)dataArr
{
    if(!_dataArr){
        _dataArr = [ZXDRecommendButton mj_objectArrayWithFilename:@"buttons.plist"];
    }
    return _dataArr;
}

//轮播数据源
- (ZXDCycleData *)cycStr
{
     if (!_cycStr) {
         ZXDCycleData *temp = [ZXDCycleData cycleWithInit:@"QQ20180404-0" image2:@"QQ20180404-2" image3:@"QQ20180404-3" cellHeight:cellHeight1];
         _cycStr = temp;
     }
    return _cycStr;
}

//轮播启动开关
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    开始轮播
    _cell.CycleData = self.cycStr;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //    停止轮播
    _cell.cycleViewSecond = 0;
}

//创建Cell的标识
NSString *bannerID = @"banner";
NSString *piecesID = @"piecesID";
NSString *listID = @"listID";
CGFloat cellHeight1 = 200;
CGFloat cellHeight2 = 110;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setupNavBar];
    
    [self registerTableViewCell];
    //隐藏滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
   
}

//注册cell
-(void)registerTableViewCell
{
    // 根据ID 这个标识 注册对应的cell类型 为UITableViewCell(只注册一次)
    [self.tableView registerClass:[ZXDCycleView class] forCellReuseIdentifier:bannerID];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:piecesID];

    [self.tableView registerClass:[ZXDRecommendCell class] forCellReuseIdentifier:listID];
}

#pragma mark - 设置导航条
-(void)setupNavBar
{
    //右边导航条
    //左边导航条
    //把UIButton包装成UIButtonItem,导致点击区域变大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(setting)];
    
    //中间导航条
    self.navigationItem.title = @"首页";
}

#pragma mark - 设置页面跳转
-(void)setting
{
    ZXDSettingViewController *settingVC = [[ZXDSettingViewController alloc] init];
    
    settingVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //轮播  已做好
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            _cell = [tableView dequeueReusableCellWithIdentifier:bannerID];
            
            //发送数据给cell
            _cell.CycleData = self.cycStr;
            
            return _cell;
        }else if (indexPath.row == 1){
            //首页btn
            //开始创建首页按钮 1.先看需要创建什么按钮。创建几个？
            //高度
            //抽一下
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:piecesID];
            _btnCell = cell;
            HomeButton *homeBtn = [HomeButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, tableView.frame.size.width / 3, cellHeight2) title:@"听一听" titleColor:[UIColor blackColor] titleFont:15 textAlignment:NSTextAlignmentCenter image:[UIImage imageNamed:@"Music"] imageViewContentMode:UIViewContentModeCenter handler:^(UIButton *sender) {
                [self musicView];
            }];
            
            [cell.contentView addSubview:homeBtn];
            //
            HomeButton *likeBtn = [HomeButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(homeBtn.frame.size.width, 0,  tableView.frame.size.width / 3, cellHeight2) title:@"读一读" titleColor:[UIColor blackColor] titleFont:15 textAlignment:NSTextAlignmentCenter image:[UIImage imageNamed:@"Apps"] imageViewContentMode:UIViewContentModeCenter handler:^(UIButton *sender) {
                [self recordView];
                
            }];
            
            [cell.contentView addSubview:likeBtn];
            
            HomeButton *listBtn = [HomeButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(homeBtn.frame.size.width * 2, 0, tableView.frame.size.width / 3, cellHeight2) title:@"写一写" titleColor:[UIColor blackColor] titleFont:15 textAlignment:NSTextAlignmentCenter image:[UIImage imageNamed:@"Apps"] imageViewContentMode:UIViewContentModeCenter handler:^(UIButton *sender) {
                [self makeOutView];
                
            }];
            
            [cell.contentView addSubview:listBtn];
            
            return cell;
        }
    }else if(indexPath.section == 1){
        ZXDRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:listID];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //让每个Btn不一样
        for (NSInteger i = 0; i < 6; i ++) {
            //设置索引
            NSInteger index1 = i;
            //传递索引
            cell.indexTag = index1;
            //给每个button设置索引
            [cell.buttom setTag:index1];
            //给每个button设置数据
            cell.recommendButton = self.dataArr[index1];
            //获得cell中的button 并给他们添加事件
            HomeButton *homebtn = [cell.btns objectAtIndex:i];
            [homebtn addTarget:self action:@selector(choseTerm:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    return cell;
}

//返回每一行cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row  == 0) {
            return cellHeight1;
        } else if(indexPath.row == 1){
            return cellHeight2;
        }
    }else if (indexPath.section == 1)
    {
        //计算高度
        return 400;
    }
    return 100;
}

//  点击单元格的时候取消选中单元格

//设置tableview头标题
// 返回组头部view的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//
//    return 0;
//}
//tableView样式
//- (instancetype)initWithStyle:(UITableViewStyle)style {
//
//    return [super initWithStyle:UITableViewStyleGrouped];
//
//}

#pragma mark - TermCellDelegate
- (void)choseTerm:(UIButton *)button
{
    if (button.tag == 0) {
        NSLog(@"a a a  a  a ");
    }else if (button.tag == 1)
    {
        NSLog(@"bbbbb");
    }else
    {
        NSLog(@"cccc ");
    }
}

-(void)buttonTarget:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        NSLog(@"我是0");
    }else if (sender.tag == 1){
        NSLog(@"我是1");
    }else if (sender.tag == 2){
        NSLog(@"我是2");
    }else if (sender.tag == 3){
        NSLog(@"我是3");
    }else if (sender.tag == 4){
        NSLog(@"我是4");
    }else if (sender.tag == 5){
        NSLog(@"我是5");
    }
}
#pragma mark - 跳转音乐页
-(void)musicView
{
    ZXDMusicViewController *musicVC = [[ZXDMusicViewController alloc] init];
    
    musicVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:musicVC animated:YES];
    
}
#pragma mark - 跳转录音页
//跳转recordVC
-(void)recordView
{
    ZXDRecordListViewController *recordlistVC = [[ZXDRecordListViewController alloc] init];
    
    recordlistVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:recordlistVC animated:YES];
}

#pragma mark - 跳转写字页
- (void)makeOutView{
    ZXDWriteViewController *makeOutVC = [[ZXDWriteViewController alloc] init];

    makeOutVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:makeOutVC animated:YES];
}
@end
