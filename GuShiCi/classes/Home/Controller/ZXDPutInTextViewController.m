//
//  ZXDPutInTextViewController.m
//  GuShiCi
//
//  Created by zxd on 2018/5/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDPutInTextViewController.h"
#import "ZXDTangShiCell.h"
#import "ZXDTangShi.h"
@interface ZXDPutInTextViewController ()<NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *dataArr;

// 当前标签的名字
@property (strong, nonatomic) NSString *currentTagName;
/// @brief 记录当前编辑的xml结点对象
@property (nonatomic, strong)NSMutableDictionary * currentDictionary;
/// @brief 记录当前编辑的xml结点对象的key值
@property (nonatomic, copy)NSString * currentDictionaryKey;

@end

NSString *TangShiCell = @"TangShiCell";

@implementation ZXDPutInTextViewController

//Btn数据
- (NSMutableArray *)dataArr
{
    if(!_dataArr){
        //说明模型和plist有问题
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
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
        //到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新tableView
            [self.tableView reloadData];
        });
    });
    
    //1.注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ZXDTangShiCell class]) bundle:nil] forCellReuseIdentifier:TangShiCell];

}

//创建tabView
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZXDTangShiCell *cell = [tableView dequeueReusableCellWithIdentifier:TangShiCell];
    cell.tangShi = self.dataArr[indexPath.row];
    //赋值 显示
    return cell;
}

//选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArr[indexPath.row];
    __weak typeof(self) weakself = self;
    if (weakself.returnDicBlock) {
        //将自己的值传出去，完成传值
        weakself.returnDicBlock(dic);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark NSXMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //初始化存放xml数据字典的数组
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
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
        [self.dataArr addObject:elementNameDictionary];
        
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
