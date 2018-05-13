//
//  ZXDAdViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/3/27.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDAdViewController.h"
#import "ZXDADitem.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>
#import "ZXDTabBarViewController.h"

#define ZXDScreenW [UIScreen mainScreen].bounds.size.width
#define ZXDScreenH [UIScreen mainScreen].bounds.size.height
#define iphone6P (ZXDScreenH == 736)
#define iphone6 (ZXDScreenH == 667)
#define iphone5 (ZXDScreenH == 568)
#define iphone4 (ZXDScreenH == 480)

#define posid @"?posid=2070428800581920&ext=%257B%2522req%2522%253A%257B%2522loc_accuracy%2522%253A0%252C%2522sdk_src%2522%253A%2522%2522%252C%2522muidtype%2522%253A2%252C%2522c_isjailbroken%2522%253Afalse%252C%2522jsver%2522%253A%25221.4.0%2522%252C%2522m5%2522%253A%252240958063-4097-4CE3-A3AF-8216AAA47E32%2522%252C%2522c_device%2522%253A%2522iPhone%25205s%2522%252C%2522c_h%2522%253A1136%252C%2522m6%2522%253A%2522f72157df6c282f8e404f3a5caee6e3d6%2522%252C%2522muid%2522%253A%252266c50d7c46a1c4b0f341e427c411344f%2522%252C%2522c_pkgname%2522%253A%2522com.youyizhidao.childstory%2522%252C%2522c_os%2522%253A%2522ios%2522%252C%2522lng%2522%253A0%252C%2522scs%2522%253A%25220001fc885686%2522%252C%2522conn%2522%253A1%252C%2522c_hl%2522%253A%2522zh%2522%252C%2522c_w%2522%253A640%252C%2522c_devicetype%2522%253A1%252C%2522carrier%2522%253A3%252C%2522c_sdfree%2522%253A4864704512%252C%2522lat%2522%253A0%252C%2522c_ori%2522%253A0%252C%2522c_dpi%2522%253A320%252C%2522sdkver%2522%253A%25224.5.0%2522%252C%2522deep_link_version%2522%253A1%252C%2522postype%2522%253A8"

@interface ZXDAdViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *launchImageView;
@property (weak, nonatomic) IBOutlet UIView *addContaintView;
@property (weak, nonatomic) UIImageView *adView;
@property (strong, nonatomic) ZXDADitem *adItem;
@property (weak, nonatomic) IBOutlet UIButton *jumpBtn;
//创建时间器
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation ZXDAdViewController
- (IBAction)clickBtn {
    //销毁广告页面,跳转主框架页面
    ZXDTabBarViewController *tabBarVc = [[ZXDTabBarViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarVc;
    //销毁定时器
    [_timer invalidate];
}


-(UIImageView *)adView
{
    if(_adView == nil){
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.addContaintView addSubview:imageView];
        _adView = imageView;
    }
    return _adView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //启动图片
    [self setupLaunchImageView];
    //加载广告数据
    [self loadAdData];
    
    //创建定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
}

-(void)timeChange
{
    //倒计时
    static int i = 0;
    
    //如果计时器变为0了？
    if(i == 0)
    {
        [self clickBtn];
    }
    
    i--;
    
    [_jumpBtn setTitle:[NSString stringWithFormat:@"跳转(%d)",i] forState:UIControlStateNormal];
    
}

#pragma mark - 加载广告数据
-(void)loadAdData
{
    //注意info开关 => 响应头设置
    //1.创建请求回话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"posid"] = posid;
    
    //3.发送请求
    [mgr GET:@"http://mi.gdt.qq.com/gdt_mview.fcg" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task,  NSDictionary *  _Nullable responseObject) {
        
        [responseObject writeToFile:@"/Users/zxd/Documents/GuShiCi/GuShiCi/classes/AD(广告)/ad.plist" atomically:YES];
        
        //请求数据 -->  解析数据(写成plist文件)  --> 设计模型 --> 字典转模型 -->  展示数据
        NSLog(@"%@",responseObject);
        
        //获取字典
//        NSDictionary *adDict = [responseObject valueForKey:@"data"];
//        NSLog(@"%@",adDict);
//
        //字典转模型
//        _adItem = [ZXDADitem mj_objectWithKeyValues:adDict];
        
        
        //创建UIImageView展示图片 =>
//        CGFloat h = ZXDScreenW / _adItem.w * _adItem.h;
//        self.adView.frame = CGRectMake(0, 0, ZXDScreenW, h);
//
//        //加载广告网页
//        [self.adView sd_setImageWithURL:[NSURL URLWithString:@"http://pic.58pic.com/58pic/11/36/99/35558PIC2PS.jpg"]];
//#warning 字典为空  需要新的接口
//        //得到字典 -> 抓包
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}

-(void)setupLaunchImageView
{
    if (iphone6P) {
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    }else if (iphone6){
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-800-667h@2x"];
    }else if (iphone5){
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-700-568h@2x"];
    }else if (iphone4){
        self.launchImageView.image = [UIImage imageNamed:@"LaunchImage-700@2x"];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
