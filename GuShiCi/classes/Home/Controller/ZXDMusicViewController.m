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
@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

NSString *ID = @"musicID";
//添加异步更新
//更换数据源

@implementation ZXDMusicViewController

//Btn数据
- (NSMutableArray *)dataArr
{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
        //说明模型和plist有问题
//        [self loadCells];
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
    self.view.backgroundColor = [UIColor whiteColor];

    //1.注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXDMusicTableViewCell class]) bundle:nil] forCellReuseIdentifier:ID];
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
            music.music_fl = [[rs stringForColumn:@"音频"]stringByAppendingString:@".mp3"];
            music.music_id = [rs intForColumn:@"ID"];
            [self.dataArr addObject:music];
        }
    }];
}
//-(void)loadCells
//{
//    NSDictionary *paramDict = @{@"album_id":@"3"
//                                };
//    [self.manager GET:@"http://g1q.gn.zaijiawan.com/matrix_common/api/audio/childStoryList" parameters:paramDict progress:nil
//         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//             ZXDWeakSelf;
//             weakSelf.dataArr  = [ZXDMusic mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"music"]];
//             // 刷新表格
//             [weakSelf.tableView reloadData];
//
//         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//             NSLog(@"failure:%@",error);
//         }];
//
//}

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
#pragma mark - 隐藏navigationBar
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
@end
