
//  ZXDHomeViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/3/25.
//  Copyright © 2018年 zxd. All rights reserved.
//
#import "ZXDMusic.h"
#import "ZXDGuShiShowViewController.h"
#import "ZXDRecommendView.h"
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
#import "PYSearchSuggestionViewController.h"
@interface ZXDHomeViewController ()<PYSearchViewControllerDelegate,PYSearchViewControllerDataSource,PYSearchSuggestionViewDataSource>
//首页    轮播的数据源没有搞好。其他完成
@property (nonatomic, strong) ZXDCycleData *cycStr;
@property (nonatomic, strong) ZXDCycleView *cell;
@property (nonatomic, strong) UITableViewCell *btnCell;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) FMDatabaseQueue *queue;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) PYSearchViewController *searchViewController;
@property (nonatomic, strong) NSArray *show;
@end

@implementation ZXDHomeViewController
//Btn数据
- (NSMutableArray *)dataArr
{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
//标题数据源
- (NSMutableArray *)titles
{
    if(!_titles){
        _titles = [NSMutableArray array];
    }
    return _titles;
}
//标题数据源
- (NSArray *)show
{
    if(!_show){
        _show = [NSArray array];
    }
    return _show;
}
//轮播数据源
- (ZXDCycleData *)cycStr
{
     if (!_cycStr) {
         ZXDCycleData *temp = [ZXDCycleData cycleWithInit:@"timg" image2:@"54d130e10befb794cf5e5be5a685ae96" image3:@"ba91b30765fa8c67a14614403027c6bb" cellHeight:cellHeight1];
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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavBar];
    
    [self registerTableViewCell];
    //隐藏滚动条
    self.tableView.showsVerticalScrollIndicator = NO;

    //设置button数据源
    [self setupDB];
}

-(void)setupDB{
    //本地文件的路径
    NSString *string = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"db"];
    
    //1.创建数据库队列
    self.queue = [FMDatabaseQueue databaseQueueWithPath:string];
    //2.创建表
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        BOOL result = [db executeUpdate:@"create table if not exists person (id integer primary key autoincrement, name text, age integer);"];
        if(result){
            NSLog(@"创建成功");
        }else{
            NSLog(@"创建失败");
        }
    }];
    [self query];
}
-(void)query{
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        //1.查询数据
        FMResultSet *rs = [db executeQuery:@"select * from Content"];
        //2.遍历结果集
        while(rs.next){
            ZXDMusic *music = [[ZXDMusic alloc] init];
            music.music_name = [rs stringForColumn:@"标题"];
            music.music_image = [rs stringForColumn:@"缩略图"];
            music.music_bimag = [rs stringForColumn:@"背景图"];
            music.music_fl = [rs stringForColumn:@"音频"];
            music.music_id = [rs intForColumn:@"ID"];
            [self.dataArr addObject:music];
            [self.titles addObject:music.music_name];
        }
    }];
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
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"搜索" target:self action:@selector(setting)];
    //把UIButton包装成UIButtonItem,导致点击区域变大
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(setting)];
    
    //中间导航条
    self.navigationItem.title = @"首页";
}

#pragma mark - 设置搜索跳转
-(void)setting
{
    NSArray *hotSeaches = @[@"春晓", @"春夜喜雨", @"绝句", @"江雪", @"游子吟", @"浪淘沙", @"忆江南", @"悯农", @"山行", @"秋夕"];
    _searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:NSLocalizedString(@"请输入诗歌", @"春晓") didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        //传个对象过去
        for(int i = 0;i < self.dataArr.count;i++)
        {
            ZXDMusic *music = self.dataArr[i];
            if([searchText isEqualToString:music.music_name])
            {
                ZXDRecordViewController *recordVC = [[ZXDRecordViewController alloc] init];
                recordVC.currentmusic = music;
                [searchViewController.navigationController pushViewController:recordVC animated:YES];
            }
        }
    }];
    _searchViewController.dataSource = self;
    _searchViewController.delegate = self;
    UINavigationController *nav = [[ZXDNavigationViewController alloc] initWithRootViewController:_searchViewController];
    [self presentViewController:nav animated:YES completion:nil];

}
#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSPredicate * predicate = [NSPredicate  predicateWithFormat:@"SELF CONTAINS %@",searchText];
            //过滤数据
            NSMutableArray *searchSuggestionsM = [NSMutableArray array];
            searchSuggestionsM = [[self.titles filteredArrayUsingPredicate:predicate] mutableCopy];
            searchViewController.searchSuggestions = searchSuggestionsM;
        });
    }
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
    //轮播
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            _cell = [tableView dequeueReusableCellWithIdentifier:bannerID];
            
            //发送数据给cell
            _cell.CycleData = self.cycStr;
            
            return _cell;
        }else if (indexPath.row == 1){
            //首页btn
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:piecesID];
            _btnCell = cell;
            HomeButton *homeBtn = [HomeButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(0, 0, tableView.frame.size.width / 3, cellHeight2) title:@"听一听" titleColor:[UIColor blackColor] titleFont:15 textAlignment:NSTextAlignmentCenter image:[UIImage imageNamed:@"音乐"] imageViewContentMode:UIViewContentModeCenter handler:^(UIButton *sender) {
                [self musicView];
            }];
            
            [cell.contentView addSubview:homeBtn];
            //
            HomeButton *likeBtn = [HomeButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(homeBtn.frame.size.width, 0,  tableView.frame.size.width / 3, cellHeight2) title:@"读一读" titleColor:[UIColor blackColor] titleFont:15 textAlignment:NSTextAlignmentCenter image:[UIImage imageNamed:@"录音"] imageViewContentMode:UIViewContentModeCenter handler:^(UIButton *sender) {
                [self recordView];
                
            }];
            
            [cell.contentView addSubview:likeBtn];
            
            HomeButton *listBtn = [HomeButton buttonWithType:UIButtonTypeCustom frame:CGRectMake(homeBtn.frame.size.width * 2, 0, tableView.frame.size.width / 3, cellHeight2) title:@"写一写" titleColor:[UIColor blackColor] titleFont:15 textAlignment:NSTextAlignmentCenter image:[UIImage imageNamed:@"写字"] imageViewContentMode:UIViewContentModeCenter handler:^(UIButton *sender) {
                [self makeOutView];
                
            }];
            
            [cell.contentView addSubview:listBtn];
            
            return cell;
        }
    }else if(indexPath.section == 1){
        ZXDRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:listID];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //让每个Btn不一样
        int value = 16;
        for (NSInteger i = 0; i < 6; i ++,value++) {
            //设置索引
            NSInteger index1 = i;
            //传递索引
            cell.indexTag = index1;
            //给每个button设置索引
            [cell.buttom setTag:index1];
            //给每个button设置数据
            ZXDMusic *music = self.dataArr[value];
            cell.zxdMusic = music;
            //获得cell中的button 并给他们添加事件
            HomeButton *homebtn = [cell.btns objectAtIndex:i];
            homebtn.value = value;
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

#pragma mark - TermCellDelegate
- (void)choseTerm:(HomeButton *)button
{
    ZXDMusic *music = self.dataArr[button.value];
    ZXDGuShiShowViewController *showVC = [[ZXDGuShiShowViewController alloc] init];
    showVC.music = music;
    showVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:showVC animated:YES];
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
