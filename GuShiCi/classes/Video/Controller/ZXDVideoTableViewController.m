//
//  ZXDVideoTableViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/4/24.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDVideoTableViewController.h"
#import <ZFPlayer.h>
#import "ZXDVideoModel.h"
#import "ZXDVideoPlayCell.h"


@interface ZXDVideoTableViewController ()<ZFPlayerDelegate>
/** 网络数据 */
@property (nonatomic,strong) NSMutableArray<ZXDVideoModel *> *videos;
/** 单例播放 */
@property (nonatomic, strong) ZFPlayerView *playerView;

@end


@implementation ZXDVideoTableViewController

NSString *VID = @"videoID";

-(NSMutableArray *)videos
{
    if(!_videos){
        _videos = [ZXDVideoModel mj_objectArrayWithFilename:@"VidoesPlist.plist"];
    }
    return _videos;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];

    
    
    
    
    
    
    
//    ZXDWeak(self);
//    NSDictionary *parameters = @{@"type" : @"JSON"};
//    //显示加载
//    [self showLoading];
//    [[LMJRequestManager sharedManager] GET:[LMJXMGBaseUrl stringByAppendingPathComponent:@"video"] parameters:parameters completion:^(LMJBaseResponse *response) {
//        //完成以后去掉加载
//        [weakself dismissLoading];
//        if (!response.error && response.responseObject) {
//            //请求到了。将视频加入数组之中
//            self.videos = [ZXDVideoModel mj_objectArrayWithKeyValuesArray:response.responseObject[@"videos"]];
//        } else {
//            //失败
//            [weakself.view makeToast:response.errorMsg];
//            return ;
//        }
//        //刷新tableView
//        [weakself.tableView reloadData];
//    }];
    //1.注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXDVideoPlayCell class]) bundle:nil] forCellReuseIdentifier:VID];
}

//页面消失时候
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //重新设置播放器
    [self.playerView resetPlayer];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    if (ZFPlayerShared.isLandscape) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

-(BOOL)prefersStatusBarHidden{
    return ZFPlayerShared.isStatusBarHidden;
}

#pragma mark - Table view data source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.videos.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZXDVideoPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:VID];
    ZXDWeak(self);
    cell.video = self.videos[indexPath.row];
    cell.btnClick = ^(ZXDVideoPlayCell *cell) {
        [weakself myFavoriteCellAddToShoppingCart:cell];
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)myFavoriteCellAddToShoppingCart:(ZXDVideoPlayCell *)cell{
        //那一条cell
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        //获取cell的数据
        ZXDVideoModel *video = self.videos[indexPath.row];
    
    //        NSString *str = @"http://120.25.226.186:32812/";
    //        NSString *str2 =;
    //        [[NSBundlemainBundle] pathForResource:@"m"ofType:@"m4a"];
        NSString *str3 = [[NSBundle mainBundle] pathForResource:video.url ofType:@"mp4"];
    
        str3 = [str3 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    //        NSURL *url = [[NSURL alloc] initWithString:str3];
    //        NSString *Str3 = [str stringByAppendingString:str2];
        // 分辨率字典（key:分辨率名称，value：分辨率url)
        NSURL *url = [NSURL fileURLWithPath:str3];
//        NSDictionary *dic = @{@"高清": url, @"标清": url};
    
        // 取出字典中的第一视频URL
//        NSURL *videoURL = [NSURL URLWithString:dic.allValues.firstObject];
    
//        NSLog(@"url:%@",[videoURL absoluteString]);
        //生成播放器
        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
        playerModel.title            = video.name;
        playerModel.videoURL         = url;
        playerModel.placeholderImageURLString = video.image.absoluteString;
        playerModel.scrollView       = self.tableView;
        playerModel.indexPath        = indexPath;
        // 赋值分辨率字典
//        playerModel.resolutionDic    = dic;
        // player的父视图tag, imageView 199
        playerModel.fatherViewTag    = [cell viewWithTag:199].tag;

        // 设置播放控制层和model
        [self.playerView playerControlView:nil playerModel:playerModel];
        // 下载功能
        self.playerView.hasDownload = NO;
        // 自动播放
        [self.playerView autoPlayTheVideo];
}

#pragma mark - ZFPlayerDelegate
- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
}
//播放器视图
- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        // _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
        // 移除屏幕移除player
        // _playerView.stopPlayWhileCellNotVisable = YES;
        
        _playerView.forcePortrait = NO;
        
        //        ZFPlayerShared.isLockScreen = YES;
        ZFPlayerShared.isStatusBarHidden = NO;
    }
    return _playerView;
}

#pragma mark - 设置导航条
-(void)setupNavBar
{
    //中间导航条
    self.navigationItem.title = @"视频";
}
#pragma mark - 加载框
- (void)showLoading
{
    [MBProgressHUD showProgressToView:self.view Text:@"加载中..."];
}

- (void)dismissLoading
{
    [MBProgressHUD hideHUDForView:self.view];
}

@end
