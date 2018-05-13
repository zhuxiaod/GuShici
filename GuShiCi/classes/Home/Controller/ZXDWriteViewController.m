//
//  ZXDWriteViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/5/4.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDWriteViewController.h"
#import "ZXDRecommendButton.h"
#import "BtnCell.h"
#import "DrawView.h"
#import "ZXDColorSelectedView.h"
#import "ZXDHanZi.h"
#import "ZXDSetupView.h"
#import "ZXDPreViewController.h"

@interface ZXDWriteViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,ZXDColorSelectedViewDelegate,DrawViewDelegate,ZXDSetupViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *backGroundlabel;
@property (weak, nonatomic) IBOutlet DrawView *drawView;
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (weak, nonatomic) IBOutlet UIButton *textBtn;
@property (nonatomic, assign)NSInteger selected; //记录选中状态
@property (nonatomic, strong)NSMutableArray *dataArray;//数组中添加选中时候的tag值
@property (nonatomic, assign)NSInteger selectedFR; //记录选中状态
@property (strong, nonatomic)ZXDSetupView *setupView;
@property (strong, nonatomic)ZXDColorSelectedView *colorView;
//现在是什么字
@property (nonatomic,strong)ZXDHanZi *hanZi;
//写字的数据源
@property (nonatomic, strong)NSArray *dataArr;

@end
static NSString *collectionViewID = @"CollectionCell";

@implementation ZXDWriteViewController

- (NSArray *)dataArr
{
    if(!_dataArr){
        [self createData];
    }
    return _dataArr;
}

//清屏
- (IBAction)clear:(UIButton *)sender {
     [self.drawView clear];
}
//撤销
- (IBAction)undo:(UIButton *)sender {
    [self.drawView undo];
}
//选择颜色
- (IBAction)colorList:(UIButton *)sender {
    [_colorView removeFromSuperview];
    _colorView = [[ZXDColorSelectedView alloc] initWithFrame:CGRectMake(ZXDScreenW/2-151,ZXDScreenH/2 - 86, 302, 172)];
    _colorView.backgroundColor = [UIColor grayColor];
    _colorView.delegate = self;
    [self.view addSubview:_colorView];
    //使用CABasicAnimation创建基础动画
    CABasicAnimation *aimation = [[CABasicAnimation alloc] init];
    [aimation createWYAnimation:CGPointMake(ZXDScreenW/2, ZXDScreenH) toValue:CGPointMake(ZXDScreenW/2, ZXDScreenH/2) duration:0.3f objc:_colorView.layer];
}
//清除全部
- (IBAction)allDelete:(UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否确定全部重写" message:nil preferredStyle:UIAlertControllerStyleAlert ];
    
    //添加取消到UIAlertController中
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        for (ZXDHanZi *zi in self.dataArr) {
            zi.allPath = nil;
        }
        self.hanZi.allPath = nil;
        [self.drawView reDraw];
        [self reloadView];
    }];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
//设置视图
- (IBAction)setupView:(UIButton *)sender {
    
    [_setupView removeFromSuperview];
    _setupView = [[ZXDSetupView alloc] init];
    _setupView.frame = CGRectMake(self.view.frame.size.width/2-125 , ZXDScreenH/2 - 100, 250, 210);
    self.setupView = _setupView;
    _setupView.delegate = self;
   [self.view addSubview:_setupView];

    //使用CABasicAnimation创建基础动画
    CABasicAnimation *aimation = [[CABasicAnimation alloc] init];
    [aimation createWYAnimation:CGPointMake(ZXDScreenW/2, ZXDScreenH) toValue:CGPointMake(ZXDScreenW/2, ZXDScreenH/2) duration:0.3f objc:_setupView.layer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DrawView *drawView = [[DrawView alloc] init];
    _drawView = drawView;
    
    //初始化属性
    [self initProperty];
    _hanZi = [[ZXDHanZi alloc] init];
    //设置backView图片
    [self setupBackViewImage:[UIImage imageNamed:@"45BC001AD7DD6628767E43D65DACB47C"]];
    //设置button样式
    [self setupButtonStyle:self.textBtn];
    
    //设置CollectionView
    [self setupCollectionView];
    
    //添加预览按钮
    [self setupNavBar];
}

#pragma mark - 设置导航条
-(void)setupNavBar
{
    //右边导航条
    //左边导航条
    //把UIButton包装成UIButtonItem,导致点击区域变大
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"预览" target:self action:@selector(preview)];
    
    //中间导航条
    self.navigationItem.title = @"写一写";
}
//将当前数组中的线画出来。然后在保存
//做一个保存的操作
//将数组中的内容一个一个的取出来。然后内容重新绘制成图片
#pragma mark 预览页跳转
-(void)preview{
    //获取每一个cell
    //最后一个cell
//    ZXDHanZi *hanzi1 = [self.dataArr objectAtIndex:19];
//    NSLog(@"%lu",_dataArray.count - 1);
//    hanzi1.allPath = _hanZi.allPath;
    for (int i = 0;i < self.dataArr.count;i++) {
        ZXDHanZi *hanzi = [self.dataArr objectAtIndex:i];
        self.drawView.ZXDNewAllPath = hanzi.allPath;
        //画好了  截图
        //1.开启一个位图上下文
        UIGraphicsBeginImageContextWithOptions(self.drawView.bounds.size, NO, 0);
        //2.把画板上的内容渲染到上下文当中
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [self.drawView.layer renderInContext:ctx];
        //3.从上下文当中取出一张图片
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        //4.关闭上下文
        UIGraphicsEndImageContext();
        //将图片加入到数组之中
        hanzi.image = newImage;
    }
    ZXDPreViewController *preViewVC = [[ZXDPreViewController alloc] init];
    preViewVC.hidesBottomBarWhenPushed = YES;
    preViewVC.dataArray = self.dataArr;
    [self.navigationController pushViewController:preViewVC animated:YES];
}
//初始化属性
-(void)initProperty{
    self.selected = -1;
    self.selectedFR = 0;
    self.drawView.delegate = self;
}

