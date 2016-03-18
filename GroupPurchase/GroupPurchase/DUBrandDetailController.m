//
//  DUBrandDetailController.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUBrandDetailController.h"
#import "UMSocial.h"
#import "DUFavoritemanager.h"
#import "DUTreasure.h"


@interface DUBrandDetailController ()<UMSocialUIDelegate>
{
    BOOL _isFavorite;
}
@end

@implementation DUBrandDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *wedView1 = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    NSURL *url1 = [NSURL URLWithString:_model.detailUrlIos];
    NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
    [wedView1 loadRequest:request1];
    [self.view addSubview:wedView1];
    
    
    
    UIWebView *wedView2 = [[UIWebView alloc] initWithFrame:self.view.bounds];
    NSURL *url2 = [NSURL URLWithString:_appModel.detailUrllos];
    NSURLRequest *request2 = [NSURLRequest requestWithURL:url2];
    [wedView2 loadRequest:request2];
    [self.view addSubview:wedView2];
    
    //分享按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    
    [button setImage:[UIImage imageNamed:@"share-press"] forState:UIControlStateNormal];
    
    
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside ];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    //收藏按钮
    UIButton *btnFavorite = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [btnFavorite setTitle:@"收藏" forState:UIControlStateNormal];
    [btnFavorite setTitle:@"已收藏" forState:UIControlStateSelected];
   // [btnFavorite addTarget:self action:@selector(favoriteAction:) forControlEvents:UIControlEventTouchUpInside];
  //  self.navigationItem.titleView = btnFavorite;
    _isFavorite = [[DUFavoritemanager manager]isExists:_appModel.detailUrl];
    
    
    
    
    
    
}

- (void)favoriteAction:(UIButton *)btnFavorite
{
    btnFavorite.selected = YES;
    
    if ([[DUFavoritemanager manager]isExists:_appModel])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经收藏成功，不必重复收藏哟！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else
    {
        if (_isFavorite)
        {
            DUTreasure *treasureVC = [[DUTreasure alloc]init];
            treasureVC.model  = _appModel;
            [[DUFavoritemanager manager]deleteModel:_appModel];

        }else
        {
            [[DUFavoritemanager manager]addMOdel:_appModel];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已经收藏成功，可到我的收藏列表中查看" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }

    }
    
    
    
}



- (void)buttonAction
{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"507fcab25270157b37000010" shareText:@"团购更优惠" shareImage: [UIImage imageNamed:@"icon.png"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToEmail,UMShareToQQ,UMShareToDouban, nil] delegate:self];
    
    
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
