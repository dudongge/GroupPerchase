//
//  DURootViewController.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DURootViewController.h"
#import "DUMyTabBarController.h"
@interface DURootViewController ()
{
    UINavigationController *_navi;
}
@end

@implementation DURootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DUMyTabBarController *myTabbarVC = [[DUMyTabBarController alloc] init];
    _navi = [[UINavigationController alloc] initWithRootViewController:myTabbarVC];
    [self.view addSubview:_navi.view];
    _navi.navigationBar.hidden = YES;
    
    
    
    // Do any additional setup after loading the view.
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
