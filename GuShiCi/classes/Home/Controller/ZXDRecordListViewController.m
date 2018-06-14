//
//  ZXDRecordListViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/4/29.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDRecordListViewController.h"
#import "ZXDMusic.h"
#import "ZXDRecordListCell.h"
#import "ZXDRecordViewController.h"

@interface ZXDRecordListViewController ()

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) FMDatabaseQueue *queue;

@end
//把数据库地址搞好
NSString *RecordListID = @"RecordList";

@implementation ZXDRecordListViewController

- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

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
    
    //1.注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXDRecordListCell class]) bundle:nil] forCellReuseIdentifier:RecordListID];
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:RecordListID];
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
    ZXDRecordViewController *playMusicVC = [[ZXDRecordViewController alloc] init];
    playMusicVC.hidesBottomBarWhenPushed = YES;
    playMusicVC.currentmusic = self.dataArr[indexPath.row];
    playMusicVC.array = self.dataArr;
    [self.navigationController pushViewController:playMusicVC animated:YES];
    
}

-(BOOL)createDir:(NSString *)fileName{
    //获得沙盒的路径
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * path = [NSString stringWithFormat:@"%@/%@",documentsDirectory,fileName];
    NSLog(@"path:%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {//先判断目录是否存在，不存在才创建
        BOOL res=[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        return res;
    } else return NO;
    
}
@end
