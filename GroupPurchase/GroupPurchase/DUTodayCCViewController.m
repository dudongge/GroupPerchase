//
//  DUTodayCCViewController.m
//  GroupPurchase
//http://www.huipinzhe.com/?r=mobapi/product/next
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUTodayCCViewController.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "DUAppModel.h"
#import "DUAppCell.h"
#import "DUBrandDetailController.h"
#import "DUDetailVC.h"



@interface DUTodayCCViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableData *_data;
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    UIActivityIndicatorView *_activityView;
    NSTimer *_timer;
}
@end

@implementation DUTodayCCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.navigationItem.title = @"今日精选";
    [self prepareData];
    [self uiConfig];
}

- (void)uiConfig
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
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

//进度条定时器
//- (void)timerAction
//{
//    [UIView animateWithDuration:0.8 delay:0.5 options:0 animations:^{
//        _activityView.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 0, 0) ;
//        [_activityView stopAnimating];
//    } completion:nil];
//
//}

- (void)prepareData
{
    _data = [[NSMutableData alloc] init];
    _dataArray = [[NSMutableArray alloc] init];
    NSString *url = @"http://www.huipinzhe.com/?r=mobapi/product/next";
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _data = responseObject;
      //  NSLog(@"%@",_data);
        [UIView animateWithDuration:0.8 animations:^{
            _activityView.backgroundColor = [UIColor greenColor];
            _activityView.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 0, 0);
            
        } completion:^(BOOL finished) {
            [_activityView removeFromSuperview];
        }];
        
        [self loadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"数据解析错误");
    }];
    
}

- (void)loadData
{
    id res = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableLeaves error:nil];
   // NSLog(@"%@",res);
    if ([res isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)res;
        NSArray *array = dict[@"goodsArray"];
        for (NSDictionary *dic in array) {
            DUAppModel *model = [[DUAppModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
    }
    [_tableView reloadData];
    
}


#pragma mark --- 实现UItableView数据源代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DUAppCell" owner:self options:nil]lastObject];
    }
    DUAppModel *model = _dataArray[indexPath.row];
    cell.nameLable.text = model.name;
    cell.cPriceLable.text = [NSString stringWithFormat:@"¥%.2f",[model.cPrice floatValue]];
    cell.oPriceLable.text = [NSString stringWithFormat:@"¥%.2f",[model.oPrice floatValue]] ;
    [cell.image setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"r1"]];
    cell.discountLable.text = [NSString stringWithFormat:@"%.1f折", [ model.discount floatValue]];
 
    cell.express_feeLable.text = @"免运费";
    cell.tianmaoLable.text = indexPath.row % 2 == 0 ?@"天猫":@"淘宝";
    cell.tianmaoLable.textColor = indexPath.row % 2 == 0 ?[UIColor redColor] :[UIColor blackColor];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUAppModel *model = _dataArray[indexPath.row];
    DUBrandDetailController *detailVC = [[DUBrandDetailController alloc] init];
    detailVC.appModel.detailUrllos = model.detailUrllos;
    [self.navigationController pushViewController:detailVC animated:YES];
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