//设置写字的背景图片
-(void)setupBackViewImage:(UIImage *)image
{
    UIImage *backViewImage = image;
    self.backView.image = backViewImage;
}
//初始化数据源
-(void)createData
{
    NSString *str = @"春眠不觉晓处处闻啼鸟夜来风雨声花落知多少";
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < str.length; i++) {
        ZXDHanZi *hanZi = [[ZXDHanZi alloc] init];
        hanZi.ZXDhanZi = [str substringWithRange:NSMakeRange(i, 1)];
        [array  addObject:hanZi];
        self.dataArr = array;
    }
}
//设置CollectionView
-(void)setupCollectionView
{
    //进行CollectionView和Cell的绑定
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BtnCell class]) bundle:nil]  forCellWithReuseIdentifier:collectionViewID];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    //隐藏
    self.collectionView.showsVerticalScrollIndicator = NO;
    //修改颜色
    self.collectionView.indicatorStyle=UIScrollViewIndicatorStyleWhite;
}
//设置button风格
-(void)setupButtonStyle:(UIButton *)button
{
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 2;
}
#pragma mark - collectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BtnCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionViewID forIndexPath:indexPath];
    ZXDHanZi *Hanzi = self.dataArr[indexPath.row];
    cell.lable.text = Hanzi.ZXDhanZi;
    cell.selected = NO;
    //点击样式
    if(indexPath.row == self.selected && self.selected != -1){
        cell.selected = YES;
    }
    //默认第一行样式 初始化
    if (indexPath.row == 0 && self.selectedFR == 0){
        cell.selected = YES;
        _hanZi = Hanzi;
    }
    //让上面的代码只运行一次
    self.selectedFR = 1;
    return cell;
}
//collectionView点击代理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击cell效果
    self.selected = indexPath.row;
    ZXDHanZi *hanZi = self.dataArr[indexPath.row];
    _hanZi = hanZi;
    //显示当前字的线条
    self.drawView.ZXDNewAllPath = _hanZi.allPath;
    
    //显示背景
    _backGroundlabel.text = hanZi.ZXDhanZi;
    if(self.selected != 0){
        UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.selected = NO;
    }
}
//bug : 最后一个cell并没有被点击 因此没有他的draw 没有被加入
#pragma mark - 跳转输入文字窗口
- (IBAction)putInText:(UIButton *)sender {
    ZXDPutInTextViewController *PITVC = [[ZXDPutInTextViewController alloc] init];
    PITVC.hidesBottomBarWhenPushed = YES;
    PITVC.returnDicBlock = ^(NSDictionary *dic) {
        //把故事取出来了
        NSString *str = [dic objectForKey:@"content"];
        //去掉空格
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < str.length; i++) {
            //这里 创建一个对象把字装着
            NSString *str1 = [str substringWithRange:NSMakeRange(i, 1)];
            ZXDHanZi *hanZi = [[ZXDHanZi alloc] init];
            hanZi.ZXDhanZi = str1;
            [array  addObject:hanZi];
            self.dataArr = array;
            [self reloadView];
        }
    };
    [self.navigationController pushViewController:PITVC animated:YES];
}
#pragma mark - DrawViewDelegate
-(void)DrawView:(DrawView *)DrawView allpath:(NSMutableArray *)allpath
{
    //把写的字加入当前cell
    _hanZi.allPath = allpath;
    NSLog(@"%@",allpath);
}
//刷新页面
-(void)reloadView{
    ZXDHanZi *hanzi = self.dataArr[0];
    self.backGroundlabel.text = hanzi.ZXDhanZi;
    self.selected = -1;
    self.selectedFR = 0;
    [self.collectionView reloadData];
}
#pragma mark - colorViewDelegate
-(void)ZXDColorSelectedView:(ZXDColorSelectedView *)ZXDColorSelectedView selectColor:(UIColor *)selectColor
{
    [self.drawView setLineColor:selectColor];
}
#pragma mark - setupViewDelegate
-(void)ZXDSetupView1:(ZXDSetupView *)ZXDSetupView slider1:(UISlider *)slider
{
    [self.drawView setLineWidth:slider.value];
}

-(void)ZXDSetupView2:(ZXDSetupView *)ZXDSetupView slider2:(UISlider *)slider2
{
    _backGroundlabel.font = [UIFont boldSystemFontOfSize:slider2.value];
}
-(void)ZXDSetupView:(ZXDSetupView *)ZXDSetupView btn:(UIButton *)btn
{
    [self.setupView removeFromSuperview];
}
//差一个页面弹出动画                            ok
//预览按钮
//设置字体页面 --> 控制笔的大小 控制背景label的大小 ok
@end
