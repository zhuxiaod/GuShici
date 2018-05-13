//
//  ZXDMusicViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/4/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDMusicViewController.h"
#import "ZXDMusicTableViewCell.h"
#import "MJExtension.h"
#import "ZXDMusic.h"
#import "ZXDPlayMusicViewController.h"
#import "AFNetWorking.h"
#import "ZXDMusics.h"

// 弱引用
#define ZXDWeakSelf __weak typeof(self) weakSelf = self;

@interface ZXDMusicViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (strong, nonatomic) NSArray *music;
/** 请求管理者 */
@property (nonatomic, weak) AFHTTPSessionManager *manager;
@end

NSString *ID = @"musicID";
//添加异步更新
//更换数据源

@implementation ZXDMusicViewController

//Btn数据
- (NSMutableArray *)dataArr
{
    if(!_dataArr){
        //说明模型和plist有问题
        [self loadCells];
    }
    return _dataArr;
}

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    //1.注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXDMusicTableViewCell class]) bundle:nil] forCellReuseIdentifier:ID];
}

-(void)loadCells
{
    NSDictionary *paramDict = @{@"album_id":@"3"
                                };
    [self.manager GET:@"http://g1q.gn.zaijiawan.com/matrix_common/api/audio/childStoryList" parameters:paramDict progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             ZXDWeakSelf;
             weakSelf.dataArr  = [ZXDMusic mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"music"]];
             // 刷新表格
             [weakSelf.tableView reloadData];

         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"failure:%@",error);
         }];

}

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //先界面。再数据
    // 2.访问缓存池
    ZXDMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.Music = self.dataArr[indexPath.row];
    ZXDMusic *music = self.dataArr[indexPath.row];
    NSInteger storyID = music.story_id - 300;
    NSString *stID = [[NSString alloc] initWithFormat:@"%ld",(long)storyID];
    //中文转拼音
    NSString *storyName = [ZXDMusic chChangePin:music.story_name];
    NSString *filename = [[NSString alloc] initWithFormat:@"%@-%@.mp3",stID,storyName];
    music.filename = filename;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
//选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中了:%ld",indexPath.row);
    ZXDPlayMusicViewController *playMusicVC = [[ZXDPlayMusicViewController alloc] init];
    playMusicVC.hidesBottomBarWhenPushed = YES;
    playMusicVC.currentmusic = self.dataArr[indexPath.row];
    playMusicVC.dataArr = self.dataArr;
    [self.navigationController pushViewController:playMusicVC animated:YES];
    
}
@end
