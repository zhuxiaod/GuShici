//
//  ZXDRecordViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/4/25.
//  Copyright © 2018年 zxd. All rights reserved.
//
#import "ZXDPlayMusicViewController.h"
#import "ZXDRecordViewController.h"
#import "ZXDMusic.h"
#import "ZXDWriteViewController.h"

# define COUNTDOWN 60

@interface ZXDRecordViewController (){
    NSTimer *_timer;//定时器
    NSInteger countDown;//倒计时
    NSString *filePath;
}

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (nonatomic,strong) AVAudioSession *session;
@property (nonatomic,strong) AVAudioRecorder *recorder;//录音器
@property (nonatomic,strong) AVAudioPlayer *player;//播放器
@property (nonatomic,strong) NSURL *recordFileUrl;//录音地址
@property (nonatomic,strong) FMDatabaseQueue *queue;
@property (nonatomic,strong) NSMutableArray *MusicData;
@property (weak, nonatomic) IBOutlet UIImageView *BGimage;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation ZXDRecordViewController

-(NSMutableArray *)MusicData{
    
    if(!_MusicData){
        _MusicData = [NSMutableArray array];
    }
    return _MusicData;
}

-(NSMutableArray *)dataArray{
    
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = _array;
    _BGimage.image = [UIImage imageNamed:_currentmusic.music_bimag];
    [self createTextView];
}

-(void)createTextView
{
    NSError *error;
    
    NSString *txt = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:_currentmusic.music_image ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    _textView.textColor = [UIColor blackColor];
    _textView.text = txt;
    _textView.editable = NO;
    _textView.selectable = NO;
    _textView.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
    _musicNameLabel.text = _currentmusic.music_name;
    [_musicNameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
}

- (IBAction)startRecord:(UIButton *)sender {
    NSLog(@"开始录音");
    
    countDown = 0;
    [self addTimer];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
    {
        NSLog(@"Error creating session:%@",[sessionError description]);
        
    }else{
        [session setActive:YES error:nil];
    }
    
    self.session = session;
    
    //1.获取沙盒地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    filePath = [path stringByAppendingString:@"/Record.wav"];
    
    //2.获取文件路径
    self.recordFileUrl = [NSURL fileURLWithPath:filePath];
    
    //设置参数
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
    //采样率
    [NSNumber numberWithFloat:8000.0], AVSampleRateKey,
    //音频格式
    [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
    //采样位数 8、16、24、32 默认为16
    [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
    //音频通道数 1 或 2
    [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
    //录音质量
    [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
    nil];
    
    _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:recordSetting error:nil];
    
    if (_recorder){
        _recorder.meteringEnabled = YES;
        [_recorder prepareToRecord];
        [_recorder record];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //停止录音
            [self stopRecord:nil];
        });
        
    }else{
        NSLog(@"音频格式和文件存储格式不匹配,无法初始化Recorder");
    }
}
- (IBAction)stopRecord:(UIButton *)sender {
    
    [self removeTimer];
    NSLog(@"停止录音");
    //如果正在录音 那么停止
    if([self.recorder isRecording]){
        [self.recorder stop];
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if([manager fileExistsAtPath:filePath]){
        
        _timeLabel.text = [NSString stringWithFormat:@"已录制 %ld 秒",countDown];
        //文件大小
//        [[manager attributesOfItemAtPath:filePath error:nil] fileSize]/1024.0
    }else{
        _timeLabel.text = @"最多录60秒";
    }
}


- (IBAction)playRecord:(UIButton *)sender {
    
    NSLog(@"播放录音");
    [self.recorder stop];
    
    if([self.player isPlaying])return;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordFileUrl error:nil];
    
    NSLog(@"%li",self.player.data.length/1024);
    
    [self.session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.player play];
     _timeLabel.text = @"正在播放";
}


- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(refreshLabelText) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}

-(void)refreshLabelText{
    countDown ++;
    _timeLabel.text = [NSString stringWithFormat:@"已录制 %ld 秒",countDown];
}
- (IBAction)pushWriteView:(UIButton *)sender {
    ZXDWriteViewController *writeVC = [[ZXDWriteViewController alloc] init];
    writeVC.musicTitle = _currentmusic.music_name;
    [self.navigationController pushViewController:writeVC animated:YES];
    
}
- (IBAction)pushMusicView:(UIButton *)sender {
    ZXDPlayMusicViewController *musicVC = [[ZXDPlayMusicViewController alloc] init];
    musicVC.currentmusic = _currentmusic;
    musicVC.dataArr = self.dataArray;
    [self.navigationController pushViewController:musicVC animated:YES];
}
@end
