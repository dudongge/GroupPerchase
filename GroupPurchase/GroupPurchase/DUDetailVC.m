//
//  DUDetailVC.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/9.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUDetailVC.h"
#import "UMSocial.h"
//#import "DUAppModel.h"
#import "DUFavoritemanager.h"
#import "DUFavoriteVC.h"
#import "DUTreasure.h"


@interface DUDetailVC ()<UMSocialUIDelegate>
{
    BOOL _isFavorite;
    NSTimer *_timer;
    UIActivityIndicatorView *_activityView;
}
@end

@implementation DUDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIWebView *wedView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [wedView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_appModel.detailUrl]]];
   
  // NSLog(@"%@",_appModel.picUrl);
    [self.view addSubview:wedView];
    
    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    navBarView.backgroundColor = [UIColor whiteColor];
    navBarView.layer.cornerRadius = 4;
    navBarView.clipsToBounds = YES;
    
    //分享
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 30, 30)];
    
    [button1 setImage:[UIImage imageNamed:@"share-press"] forState:UIControlStateNormal];
  
    [button1 addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside ];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
   // [navBarView addSubview:button1];

    //收藏
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,100, 30)];
    button2.backgroundColor = [UIColor purpleColor];
    [button2 setTitle:@"收藏" forState:UIControlStateNormal];
    [button2 setTitle:@"已收藏" forState:UIControlStateSelected];
   // [button2 setImage:[UIImage imageNamed:@"like-normal"] forState:UIControlStateNormal];
    //[button2 setImage:[UIImage imageNamed:@"like-press"] forState:UIControlStateSelected];
    [button2 addTarget:self action:@selector(buttonFavorite:) forControlEvents:UIControlEventTouchUpInside ];
    button2.tag = 10 ;
    [navBarView addSubview:button2];
//    self.navigationItem.rightBarButtonItems = [[UIBarButtonItem alloc]initWithCustomView:button2];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"收藏" style:UIBarButtonItemStylePlain target:self action:@selector(buttonFavorite)];
    
    self.navigationItem.titleView = navBarView;
    
    
    [self uiConfig];
    
}

- (void)uiConfig
{
    _isFavorite = [[DUFavoritemanager manager]isExists:_appModel.detailUrl];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
    [UIView animateWithDuration:2.0 animations:^{
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.backgroundColor = [UIColor purpleColor];
        _activityView.alpha = 0.6;
        _activityView.frame = CGRectMake(0, 0, 80, 80);
        _activityView.center = self.view.center;
        [_activityView startAnimating];
        [self.view addSubview:_activityView];
    }];

}

- (void)timerAction
{
    [UIView animateWithDuration:0.8 delay:0.5 options:0 animations:^{
        
        _activityView.frame = CGRectMake(0, 0, 0, 0);
        [_activityView stopAnimating];
    } completion:nil];
    
}



- (void)buttonFavorite:(UIButton *)button
{
    
    
    button.selected = YES;
    if ([[DUFavoritemanager manager]isExists:_appModel])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经收藏成功，不必重复收藏哟！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {

    DUTreasure *trearVC = [[DUTreasure alloc]init];
    trearVC.model = _appModel;
    if (_isFavorite) {
        [[DUFavoritemanager manager]deleteModel:_appModel];
    }
    else
        
    {
        [[DUFavoritemanager manager]addMOdel:_appModel];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经收藏成功，可到我的收藏列表中查看" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    }

}




- (void)buttonAction
{
   [UMSocialSnsService presentSnsIconSheetView:self appKey:@"507fcab25270157b37000010" shareText:[NSString stringWithFormat:@"%@ %@",_appModel.name,_appModel.detailUrl] shareImage: [UIImage imageNamed:@"icon.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToEmail,UMShareToQQ,UMShareToDouban, nil] delegate:self];
   
    
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
