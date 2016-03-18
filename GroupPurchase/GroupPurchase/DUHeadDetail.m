//
//  DUHeadDetail.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/10.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUHeadDetail.h"
#import "DUAppCell.h"
#import "DUAppModel.h"
#import "AFNetworking.h"
#import "UIWebView+AFNetworking.h"
#import "DUDetailVC.h"

#define __kScreenHeight ([[UIScreen mainScreen]bounds].size.height)
#define __kScreenWidth ([[UIScreen mainScreen]bounds].size.width)


@interface DUHeadDetail ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
    NSMutableData *_data;
    UITableView *_tableView;
    UIView *view;
    NSArray *_array;
    UIScrollView *_scrollView;
    UIActivityIndicatorView *_activityView;
}
@end

@implementation DUHeadDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"今日推荐";
    [self creatButtons];
    [self uiConfig];
    
    
}

- (void)creatButtons
{
    _array = @[@"女装",@"男装",@"母婴",@"鞋包",@"家居",@"美食",@"其他"];
    NSArray *selcteArray = @[@"88-all",@"88-nvz-new",@"88-nz",@"88-xb",@"88-fw",@"88-my",@"88-jj",@"88-qt"];
    NSArray *arrayID = @[@"1",@"2",@"4",@"3",@"6",@"289",@"158"];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, __kScreenWidth, 40)];
    _scrollView.contentSize = CGSizeMake(60 * _array.count, 0);
    _scrollView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1];
    for (int i = 0; i < _array.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(5 + 60 * i , 0, 55, 40)];
        [button setTitle:_array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor yellowColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:selcteArray[i]]];
        button.tag = i + 1;
        [_scrollView addSubview:button];
//        if (button.tag == 1) {
//            button.selected = YES;
//        }
    
    }
    [self.view addSubview:_scrollView];
}


- (void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, __kScreenWidth, __kScreenHeight - 40)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    //网络等候显示

    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.backgroundColor = [UIColor purpleColor];
    _activityView.alpha = 0.6;
    _activityView.frame = CGRectMake(0, 0, 80, 80);
    _activityView.center = self.view.center;
    [_activityView startAnimating];
    [self.view addSubview:_activityView];
    
    

    //_view = [[UIView alloc]init];
    //_view.backgroundColor = [UIColor blackColor];
    
}

/*NSInteger index = tabbarItems.tag - 100;
 for (id obj in _tabbar.subviews)
 {
 if ([obj isKindOfClass:[UIButton class]])
 {
 ((UIButton *)obj).selected = NO;
 }
 tabbarItems.selected = YES;
 }*/


- (void)clickAction:(UIButton *)button
{
    NSInteger index = button.tag ;
    NSLog(@"button.tag %ld",button.tag);
  
    for (UIButton *button in _scrollView.subviews)
    {
        if ([button isKindOfClass:[UIButton class]])
        {
            ((UIButton *)button).selected = NO;
        }
        
    }
    button.selected = YES;
    
   
    
    _dataArray = [[NSMutableArray alloc]init];
    NSString *url=[NSString stringWithFormat:@"http://www.huipinzhe.com/mobapi/product/module?id=1&catid=%ld",button.tag];
    self.navigationItem.title = [NSString stringWithFormat:@"%@",_array[index - 1]];
    NSLog(@"_array--%@",_array[index - 1]);
    NSLog(@"index--%ld",index);
    NSLog(@"button.tag--%ld",button.tag);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _data = responseObject;
        
        [UIView animateWithDuration:0.8 animations:^{
            _activityView.backgroundColor = [UIColor greenColor];
            _activityView.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 0, 0);
            
        } completion:^(BOOL finished) {
            [_activityView removeFromSuperview];
        }];
       // NSLog(@"正在下载");
        
         [self loadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"下载数据错误");
    }];
   
    
}

- (void)loadData
{
    id res = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableLeaves error:nil];
   // NSLog(@"%@",res);
    NSDictionary *dict = (NSDictionary *)(res);
    NSArray *dicArr = dict[@"list"];
    for (NSDictionary *dic in dicArr) {
        
        DUAppModel *model = [[DUAppModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [_dataArray addObject:model];
    }
    [_tableView reloadData];
}





 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DUAppCell" owner:nil options:nil]lastObject];
    }
    
    cell.model = _dataArray[indexPath.row];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUDetailVC *detailVC = [[DUDetailVC alloc]init];
    DUAppModel *model = _dataArray[indexPath.row];
    
    detailVC.appModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
