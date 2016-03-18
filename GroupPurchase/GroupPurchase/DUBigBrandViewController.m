//
//  DUBigBrandViewController.m
//  GroupPurchase
//@"http://www.huipinzhe.com/?r=mobapi/product/brand1"
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 dudongge. All rights reserved.
/*"ios_url" = "http://s.click.taobao.com/t?e=m%3D2%26s%3DqeHCtRPOxBIcQipKwQzePOeEDrYVVa64pRe%2F8jaAHci5VBFTL4hn2YdQ75xnX%2FR%2BHqN3CrDUeQZBOTmjrHrVYLQXbSv5%2F%2BMKxQIgZjeuSZTSLpCGCT%2BrRUUHkBN8M1nMh1x64ntMhVLMEaL2jzhqzsYMXU3NNCg%2F";
 "is_hot" = 0;
 "item_name" = "\U5973\U88c5/\U9ad8\U8170\U5c0f\U811a\U94c5\U7b14\U725b\U4ed4\U957f\U88e4";
 pid = 312180;
 price = "45.00";
 sold = 0;
 source = 2;
 starttime = 1441674000;
 state = 1;
 "taobao_price" = "398.00";
 viewtotal = 2313;
 },
 "android_url" = "http://s.click.taobao.com/t?e=m%3D2%26s%3DJ8eQLJnZPu0cQipKwQzePOeEDrYVVa64pRe%2F8jaAHci5VBFTL4hn2av1Bv0FsLhcyqeBTj9FJShBOTmjrHrVYHeFgr81Fs1LVEYdx%2FDjPAQo97I8TOUxoUUHkBN8M1nMZpObgkc9%2FhoB6HmCpgkRZcYMXU3NNCg%2F";
 "brand_name" = "\U84dd\U7199\U7eee";
 catname = "\U5973\U88c5";
 discount = "1.8";
 endtime = 1442278800;
 "express_fee" = 1;
 id = 312175;
 img2 = "https://img.alicdn.com/imgextra/i3/1644048454/TB20rNbfXXXXXaAXpXXXXXXXXXX_!!1644048454.jpg";
 imgurl = "https://img.alicdn.com/imgextra/i3/1644048454/TB20rNbfXXXXXaAXpXXXXXXXXXX_!!1644048454.jpg";
*/

#import "DUBigBrandViewController.h"
#import "AFNetworking.h"
#import "DUBrandCell.h"
#import "DUBrandModel.h"
#import "UIImageView+AFNetworking.h"
#import "DUBrandDetailController.h"
#import "DUHeadViewController.h"
#import "DUCacheManager.h"


@interface DUBigBrandViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableData *_data;
    NSMutableArray *_imageArray;
    NSString *_brand_img;
    NSString *_brand_url;
    NSString *_brand_title;
    UIButton *_leftButton;
    UIActivityIndicatorView *_activityView;
    NSTimer *_timer;
}
@end

@implementation DUBigBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"大牌汇";

    [self uiConfig];
    [self  getData];
    

}

- (void)uiConfig
{
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview: _tableView];
    
    _leftButton = [[UIButton alloc] init];
    
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


- (void)getData
{
    _dataArray = [[NSMutableArray alloc] init];
    _imageArray = [[NSMutableArray alloc] init];
    NSString *url = @"http://www.huipinzhe.com/?r=mobapi/product/brand1";
    
    
//    NSString *cachePath = @"/Users/qianfeng/Library";
//    if ([[NSFileManager defaultManager] fileExistsAtPath:cachePath])
//    {
//        _data = [NSMutableData dataWithContentsOfFile:cachePath];
//        [self loadData];
//    }
    
    //else
    
    
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
        
        
        [self loadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
   
}

- (void)loadData
{
    id res = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableLeaves error:nil];
   // NSLog(@"%@",res);
    if ([res isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)res;
        NSDictionary *dicbrand = dict[@"banner"];
        _brand_img = dicbrand[@"banner_img"];
        _brand_url = dicbrand[@"brand_url"];
        _brand_title = dicbrand[@"title"];
        NSArray *array = dict[@"products"];
        for (NSDictionary *dicp in array) {
            DUBrandModel *model = [[DUBrandModel alloc] init];
            [model setValuesForKeysWithDictionary:dicp];
            [_dataArray addObject:model];
        }
        
     
    }
    
    [_tableView reloadData];
    [self creatHeadView];
    
}


#pragma mark---实现头部View的功能

- (void)creatHeadView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    //采用队列异步下载
    dispatch_queue_t downloadQueue  = dispatch_queue_create("KDownload", NULL);
    dispatch_async(downloadQueue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_brand_img]];
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [UIImage imageWithData:data];
            });
        }
    });
    _tableView.tableHeaderView = imageView;
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [imageView addGestureRecognizer:tap];
    
}

- (void)tapAction
{
    DUHeadViewController *headVC = [[DUHeadViewController alloc] init];
    headVC.url = _brand_url;
    headVC.title = _brand_title;
    [self.navigationController pushViewController:headVC animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DUBrandCell" owner:self options:nil]lastObject];
    }
    DUBrandModel *model = _dataArray[indexPath.row];
    cell.brandName.text = model.brand_name;
    cell.taobaoLable.text = [NSString stringWithFormat:@"¥%.2f",[model.taobao_price floatValue]];
    cell.priceLable.text = [NSString stringWithFormat:@"¥%.2f", [model.price floatValue]];
    cell.itemName.text = model.item_name;
    cell.discountLable.text = [NSString stringWithFormat:@"%.2f折",[model.discount floatValue]];
    [cell.imageUrl setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"r3"]];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUBrandModel *model = _dataArray[indexPath.row];
    
    DUBrandDetailController *brandVC = [[DUBrandDetailController alloc] init];
    brandVC.model = model;
    [self.navigationController pushViewController:brandVC animated:YES];
    
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
