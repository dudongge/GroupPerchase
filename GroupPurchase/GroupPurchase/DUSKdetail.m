//
//  DUSKdetail.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/9.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUSKdetail.h"
#import "UMSocial.h"
#import "DUFavoritemanager.h"



@interface DUSKdetail ()<UMSocialUIDelegate,UIWebViewDelegate>
{
    BOOL _isFavorite;
}
@end

@implementation DUSKdetail


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"秒杀";
    self.view.backgroundColor = [UIColor whiteColor];

    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_model.ios_url]]];
   // NSLog(@"%@",_model.ios_url);
    [self.view addSubview:webView];

    [self uiConfig];
    
     _isFavorite = [[DUFavoritemanager manager]isExists:_appModel.detailUrl];
    
}



- (void)uiConfig
{
    //分享按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    
    [button setImage:[UIImage imageNamed:@"share-press"] forState:UIControlStateNormal];
    
    
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside ];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    //收藏
    
    UIButton *btnFavorite = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [btnFavorite setTitle:@"收藏" forState:UIControlStateNormal];
    btnFavorite.layer.cornerRadius = 6;
    btnFavorite.clipsToBounds = YES;
    [btnFavorite  setTitle:@"已收藏" forState:UIControlStateSelected];
    btnFavorite.backgroundColor = [UIColor purpleColor];
   // [btnFavorite addTarget:self action:@selector(btnFavorite:) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.titleView = btnFavorite;

}

- (void)btnFavorite:(UIButton *)btnFavorite
{
    btnFavorite.selected = YES;
    if ([[DUFavoritemanager manager]isExists:_appModel]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经收藏成功，不必重复收藏哟！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    else
    {
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
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"507fcab25270157b37000010" shareText:[NSString stringWithString:_model.ios_url] shareImage: [UIImage imageNamed:@"icon.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToEmail,UMShareToQQ,UMShareToDouban, nil] delegate:self];
    
    
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
