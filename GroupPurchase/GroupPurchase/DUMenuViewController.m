//
//  DUMenuViewController.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUMenuViewController.h"

@interface DUMenuViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSArray *_pictureArray;
    NSArray *_titleArray;
    UIImageView *_imageView;
}
@end

@implementation DUMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self uiConfig];
    [self prepareData];
    
    
}

- (void)uiConfig
{
    //以组的形式显示
   
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 2, self.view.frame.size.height) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)prepareData
{
    _dataArray = [[NSMutableArray alloc] init];
    _pictureArray=[NSArray arrayWithObjects:@"88-all",@"88-nvz-new",@"88-nz",@"88-xb",@"88-fw",@"88-my",@"88-jj",@"88-qt", nil];
    _titleArray=[NSArray arrayWithObjects:@"     折扣风",@"     天生尤物",@"     潮流男装",@"     鞋包配饰",@"     风味美食",@"     母婴用品",@"     家居百货",@"     其他类品", nil];
    
    for (int i = 0 ; i < _titleArray.count;  i ++) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 30, 30)];
        _imageView.image = [UIImage imageNamed:_pictureArray[i]];
        
        [_dataArray addObject:_imageView];
    }
    
}


#pragma mark --- 实现数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    //每隔一行换一个颜色
    cell.contentView.backgroundColor =  indexPath.row % 2 ==0 ?[UIColor lightGrayColor]:[UIColor grayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:_dataArray[indexPath.row]];
    return cell;
}


#pragma mark -- 选中某一行的时候
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"menu" object:nil];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *array = [NSArray arrayWithObjects:@(indexPath.row),cell.textLabel.text, nil];
    NSLog(@"%ld",indexPath.row);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"category" object:array];
    
}






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
