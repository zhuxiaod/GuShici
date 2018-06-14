//
//  ZXDNavigationViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/3/27.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDNavigationViewController.h"
#import "UIBarButtonItem+Item.h"

@interface ZXDNavigationViewController ()

@end

@implementation ZXDNavigationViewController
+(void)load
{
    //设置导航条标题 =>  UINavigationBar
    UINavigationBar *nac = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[UIView class]]];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [nac setTitleTextAttributes:attrs];
    nac.translucent = NO;
    
    //设置导航条背景图片
    [nac setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
//    [nac setBackgroundColor:[UIColor redColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //全屏滑动
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    [self.view addGestureRecognizer:pan];
    
    pan.delegate = self;
}

//如果非根子控制器则可以滑动
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.childViewControllers.count > 1;
}

//重写push方法 => push后如果是非根控制器便添加一个返回按钮
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //这里还是有一点不懂。不懂子控制器。 是如何计算的
    if(self.childViewControllers.count > 0)
    {
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) title:@"返回"];
    }
    
    [super pushViewController:viewController animated:YES];

}
-(void)back
{
    [self popViewControllerAnimated:YES];
    
}


@end
