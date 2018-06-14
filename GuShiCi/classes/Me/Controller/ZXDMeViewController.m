//
//  ZXDMeViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/3/25.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDMeViewController.h"
#import "ZXDAboutViewController.h"
#import "ZXDHelpViewController.h"

@interface ZXDMeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tableView;
@end

@implementation ZXDMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blueColor];
    [self setupNavBar];
    //创建静态的tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ZXDScreenW, ZXDScreenH) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"stacCell"];
}
#pragma mark - UITablViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"stacCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"关于APP";
    }else if (indexPath.section == 1)
    {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = @"帮助中心";
        
    }else if (indexPath.section == 2)
    {
            cell.textLabel.text = @"清理缓存";
            cell.textLabel.textColor = [UIColor redColor];
    }else if (indexPath.section == 3)
    {
            cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            cell.textLabel.text = @"当前版本                                                     1.1";
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        //跳转关于页面
        ZXDAboutViewController *aboutView = [[ZXDAboutViewController alloc] init];
        aboutView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutView animated:YES];
    }else if (indexPath.section == 1)
    {
        ZXDHelpViewController *helpVC = [[ZXDHelpViewController alloc] init];
        helpVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:helpVC animated:YES];
    }else if (indexPath.section == 2)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否清理缓存" message:nil preferredStyle:UIAlertControllerStyleAlert ];
        
        //添加取消到UIAlertController中
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        //添加确定到UIAlertController中
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - 设置bar
-(void)setupNavBar
{
    self.navigationItem.title = @"关于";
}


@end
