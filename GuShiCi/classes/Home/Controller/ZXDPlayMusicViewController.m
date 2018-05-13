
//
//  ZXDPlayMusicViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/4/9.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDPlayMusicViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ImageEffects.h"
#import "UIImage+ImageOpacity.h"
#import "ZXDTitleView.h"
#import "ZXDConsoleView.h"
#import "ZXDConsoleBtn.h"
#import "ZXDDiscView.h"
#import "ZXDSingModel.h"
#import "ZXDAVdioTool.h"
#import "ZXDSingTool.h"
#import "NSString+Extension.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#define ZXDScreenW [UIScreen mainScreen].bounds.size.width
#define ZXDScreenH [UIScreen mainScreen].bounds.size.height

@interface ZXDPlayMusicViewController () <DiscViewDelegate>
//毛玻璃
@property(nonatomic,strong)UIImageView *baseImgView;

@property(nonatomic,strong)ZXDTitleView *titleView;

@property(nonatomic,strong)ZXDConsoleView *consoleView;

@property(nonatomic,strong)NSMutableArray <ZXDDiscView *> *discViewArray;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)ZXDDiscView *discView;

@property(nonatomic,strong)UISlider *slid;
/** 请求管理者 */
@property (nonatomic, weak) AFHTTPSessionManager *manager;
/** 当前播放时间 */
@property (strong, nonatomic)UILabel *currentTimeLabel;
/** 歌曲的总时间 */
@property (strong, nonatomic)UILabel *totalTimeLabel;
/** 播放器 */
@property (nonatomic, strong) AVAudioPlayer *currentPlayer;
/** 进度条时间 */
@property (nonatomic, strong) NSTimer *progressTimer;
/** 队列 */
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, copy) NSString *urlStr;
@end

//添加异步更新
//自动切换歌曲 看看到时候是不是能搞好

@implementation ZXDPlayMusicViewController

#warning 数据源得到了，明天进行下载music然后设置播放页

//Lazyload - 2个视图->用一个数组装着
- (NSMutableArray *)discViewArray
{
    if (!_discViewArray) {
        _discViewArray = [NSMutableArray array];
    }
    return _discViewArray;
}
-(NSOperationQueue *)queue
{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc]init];
        //设置最大并发数
        _queue.maxConcurrentOperationCount = 5;
    }
    return _queue;
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
                                 
    [self createUI];
    
    //设置disc
//    [self initDiscViewSet:self.discViewArray[0]];
    //下载歌曲
    [self downLoadMusic];
}

-(void)downLoadMusic
{
    //http://7xsool.com2.z0.glb.qiniucdn.com/5-chunxue.mp3
    //下载
    //查看磁盘 文件里面有没有
    //1.创建会话管理者
    NSURL *url = [NSURL URLWithString:_urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //2.下载文件
    NSURLSessionDownloadTask *download = [self.manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {

        //监听下载进度
        NSLog(@"%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);

    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //在沙盒中创建该文件夹
        [self createDir:@"musicFile"];
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[@"/musicFile" stringByAppendingPathComponent:response.suggestedFilename]];
        NSLog(@"fullPath:%@",fullPath);
        return [NSURL fileURLWithPath:fullPath];

    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {

        NSLog(@"来了%@",error);
        [self startPlayingMusic];
    }];

    BOOL have = [[ZXDMusic alloc]isFileExist:_currentmusic.filename];
    if (have) {
        [self startPlayingMusic];
    }
    //没有就下载
    else
    {
        //3.执行Task
        [download resume];
    }
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

-(void)setCurrentmusic:(ZXDMusic *)currentmusic
{
    _currentmusic = currentmusic;
    NSInteger storyID = _currentmusic.story_id - 300;
    NSString *stID = [[NSString alloc] initWithFormat:@"%ld",(long)storyID];
    //中文转拼音
    NSString *storyName = [ZXDMusic chChangePin:_currentmusic.story_name];
    //拼接字符串
   _urlStr = [ZXDMusic initWithStr:stID name:storyName];
}

-(void)setDataArr:(NSMutableArray *)dataArr
{
    [ZXDSingTool initializeWithArray:dataArr];
}
//为什么会重复播放？
//先实现。在缓存中读和存
//为什么会多个播放
#pragma mark 播放音乐
-(void)startPlayingMusic
{
    //控制button状态
    [self isPlayMusic];
    //停止
    ZXDMusic *playingMusic = [ZXDSingTool playingMusic];
    [ZXDAVdioTool stopMusicWithMusicFileName:playingMusic.filename];
    [ZXDSingTool setUpPlayingMusic:_currentmusic];
    //播放
    //当歌曲放完的时候产回调
    _currentPlayer = [ZXDAVdioTool playingMusicWithMusicFileName:_currentmusic.filename];
//    //设置disc
    [self addDiscViewSet:self.discViewArray[0]];
    //添加slider进程定时
    [self removeProgressTimer];
    [self addProgressTimer];
}

#pragma mark - 创建UI
-(void)createUI
{
    //创建背景视图
    [self createMaskView];
    //创建背景视图
    [self createTitleView];
    //创建slider
    [self creatSlider];
    //创建btn
    [self createBtns];
    //创建唱片视图
    [self createDiscView];
    //创建时间
    [self createTimeLabel];
}

//创建背景视图
-(void)createMaskView
{
    _baseImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ZXDScreenW, ZXDScreenH)];
    _baseImgView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:_baseImgView];
}

