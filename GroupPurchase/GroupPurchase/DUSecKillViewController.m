//
//  DUSecKillViewController.m
//  GroupPurchase
//@“http://www.huipinzhe.com/?r=mobapi/product/zsms&version=1”
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUSecKillViewController.h"
#import "AFNetworking.h"
#import "DUSKModel.h"
#import "DUSKCell.h"
#import "DUSKdetail.h"



@interface DUSecKillViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableData *_data;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    NSTimer *_timer;
    UIActivityIndicatorView *_activityView;
}
@end

@implementation DUSecKillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"秒杀团";
    self.view.backgroundColor = [UIColor yellowColor];
    [self uiConfig];
    [self prepareData];
    
}
- (void)uiConfig
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
//    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
    
    //创建等候加载提示
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.backgroundColor = [UIColor purpleColor];
    _activityView.alpha = 0.6;
    _activityView.frame = CGRectMake(0, 0, 80, 80);
    _activityView.center = self.view.center;
    [_activityView startAnimating];
    [self.view addSubview:_activityView];

    
}

//- (void)timerAction
//{
//    [UIView animateWithDuration:0.8 delay:0.5 options:0 animations:^{
//        _activityView.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 0, 0) ;
//        [_activityView stopAnimating];
//    } completion:nil];
//}


- (void)prepareData
{
    _dataArray = [[NSMutableArray alloc] init];
    NSString *url = @"http://www.huipinzhe.com/?r=mobapi/product/zsms&version=1";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _data = responseObject;
      //  NSLog(@"%@",responseObject);
        
        [UIView animateWithDuration:0.8 animations:^{
            _activityView.backgroundColor = [UIColor greenColor];
            _activityView.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 0, 0);
        } completion:^(BOOL finished) {
            [_activityView removeFromSuperview];
        }];
        
        
        
        
        
        
        
        [self loadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"数据下载错误");
    }];
    
    
}
- (void)loadData
{
    id res = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableLeaves error:nil];
    //NSLog(@"%@",res);
    if ([res isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)res;
        NSDictionary *range1 = dict[@"range1"];
        //NSDictionary *range2 = dict[@"range2"];
        //NSDictionary *range3 = dict[@"range3"];
       // NSDictionary *range4 = dict[@"range4"];
        //NSArray *array = [NSArray array];
        NSArray *array1 = range1[@"list"];
        NSLog(@"%@",array1);
//        [array arrayByAddingObjectsFromArray:array1];
//        NSArray *array2 = range2[@"list"];
//        [array arrayByAddingObjectsFromArray:array2];
//         NSArray *array3 = range3[@"list"];
//        [array arrayByAddingObjectsFromArray:array3];
//         NSArray *array4 = range4[@"list"];
//        [array arrayByAddingObjectsFromArray:array4];
        for (NSDictionary *dic in array1) {
            DUSKModel *model = [[DUSKModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
  
        
        
       // NSLog(@"%@",_dataArray);
    }
    [_tableView reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUSKCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DUSKCell" owner:self options:nil]lastObject];
    }
    
    cell.model =  _dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUSKdetail *skVC = [[DUSKdetail alloc] init];
    DUSKModel *model = _dataArray[indexPath.row];
    skVC.model = model;
    [self.navigationController pushViewController:skVC animated:YES];
    
}


@end
