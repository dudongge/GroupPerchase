//
//  DUUserViewController.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUUserViewController.h"
#import  "DURegistController.h"
#import "DUloginController.h"
#import "DUAboutUsController.h"
#import "DUHeaderViewController.h"
#import "DUFavoriteVC.h"
#import "SDImageCache.h"
#import "DUTreasure.h"



@interface DUUserViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
{
    UIImageView *_imageView;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UILabel *_usernameLable;
    
}
@end

@implementation DUUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    //创建背景图案
    [self creatHeadView];
    [self uiConfig];
    
}

- (void)creatHeadView
{
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 90)];
    _imageView.image = [UIImage imageNamed:@"personalback"];
    UIImageView *imageView = [[UIImageView alloc ]initWithFrame:CGRectMake(30, 20, 50, 50)];
    imageView.image = [UIImage imageNamed:@"88-5-nc_new"];
    _imageView.userInteractionEnabled = YES;
    _usernameLable = [[UILabel alloc]initWithFrame:CGRectMake(100, 30, 50, 30)];
    
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [button setImage:[UIImage imageNamed:@"hom_normal"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonBack) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    _usernameLable.backgroundColor = [UIColor clearColor];
    _usernameLable.text = _username;
    [_imageView addSubview:_usernameLable];
    [_imageView addSubview:imageView];
    [self.view addSubview:_imageView];
}

- (void)uiConfig
{
    NSArray *arr = @[@"注册",@"登陆",@"我的收藏",@"清空缓存",@"关于我们"];
    _dataArray = [NSMutableArray arrayWithArray:arr];
//    for (int i = 0; i < titleArray.count; i ++)
//    {
//        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50, 120 + i * 30, 100, 30)];
//        button.tag = 100 + i;
//        [button setTitle:titleArray[i] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:button];
//    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, self.view.frame.size.height - 90)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    

    
}

#pragma mark --- 返回首页

- (void)buttonBack
{
    DUHeaderViewController *headVC = [[DUHeaderViewController alloc]init];
    [self.navigationController pushViewController:headVC animated:YES];
}







- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = _dataArray[indexPath.row];
        cell.accessoryType = UITableViewCellStyleValue1;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //注册
    if (indexPath.row == 0) {
        DURegistController *registVC = [[DURegistController alloc]init];
        [self.navigationController pushViewController:registVC animated:YES];
    }
    //登陆
    if (indexPath.row == 1)
    {
        DUloginController *loginVC = [[DUloginController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    //收藏
    if (indexPath.row == 2) {
        DUTreasure *faVC = [[DUTreasure alloc]init];
        [self.navigationController pushViewController:faVC animated:YES];
    }
    //清空缓存
    if (indexPath.row == 3) {
        //清空缓存
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"清空缓存%3fM",[self getCachesSize]] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
        [sheet showInView:self.view];
    }
    if (indexPath.row == 4) {
        DUAboutUsController *abVC = [[DUAboutUsController alloc]init];
        
        [self.navigationController pushViewController:abVC animated:YES];
    }
}



//得到缓存的大小
- (CGFloat)getCachesSize
{
    NSInteger sdFileSize = [[SDImageCache sharedImageCache]getSize];
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString *myCachePath = [cache stringByAppendingPathComponent:@"myCaches"];
    NSDirectoryEnumerator *enumrator = [[NSFileManager defaultManager]enumeratorAtPath:myCachePath];
    NSInteger mySize = 0;
    for (NSString *fileName in enumrator) {
        NSString *filePath = [myCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
        //获取大小
        mySize += fileDict.fileSize;//字节大小
    }
    
    return (mySize + sdFileSize) / 1024.0 / 1024.0;
}
//点击操作表单的按钮
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        //删除
        //1，删除sd
        [[SDImageCache sharedImageCache] clearMemory];//清除内存缓存
        //2.清除磁盘缓存
        [[SDImageCache sharedImageCache]clearDisk];
        //清楚自己的缓存
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
        NSString *myCachesPath = [caches stringByAppendingPathComponent:@"myCaches"];
        //删除
        [[NSFileManager defaultManager] removeItemAtPath:myCachesPath error:nil];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"缓存已清除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    

}















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