//创建标题视图
-(void)createTitleView
{
    _titleView = [[ZXDTitleView alloc] initWithFrame:CGRectMake(40, 40, ZXDScreenW - 80, 70)];
    [self.view addSubview:_titleView];
}

#pragma mark - 创建slider控件与事件
- (void)creatSlider
{
    //1.添加滑块
    _slid = [[UISlider alloc] initWithFrame:CGRectMake((ZXDScreenW - 260)/2, (ZXDScreenH - 175), 260, 20)];
    // 2.改变滑块的图片
    [_slid setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
    [self.view addSubview:_slid];
    
    [_slid addTarget:self action:@selector(startTouchSlider) forControlEvents:UIControlEventTouchDown];
    
     [_slid addTarget:self action:@selector(entTouchSlider) forControlEvents:UIControlEventTouchUpInside];
    
    [_slid addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
    //添加手势
    UITapGestureRecognizer *tapRecognize = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sliderClick:)];
    [_slid addGestureRecognizer:tapRecognize];
}

//创建btn
-(void)createBtns
{
    _consoleView = [[ZXDConsoleView alloc] initWithFrame:CGRectMake((ZXDScreenW-220)/2, ZXDScreenH-140, 220, 80)];
    [_consoleView addTarget:self action:@selector(buttonClicked:)];
    [self.view addSubview:_consoleView];
}

//创建唱片视图
-(void)createDiscView
{
    ZXDDiscView *discView1 = [[ZXDDiscView alloc] initWithFrame:CGRectMake(20, 140, ZXDScreenW-40, ZXDScreenW-40)];
    
    [discView1 addObserver:self forKeyPath:@"switchRotate" options:NSKeyValueObservingOptionNew context:nil];
    discView1.delegate = self;
    
    [self.view addSubview:discView1];
    
    ZXDDiscView *discView2 = [[ZXDDiscView alloc] initWithFrame:CGRectMake(20, 140, ZXDScreenW-40, ZXDScreenW-40)];
    
    discView2.delegate = self;
    discView2.alpha = 0;
    [self.view insertSubview:discView2 belowSubview:discView1];

    [self.discViewArray addObject:discView1];
    [self.discViewArray addObject:discView2];
}

//创建时间条
-(void)createTimeLabel
{
    _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, ZXDScreenH - 175, 40, 20)];
    [_currentTimeLabel setFont: [UIFont systemFontOfSize:14]];
    _currentTimeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_currentTimeLabel];
    
    _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(ZXDScreenW - 50, ZXDScreenH - 175, 40, 20)];
    [_totalTimeLabel setFont: [UIFont systemFontOfSize:14]];
    _totalTimeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_totalTimeLabel];    NSLog(@"totalTimeLabel:%@",_totalTimeLabel.text);

    //设置时间
    self.currentTimeLabel.text = [NSString stringWithTime:_currentPlayer.currentTime];
    self.totalTimeLabel.text = [NSString stringWithTime:_currentPlayer.duration];
}

-(void)buttonClicked:(UIButton *)sender
{
    ZXDConsoleBtn *btn = (ZXDConsoleBtn *)sender;
    switch (btn.consoleType) {
        case ZXDConsoleBtnTypePlay:
        case ZXDConsoleBtnTypePause:
            [self isPlayMusic];
            break;
        case ZXDConsoleBtnTypeLast:
            [self loadingLastMusic];
            break;
        case ZXDConsoleBtnTypeNext:
            [self loadingNextMusic];
            break;
        default:
            break;
    }
}

//上一首
-(void)loadingLastMusic
{
    ZXDMusic *nsxtMusic = [ZXDSingTool previousMusic];
    _currentmusic = nsxtMusic;
    [self playMusicWithMusic:nsxtMusic];
}
//下一首
-(void)loadingNextMusic
{
    ZXDMusic *nsxtMusic = [ZXDSingTool nextMusic];
    _currentmusic = nsxtMusic;
    [self playMusicWithMusic:nsxtMusic];
}

- (void)playMusicWithMusic:(ZXDMusic *)muisc
{
    if (_discViewArray[0].switchRotate) {
        _discViewArray[0].switchRotate = NO;
    }
    [_discViewArray[0] takeOutDiscAnim];
    [_discViewArray[1] takeInDiscAnim];
    
    // 获取当前播放的音乐并停止
    ZXDMusic *playingMusic = [ZXDSingTool playingMusic];
    [ZXDAVdioTool stopMusicWithMusicFileName:playingMusic.filename];

    // 设置下一首或者上一首为默认播放音乐
    [ZXDSingTool setUpPlayingMusic:muisc];

    // 更新界面
    [self addDiscViewSet:self.discViewArray[1]];
}

