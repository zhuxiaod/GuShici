//
//  ZXDTabBarViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/3/25.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDTabBarViewController.h"
#import "ZXDMeViewController.h"
#import "ZXDHomeViewController.h"
#import "ZXDVideoTableViewController.h"
#import "UIImage+ZXDImage.h"
#import "ZXDNavigationViewController.h"

@interface ZXDTabBarViewController ()

@end

@implementation ZXDTabBarViewController

/*
 1.选中的图片被渲染
 2.选中标题颜色：黑色。标题字体大
 */

+(void)load
{
    /*
        apperance
     
        注意：
        1.只要遵守UIAppearance协议，才能实现此方法
        2.那些属性可以通过appearance设置，只有被UI_APPEARANCE_SELECTOR宏修饰的属性，
     才能设置
     
        1.图片太大，系统帮你渲染 => 取消渲染后，能显示 => 位置不对，修改内编剧 => 但是高亮状态达不到
     
     */
    
    //获取整个应用程序下的UITabBarItem
//    UITabBarItem *item = [UITabBarItem appearance];
    
    //获取那个类中的UITabBarItem
    UITabBarItem *item = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[[UIView class]]];
    
    //设置按钮选中标题的颜色：富文本：描述一个文字颜色，字体，阴影，空心，图文混排
    //创建一个描述文本属性的字典
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    //字体只能在正常状态下设置
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    attrsNor[NSFontAttributeName] =  [UIFont systemFontOfSize:13];
    [item setTitleTextAttributes:attrsNor forState:UIControlStateNormal];
}
#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAllChildViewController];
    
    [self setupAllTittleButton];
    
}


#pragma mark - 添加所有子控制器
-(void)setupAllChildViewController
{
    //2.1添加子控制器 -> 自定义控制器  ->划分项目文件结构
    //首页
    ZXDHomeViewController *homeVc = [[ZXDHomeViewController alloc]init];
    ZXDNavigationViewController *nav = [[ZXDNavigationViewController alloc]initWithRootViewController:homeVc];
    [self addChildViewController:nav];
    
    
    //视频
    ZXDVideoTableViewController *videoVc = [[ZXDVideoTableViewController alloc]init];
    ZXDNavigationViewController *nav1 = [[ZXDNavigationViewController alloc]initWithRootViewController:videoVc];
    [self addChildViewController:nav1];
    
    //我
    ZXDMeViewController *meVc = [[ZXDMeViewController alloc]init];
    ZXDNavigationViewController *nav2 = [[ZXDNavigationViewController alloc]initWithRootViewController:meVc];
    [self addChildViewController:nav2];
}

//设置所有button上的内容
-(void)setupAllTittleButton
{
    //2.2设置tabBar上按钮内容 ->由对应的子控制器
    //0:nav
    UINavigationController *nav = self.childViewControllers[0];
    nav.tabBarItem.title = @"首页";
    nav.tabBarItem.image = [UIImage imageOriginalWithName:@"tabBar_essence_icon"];
    UIImage *image = [UIImage imageOriginalWithName:@"tabBar_essence_click_icon"];
    nav.tabBarItem.selectedImage = image;
    
    //1:nav1
    UINavigationController *nav1 = self.childViewControllers[1];
    nav1.tabBarItem.title = @"视频";
    nav1.tabBarItem.image = [UIImage imageOriginalWithName:@"tabBar_me_icon"];
    nav1.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_me_click_icon"];

    //2:nav2
    UINavigationController *nav2 = self.childViewControllers[2];
    nav2.tabBarItem.title = @"关于";
    nav2.tabBarItem.image = [UIImage imageOriginalWithName:@"tabBar_friendTrends_icon"];
    nav2.tabBarItem.selectedImage = [UIImage imageOriginalWithName:@"tabBar_friendTrends_click_icon"];
}

@end
