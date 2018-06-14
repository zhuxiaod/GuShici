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

@interface ZXDWriteViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,ZXDColorSelectedViewDelegate,DrawViewDelegate,ZXDSetupViewDelegate,NSXMLParserDelegate>
//xib UI
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *backGroundlabel;
@property (weak, nonatomic) IBOutlet DrawView *drawView;
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (weak, nonatomic) IBOutlet UIButton *textBtn;
@property (strong, nonatomic)ZXDSetupView *setupView;
@property (strong, nonatomic)ZXDColorSelectedView *colorView;
//cell
@property (nonatomic, assign)NSInteger selected; //记录选中状态
@property (nonatomic, assign)NSInteger selectedFR; //记录选中状态

//数据源
@property (nonatomic, strong)NSMutableArray *dataArray;//数组中添加选中时候的tag值
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *guShiCi;
//模型
@property (nonatomic,strong)ZXDHanZi *hanZi;
//解析XML
@property (strong, nonatomic) NSString *currentTagName;
@property (nonatomic, strong)NSMutableDictionary * currentDictionary;
@property (nonatomic, copy)NSString * currentDictionaryKey;
@end
//cellID
static NSString *collectionViewID = @"CollectionCell";

@implementation ZXDWriteViewController

//xml写字数据源
- (NSMutableArray *)guShiCi
{
    if(!_guShiCi){
        //说明模型和plist有问题
        _guShiCi = [NSMutableArray array];
    }
    return _guShiCi;
}

- (NSMutableArray *)dataArr
{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
#pragma mark - 写字板功能
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
            //清楚每个字模型中的数据
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
    //初始化属性
    [self initProperty];
    //解析xml
    [self getXML];
    //设置backView图片
    [self setupBackViewImage:[UIImage imageNamed:@"45BC001AD7DD6628767E43D65DACB47C"]];
    //设置button样式
    [self setupButtonStyle:self.textBtn];
    //设置CollectionView
    [self setupCollectionView];
    //添加预览按钮
    [self setupNavBar];
}
#pragma mark - 解析XML
-(void)getXML{
    //创建一个异步请求
    //得到全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //解析数据
        // 将数据写入 file
        // 获取文件路径
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"phrase_tangshi" ofType:@"xml"];
        
        // 根据文件路径读取数据
        NSData *jdata = [[NSData alloc] initWithContentsOfFile:filePath];
        //4.1 创建XML解析器:SAX
        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:jdata];
        //4.2 设置代理
        parser.delegate = self;
        //4.3 开始解析,阻塞
        [parser parse];
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新tableView
            [self createData];
        });
    });
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
    //获取每一个cell,将路线绘制并加入字模型中
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
    //遍历后,画板和当前字相同
    ZXDHanZi *hanzi = [self.dataArr objectAtIndex:_selected];
    self.drawView.ZXDNewAllPath = hanzi.allPath;
    //跳转预览页
    ZXDPreViewController *preViewVC = [[ZXDPreViewController alloc] init];
    preViewVC.hidesBottomBarWhenPushed = YES;
    preViewVC.dataArray = self.dataArr;
    [self.navigationController pushViewController:preViewVC animated:YES];
}
//初始化属性
-(void)initProperty{
    self.selected = 0;
    self.selectedFR = 0;
    self.drawView.delegate = self;
    _hanZi = [[ZXDHanZi alloc] init];
}

