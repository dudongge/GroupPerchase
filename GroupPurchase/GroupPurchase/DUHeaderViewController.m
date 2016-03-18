//
//  DUHeaderViewController.m
//  GroupPurchase
//
//  Created by dudongge on 15/9/8.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUHeaderViewController.h"
#import "AFNetworking.h"
#import "DUAppCell.h"
#import "DUAppModel.h"
#import "DUDetailVC.h"
#import "DUHeadDetail.h"
#import "EGORefreshTableHeaderView.h"
#import "DUCacheManager.h"




#define __kScreenHeight ([[UIScreen mainScreen]bounds].size.height)
#define __kScreenWidth ([[UIScreen mainScreen]bounds].size.width)
@interface DUHeaderViewController ()<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate>
{
    NSInteger _currentPage;
    UITableView *_tableView;
    NSMutableArray *_dataArray1;
    NSMutableArray *_dataArray2;
    UIButton *_leftButton;
    BOOL _isMenuClick;//是否打开列表
    //选中列表
    NSMutableData *_data1;
    NSMutableData *_data2;
    NSMutableData *_data;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSTimer *_timer;
    EGORefreshTableHeaderView *_egoView;
    BOOL _isRefreshing;
    BOOL isCache;
    UIActivityIndicatorView *_activityView;
    int _i  ;
    
}
@end

@implementation DUHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"折扣团";
    [self uiConfig];
    [self prepareData];

    
}
- (void)uiConfig
{
    
     _dataArray1 = [[NSMutableArray alloc]init];
    CGRect frame = self.view.bounds;
    frame.size.height -= 64;
    
    _tableView = [[UITableView alloc] initWithFrame:frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
   // [_tableView setSectionIndexColor:[UIColor blueColor]];
    [self.view addSubview:_tableView];

    //创建刷新ego
    frame = _tableView.bounds;
    frame.origin.y = -frame.size.height;
    _egoView = [[EGORefreshTableHeaderView alloc]initWithFrame:frame];
    _egoView.delegate = self;
    [_tableView addSubview:_egoView];
    
    
    _isMenuClick = NO;
    _currentPage = 1;
   //创建左侧展开BUtton
    _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    [_leftButton setImage:[UIImage imageNamed:@"88-fl"] forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"88-fl-down"] forState:UIControlStateSelected];
    [_leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    _leftButton.userInteractionEnabled = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_leftButton];
    //添加menu监听事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(categoryChange:) name:@"category" object:nil];
    //创建一个图片轮播器
     _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width, 130)];
    for (int i = 0; i < 4; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *strImage = [NSString stringWithFormat:@"2-%d.jpg",i + 1];
        imageView.image = [UIImage imageNamed:strImage];
//        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.frame = CGRectMake(self.view.frame.size.width * i , 0, self.view.frame.size.width , 130);
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];

        [_scrollView addSubview:imageView];
        
    }
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(__kScreenWidth + 10, 0, 50,10)];
   
    [self.view addSubview:_pageControl];

    CGFloat maxW = __kScreenWidth * 4;
    _scrollView.contentSize = CGSizeMake(maxW, 0);
    _scrollView.pagingEnabled = YES;
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    
    
   // _scrollView.showsHorizontalScrollIndicator = NO;
    
    _tableView.tableHeaderView =_scrollView;
    //[self.view addSubview:_scrollView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    
    
    //网络等候显示转动的菊花
       _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.backgroundColor = [UIColor purpleColor];
    _activityView.alpha = 0.6;
    _activityView.frame = CGRectMake(0, 0, 80, 80);
    _activityView.center = self.view.center;
    [_activityView startAnimating];
    [self.view addSubview:_activityView];

    
   
    
    
    
    
}


#pragma mark -- 点击头部实现页面跳转
- (void)tapAction
{
   // NSLog(@"+++++");
    DUHeadDetail *detail = [[DUHeadDetail alloc]init];
    
    
    [self.navigationController pushViewController:detail animated:YES];
    
    
}
#pragma mark---计时器实现图片轮播
- (void)timerAction
{
    //获取当前页码
    NSInteger page = _pageControl.currentPage;
    if (page == _pageControl.numberOfPages - 1)
    {
        page = 0;
    }
    else
    {
        page ++;
    }
    _pageControl.currentPage = page;
    CGFloat offset = _scrollView.frame.size.width * page;
    [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    }
//左侧按钮点击事件
- (void)leftAction
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"menu" object:nil
     ];
   
}

- (NSString *)getUrl
{
    return [NSString stringWithFormat:@"http://www.huipinzhe.com/?r=mobapi/product/listnew&catalogue=index&page=%ld",_currentPage];
}


