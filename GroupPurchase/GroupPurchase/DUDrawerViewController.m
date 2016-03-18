//
//  DUDrawerViewController.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUDrawerViewController.h"
#import "DUMenuViewController.h"
#import "DURootViewController.h"
#define __kScreenHeight ([[UIScreen mainScreen]bounds].size.height)//屏幕高
#define __kScreenWidth ([[UIScreen mainScreen]bounds].size.width)//屏幕宽
@interface DUDrawerViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    DUMenuViewController *_menuVC;
    DURootViewController *_rootVC;
}
@end

@implementation DUDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uiConfig];
}

- (void)uiConfig
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
   // _scrollView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_scrollView];
    
    _scrollView.pagingEnabled = YES;//整页翻动
    _scrollView.bounces = NO;//禁止弹动
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(__kScreenWidth * 1.5, 0);//画布的宽度
    _scrollView.contentOffset  = CGPointMake(__kScreenWidth * 0.5, 0);//设置显示区域顶点
    
    _menuVC = [[DUMenuViewController alloc] init];
    _menuVC.view.frame = CGRectMake(0, 0, __kScreenWidth / 2, __kScreenHeight);
    [_scrollView addSubview:_menuVC.view];
    
    _rootVC = [[DURootViewController alloc] init];
    _rootVC.view.center = CGPointMake(__kScreenWidth, __kScreenHeight / 2);
    [_scrollView addSubview:_rootVC.view];
    
    //观察者监听是否弹出列表
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showMenu) name:@"menu" object:nil];
    
    
}
- (void)showMenu
{
    BOOL isHide = _scrollView.contentOffset.x == self.view.frame.origin.x / 2;
    [UIView animateWithDuration:0.24 animations:^{
        _scrollView.contentOffset = CGPointMake(isHide ? __kScreenWidth / 2 : 0, 0);
    }];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _rootVC.view.transform = CGAffineTransformMakeScale(1, 1);//原比例缩放
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