//设置写字的背景图片
-(void)setupBackViewImage:(UIImage *)image
{
    UIImage *backViewImage = image;
    self.backView.image = backViewImage;
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
#pragma mark - 数据源
-(void)createData
{
    //有数据说明是从其他页面跳转过来,不是从首页之中
    if(!_musicTitle){
        //将字符串转化成字模型
        NSString *str = @"春眠不觉晓处处闻啼鸟夜来风雨声花落知多少";
        [self editString:str];
        
    }else{
            //查找标题相同的xml数据源
            for (int i = 0; i < self.guShiCi.count; i++) {
                NSDictionary *dic = self.guShiCi[i];
                NSString *str = [dic objectForKey:@"title"];
                NSString *str2 = [str substringWithRange:NSMakeRange(1,_musicTitle.length)];
                //对比标题
                if([str2 isEqualToString:self.musicTitle]){
                    //对xml数据进行排版
                    NSString *str = [dic objectForKey:@"content"];
                  
                    [self editString:str];
                }
            }
        }
}

-(void)editString:(NSString *)str
{
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
    }
    [self reloadView];
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
    //点击样式&& self.selected != -1
    if(indexPath.row == self.selected){
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
    //获取点到的字模型
    ZXDHanZi *hanZi = self.dataArr[indexPath.row];
    //转为当前字
    _hanZi = hanZi;
    //显示当前字的线条
    self.drawView.ZXDNewAllPath = hanZi.allPath;
    //显示背景
    _backGroundlabel.text = hanZi.ZXDhanZi;
    if(self.selected != 0){
        UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.selected = NO;
    }
}
//bug :循环20次。导致选中文字和view上的字。不一样
#pragma mark - 跳转输入文字窗口
- (IBAction)putInText:(UIButton *)sender {
    ZXDPutInTextViewController *PITVC = [[ZXDPutInTextViewController alloc] init];
    PITVC.hidesBottomBarWhenPushed = YES;
    PITVC.returnDicBlock = ^(NSDictionary *dic) {
        //把故事取出来了
        NSString *str = [dic objectForKey:@"content"];
        //去掉空格
        [self editString:str];
    };
    [self.navigationController pushViewController:PITVC animated:YES];
}
#pragma mark - DrawViewDelegate
-(void)DrawView:(DrawView *)DrawView allpath:(NSMutableArray *)allpath
{
    //把写的字加入当前cell
    _hanZi.allPath = allpath;
}
//刷新页面
-(void)reloadView{
    ZXDHanZi *hanzi = self.dataArr[0];
    self.backGroundlabel.text = hanzi.ZXDhanZi;
    self.drawView.ZXDNewAllPath = hanzi.allPath;
    self.selected = 0;
    self.selectedFR = 0;
    [self.collectionView reloadData];
}
#pragma mark - colorViewDelegate
//设置颜色
-(void)ZXDColorSelectedView:(ZXDColorSelectedView *)ZXDColorSelectedView selectColor:(UIColor *)selectColor
{
    [self.drawView setLineColor:selectColor];
}
#pragma mark - setupViewDelegate
//设置线
-(void)ZXDSetupView1:(ZXDSetupView *)ZXDSetupView slider1:(UISlider *)slider
{
    [self.drawView setLineWidth:slider.value];
}
//label大小
-(void)ZXDSetupView2:(ZXDSetupView *)ZXDSetupView slider2:(UISlider *)slider2
{
    _backGroundlabel.font = [UIFont boldSystemFontOfSize:slider2.value];
}
//关闭View
-(void)ZXDSetupView:(ZXDSetupView *)ZXDSetupView btn:(UIButton *)btn
{
    [self.setupView removeFromSuperview];
}
#pragma mark NSXMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //初始化存放xml数据字典的数组
    self.guShiCi = [NSMutableArray arrayWithCapacity:0];
}
//2.开始解析某个元素
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(nullable NSString *)namespaceURI
 qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict
{
    //表示开始遍历子结点了
    if ([elementName isEqualToString:@"phrase"])//对Person标签进行比对
    {
        //新建一个索引为elementName的key字典
        NSMutableDictionary * elementNameDictionary = [NSMutableDictionary dictionary];
        
        //将数据添加到当前数组
        [self.guShiCi addObject:elementNameDictionary];
        
        //记录当前进行操作的结点字典
        self.currentDictionary = elementNameDictionary;
    }
    //表示不是Persons的子节点,因为是else if,也保证
    else if (![elementName isEqualToString:@"phrase"])//排除Person以及Persons标签
    {
        //记录当前的结点值
        self.currentDictionaryKey = elementName;
        
        //设置当前element的值,先附初始值
        [self.currentDictionary addEntriesFromDictionary:@{elementName:@""}];
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //如果结点内容的第一个字符是‘\n’,表示是包含其他结点的结点
    if (string.length > 0 && [string characterAtIndex:0] != '\n')
    {
        //对当前字典进行初始化赋值
        [self.currentDictionary setValue:string forKey:self.currentDictionaryKey];
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //只有结束Person的时候清除相关数据
    if ([elementName isEqualToString:@"phrase"])
    {
        //cleat data
        self.currentDictionary = nil;
        self.currentDictionaryKey = nil;
    }
}
//4.结束解析
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    //    [self.tableView reloadData];
}
@end