#pragma mark - 隐藏navigationBar
-(void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

-(void)dealloc
{
    [_discViewArray[0] removeObserver:self forKeyPath:@"switchRotate"];
}

#pragma mark - KVO switchRotate
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"switchRotate"]) {
        BOOL switchRotate=[change[NSKeyValueChangeNewKey] boolValue];
        _consoleView.playBtn.consoleType=switchRotate?ZXDConsoleBtnTypePause:ZXDConsoleBtnTypePlay;
    }
}

#pragma mark - DiscViewDelegate
-(void)changeDiscDidStart
{
    _consoleView.consoleBtnEnabled=NO;
    if (_consoleView.playBtn.consoleType != ZXDConsoleBtnTypePlay) {
        _consoleView.playBtn.consoleType = ZXDConsoleBtnTypePlay;
    }
    
    _discViewArray[0].alpha = 0.0;
    _discViewArray[1].alpha = 1.0;
}

-(void)changeDiscDidFinish
{
    _consoleView.consoleBtnEnabled=YES;
    if (_consoleView.playBtn.consoleType != ZXDConsoleBtnTypePause) {
        _consoleView.playBtn.consoleType = ZXDConsoleBtnTypePause;
    }
    
    [_discViewArray[0] removeObserver:self forKeyPath:@"switchRotate"];
    [_discViewArray[1] addObserver:self forKeyPath:@"switchRotate" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.view bringSubviewToFront:_discViewArray[1]];
    
    [_discViewArray exchangeObjectAtIndex:0 withObjectAtIndex:1];
    
    if (!_discViewArray[0].switchRotate) {
        [self startPlayingMusic];
    }
}

#pragma mark - 定时
-(void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

-(void)addProgressTimer
{
    [self upDateProgressInfo];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(upDateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

-(void)upDateProgressInfo
{
    // 1.更新播放的时间
    self.currentTimeLabel.text = [NSString stringWithTime:self.currentPlayer.currentTime];
    self.totalTimeLabel.text = [NSString stringWithTime:_currentPlayer.duration];
    // 2.更新滑动条
    self.slid.value = self.currentPlayer.currentTime / self.currentPlayer.duration;
}

#pragma mark - slider 事件处理
- (void)startTouchSlider {
    [self removeProgressTimer];
}

- (void)entTouchSlider {
    // 更新播放的时间
    self.currentPlayer.currentTime = self.slid.value * self.currentPlayer.duration;
    [self addProgressTimer];
}

- (void)progressValueChange:(id)sender {
    
    NSString *string = [NSString stringWithTime:self.slid.value * self.currentPlayer.duration];
    self.currentTimeLabel.text = string;
}

//手势
- (void)sliderClick:(UITapGestureRecognizer *)sender {
    // 获取点击到的点
    CGPoint point = [sender locationInView:sender.view];
    // 计算占全部长度的比例
    CGFloat num = point.x / self.slid.frame.size.width;
    // 设置当前需要播放的时间
    self.currentPlayer.currentTime = num * self.currentPlayer.duration;
    // 更新slider
    [self upDateProgressInfo];
}

-(void)isPlayMusic
{
    //当歌曲放完的时响应一下
    //响应怎么做？？
    //再次播放一遍
    if (self.currentPlayer.playing) {
        // 1.暂停播放器
        [self.currentPlayer pause];
        // 2.移除定时器
        [self removeProgressTimer];
        // 3.暂停旋转动画
    } else {
        // 1.开始播放
        [self.currentPlayer play];
        // 2.添加定时器
        [self addProgressTimer];
        // 3.恢复动画
    }
    _discViewArray[0].switchRotate=!_discViewArray[0].switchRotate;
}

-(void)addDiscViewSet:(ZXDDiscView *)discView
{
    // 获取当前正在播放的音乐
    ZXDMusic *playingMusic = [ZXDSingTool playingMusic];
    
    //设置背景图片
    [_baseImgView sd_setImageWithURL:[NSURL URLWithString:playingMusic.img_url]];
    //渲染图片
    _baseImgView.image = [[_baseImgView.image blurImage] jy_lucidImage];

    //设置歌手图片
    [discView disc_setImageWithUrl:[NSURL URLWithString:playingMusic.img_url]];
    //设置名称
    _titleView.singModel = playingMusic;
}
-(void)initDiscViewSet:(ZXDDiscView *)discView
{
    // 获取当前正在播放的音乐
    ZXDMusic *playingMusic = [ZXDSingTool playingMusic];
    
    //设置背景图片
    [_baseImgView sd_setImageWithURL:[NSURL URLWithString:playingMusic.img_url]];
    //渲染图片
    _baseImgView.image = [[_baseImgView.image blurImage] jy_lucidImage];
    
    //设置歌手图片
    [discView disc_setImageWithImage:[UIImage imageNamed:@"QQ20180423-203248"]];
    //设置名称
    _titleView.singModel = playingMusic;
}
@end