//要准备两方面的数据
- (void)prepareData
{
    
//        [[MMProgressHUD sharedHUD] setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//        [[MMProgressHUD sharedHUD] showWithTitle:@"努力加载中" status:@"loading..." confirmationMessage:nil cancelBlock:nil images:nil];
//    判断有无缓存
    if ([[DUCacheManager manager]isExists:[self getUrl]]) {
        NSData *data = [[DUCacheManager manager] getCache:[self getUrl]];
        _data1 = data;
        [self loadData1];
        
        [UIView animateWithDuration:0.8 animations:^{
            _activityView.backgroundColor = [UIColor greenColor];
            _activityView.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 0, 0);
            
        } completion:^(BOOL finished) {
            [_activityView removeFromSuperview];
        }];
    }
    else{
    //这个时候要下载首页的数据
    if(_isMenuClick == 0)
    {
        _tableView.tableHeaderView.hidden = NO;
       
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:[self getUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _data1 = responseObject;
          //  NSLog(@"%@",_data);
            //写入缓存
            
            
            
            [UIView animateWithDuration:0.8 animations:^{
                _activityView.backgroundColor = [UIColor greenColor];
                _activityView.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 0, 0);
                
            } completion:^(BOOL finished) {
                [_activityView removeFromSuperview];
            }];


            [[DUCacheManager manager] saveCache:responseObject forName:[self getUrl]];
            [self loadData1];
          //  NSLog(@"首页");
            
//            [UIView animateWithDuration:0.8 delay:0.5 options:0 animations:^{
//                _activityView.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 0, 0) ;
//            } completion:nil];
            
          //  _i = 1;
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"下载数据错误");
        }];
        
    }
    else
    {
        _dataArray1 = [[NSMutableArray alloc] init];
        _tableView.tableHeaderView.hidden = YES;
        NSArray *catelogue = @[@"index",@"ssnz",@"clnz",@"xbps",@"fwms",@"myyp",@"jjbh",@"qt"];
        /*
         @"惠品折扣",@"时尚女装",@"潮流男装",@"鞋包配饰",@"风味美食",@"母婴用品",@"家居百货",@"其他类品"
         */
        NSString *url = [NSString stringWithFormat:@"http://www.huipinzhe.com/?r=mobapi/product/listnew&catalogue=%@&page=%ld",catelogue[_menuIndex],_currentPage];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _data1 = responseObject;
            [self loadData1];
            [UIView animateWithDuration:0.8 animations:^{
                _activityView.backgroundColor = [UIColor greenColor];
                _activityView.frame = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 0, 0);
                
            } completion:^(BOOL finished) {
                [_activityView removeFromSuperview];
            }];
            NSLog(@"下载左侧数据");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"数据下载错误");
        }];
        
    }
    }
}

- (void)loadData1
{
    //下载之前做一下清空操作
   // [_dataArray1 removeAllObjects];
    id res = [NSJSONSerialization JSONObjectWithData:_data1 options:NSJSONReadingMutableLeaves error:nil];
    //NSLog(@"%@",res);
    NSDictionary *dict = (NSDictionary *)res;
    // NSLog(@"%@",dict);
    NSArray *array = dict[@"goodsArray"];
    for (NSDictionary *dic in array) {
        DUAppModel *model = [[DUAppModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [_dataArray1 addObject:model];
    }
   
    [_tableView reloadData];
}

#pragma mark --- 创建观察者监听事件

- (void)categoryChange:(NSNotification *)not
{
    NSInteger index = [not.object[0]integerValue];
    self.title = not.object[1];
    if (index != 0) {
        _isMenuClick = YES;
        _menuIndex = index;
        [self prepareData];
        _tableView.frame = CGRectMake(0,  - 130, __kScreenWidth, __kScreenHeight);
    }
    else
    {
        _isMenuClick = NO;
        [_dataArray1 removeAllObjects];
        [self prepareData];
        _tableView.frame = CGRectMake(0, 0, __kScreenWidth, __kScreenHeight);
    }
}

//创建左侧按钮








#pragma mark --- 实现UItableView的代理方法
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == _dataArray1.count?40:130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _dataArray1.count + (_dataArray1.count > 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _dataArray1.count) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loadMore"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loadMore"];
            cell.textLabel.text = @"加载更多";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        return cell;
    }

    DUAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DUAppCell" owner:self options:nil]lastObject];
    }
    
    cell.model = _dataArray1[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    //设置选中时的状态
  //  [cell setSelectedBackgroundView:[[UIView alloc]init]];
    return cell;
    
 
}

#pragma mark ---点击tableView，跳转到详情页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == _dataArray1.count)
    {
        [self loadMore];
        return;
    }

    DUDetailVC *detailVC = [[DUDetailVC alloc]init];
    DUAppModel *model = _dataArray1[indexPath.row];
    detailVC.appModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];

}

- (void)loadMore
{
    _currentPage ++;
    [self prepareData];
}
- (void)refreshData
{
    _isRefreshing = YES;
    _currentPage = 1;
    [self prepareData];
}

#pragma mark ---实现下拉刷新方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_egoView egoRefreshScrollViewDidScroll:scrollView];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_egoView egoRefreshScrollViewDidEndDragging:scrollView];
}

//Trigger:触发
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self refreshData];
}
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view;
{
    return _isRefreshing;
    
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








@end
