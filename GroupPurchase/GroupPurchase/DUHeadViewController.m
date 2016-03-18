//
//  DUHeadViewController.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/9.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUHeadViewController.h"

@interface DUHeadViewController ()
{
    NSTimer *_timer;
    UIImageView *_imageView;
}
@end

@implementation DUHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"今日大牌";
    
//    _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
//   // NSArray *imageArray = @[@"r1.png",@"r2.png",@"r3.png",@"r4.png"];
//    //[_imageView  setAnimationImages:imageArray];
//    _imageView.image = [UIImage imageNamed:@"r1.png"] ;
//    [_imageView startAnimating];
//    [self.view addSubview:_imageView];
    
    UIWebView *wedView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [wedView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
    
    
    [self.view addSubview:wedView];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timerAction1) userInfo:nil repeats:NO];
}

- (void)timerAction1
{
    [_imageView stopAnimating];
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
