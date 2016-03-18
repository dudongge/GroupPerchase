//
//  DUMyTabBarController.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUMyTabBarController.h"
#import "DUMyBarButton.h"
#import "DUUserViewController.h"
#import "DUHeaderViewController.h"
#import "DUSecKillViewController.h"
#import "DUBigBrandViewController.h"
#import "DUTodayCCViewController.h"

#define __kScreenHeight ([[UIScreen mainScreen]bounds].size.height)
#define __kScreenWidth ([[UIScreen mainScreen]bounds].size.width)



@interface DUMyTabBarController ()
{
    UIImageView *_tabbar;
    DUMyBarButton *_button;
}
@end

@implementation DUMyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.hidden = YES;
    //初始化ui
    [self uiConfig];
    
    
    //创建自己的标签
    [self creatTabbar];
    
    
    //创建所有的标签栏
    
    [self creatTabbarItems];
    
    
    
    
    
}

- (void)uiConfig
{
   // 利用 反射创建视图控制器
//    NSArray  *vccontroller = @[@"DUHeaderViewController"
//                               ,@"DUBigBrandViewController"
//                               ,@"DUSecKillViewController"
//                               ,@"DUTodayCCViewController"
//                               ,@"DUUserViewController"];
    
    
    DUHeaderViewController *headerVC = [[DUHeaderViewController alloc] init];
    UINavigationController *navHearder = [[UINavigationController alloc] initWithRootViewController:headerVC];
    [navHearder.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbarbg"] forBarMetrics:UIBarMetricsDefault];
    
    DUBigBrandViewController *brandVC = [[DUBigBrandViewController alloc] init];
    UINavigationController *navBrand = [[UINavigationController alloc] initWithRootViewController:brandVC];
    [navBrand.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbarbg"] forBarMetrics:UIBarMetricsDefault];
    
    DUSecKillViewController *secVC = [[DUSecKillViewController alloc] init];
    UINavigationController *navSec = [[UINavigationController alloc] initWithRootViewController:secVC];
    [navSec.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbarbg"] forBarMetrics:UIBarMetricsDefault];
    
    DUTodayCCViewController *todayVC = [[DUTodayCCViewController alloc] init];
    UINavigationController *navToday = [[UINavigationController alloc] initWithRootViewController:todayVC];
    [navToday.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbarbg"] forBarMetrics:UIBarMetricsDefault];
    
    
    DUUserViewController *userVC = [[DUUserViewController alloc] init];
    UINavigationController *navUser = [[UINavigationController alloc] initWithRootViewController:userVC];
    [navUser.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbarbg"] forBarMetrics:UIBarMetricsDefault];
    
    //创建所有的跟视图控制器
    NSArray *navs = [NSArray arrayWithObjects:navHearder,navBrand,navSec,navToday,navUser,nil];
    
    self.viewControllers = navs;
    

}

- (void)creatTabbar
{
    self.tabBar.hidden = YES;
    _tabbar = [[UIImageView alloc] initWithFrame:CGRectMake(0, __kScreenHeight - 49, __kScreenWidth, 49)];
  //  _tabbar.backgroundColor = [UIColor blackColor];
    _tabbar.userInteractionEnabled = YES;
    _tabbar.image = [UIImage imageNamed: @"end2"];
    [self.view addSubview:_tabbar];
    
    
    
    
}
//创建所有按钮的ui
- (void)creatTabbarItems
{
    NSArray *titleArray = @[@"折扣团",@"大牌汇",@"秒杀团",@"今日精选",@"个人中心"];
    NSArray *nomalImage = @[@"hom_normal",@"brand_normal",@"zdq-normal",@"tom_normal",@"my_normal"];
    NSArray *selectedImage = @[@"home_selected",@"brand_selected",@"zdq-press",@"tom_selected",@"my_selected"];
    
    //定义选中索引
    NSInteger selectIndex = [[[NSUserDefaults standardUserDefaults] valueForKey:@"selectedindex"]integerValue];
    self.selectedIndex = selectIndex;
    //CGFloat width = self.view.frame.size.width;
    for (int i = 0; i < titleArray.count; i ++) {
        _button = [[DUMyBarButton alloc]initWithFrame:CGRectMake(i * (__kScreenWidth / 5), 0, __kScreenWidth / 5, 40)];
        [_button setTitle:titleArray[i] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:nomalImage[i]] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:selectedImage[i]] forState:UIControlStateSelected];
        [_tabbar addSubview:_button];
        _button.tag = 100 + i;
        //默认一个是惦记着的
        [_button addTarget:self action:@selector(pressAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == selectIndex) {
            _button.selected = YES;
        }
        
    }
    
    
    
}
//按钮点击事件
- (void)pressAction:(UIButton *)tabbarItems
{
    NSInteger index = tabbarItems.tag - 100;
    for (id obj in _tabbar.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            ((UIButton *)obj).selected = NO;
        }
        tabbarItems.selected = YES;
    }
    //同步保存点击的按钮
    //@(index) 把基本数据类型转换成对象
    [[NSUserDefaults standardUserDefaults]setObject:@(index) forKey:@"selectedindex"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    self.selectedIndex = index;
    
    
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
