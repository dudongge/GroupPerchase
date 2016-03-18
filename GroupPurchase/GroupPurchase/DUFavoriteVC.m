//
//  DUFavoriteVC.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/12.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUFavoriteVC.h"
#import "DUFavoritemanager.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "DUDetailVC.h"






@interface DUFavoriteVC ()
{
    NSMutableArray *_apps;
    BOOL _isEditing;
}
@end

@implementation DUFavoriteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    self.view.backgroundColor = [UIColor whiteColor];
    [self prepareData];
    [self uiConfig];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notAction) name:@"changed" object:nil];
    
}

- (void)prepareData
{
    
    
    _apps = [[DUFavoritemanager manager]allModels];
    
    
}


- (void)notAction
{
    [self refreshData];
    
    for (int i = self.view.subviews.count - 1; i >= 0; i --) {
        UIView *view = self.view.subviews[i];
        [view removeFromSuperview];
    }
   // [self uiConfig];
    
}
- (void)refreshData
{
    _apps = [[DUFavoritemanager manager]allModels];
}


- (void)uiConfig
{
    UIButton *last;
    for (int i = 0; i <_apps.count; i++)
    {
        DUAppModel *model = _apps[i];
        UIButton *button = [[UIButton alloc]init];
        button.backgroundColor = [UIColor blueColor];
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(@20);
                make.top.equalTo(@20);
                make.height.equalTo(@80);
            }
            else if(i % 3 == 2)
            {
                make.left.equalTo(last.mas_right).offset(20);
                make.right.equalTo(@-20);
                make.size.equalTo(last);
                make.top.equalTo(last);
            }
            else if (i % 3 == 0)
            {
                make.left.equalTo(@20);
                make.top.equalTo(last.mas_bottom).offset(20);
                make.size.equalTo(last);
            }
            else
            {
                make.left.equalTo(last.mas_right).offset(20);
                make.size.equalTo(last);
                make.top.equalTo(last);
            }
        }];
        last = button;
        UIImageView *imgv = [[UIImageView alloc]init];
     
        [imgv sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
        imgv.layer.masksToBounds = YES;
        imgv.layer.cornerRadius = 10;
        [button addSubview:imgv];
        
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(60, 60)]);
            make.centerX.equalTo(button);
            make.top.equalTo(@0);
        }];
        
        
        UILabel *lable = [UILabel new];
        [button addSubview:lable];
        lable.backgroundColor = [UIColor orangeColor];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(button);
            make.left.equalTo(button);
            make.top.equalTo(imgv.mas_bottom).offset(5);
        }];
        lable.text  = model.name;
        lable.font = [UIFont systemFontOfSize:12];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.lineBreakMode = NSLineBreakByTruncatingMiddle;
        
        button.tag = 100 + i;
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    _isEditing = editing;
    if (_isEditing) {
        [[DUFavoritemanager manager]beginTransaction];
    }
    else
    {
        [[DUFavoritemanager manager]commit];
        [self notAction];
    }
}

- (void)clickAction:(UIButton *)button
{
    NSInteger index = button.tag - 100;
    DUAppModel *model = _apps[index];
    if (_isEditing) {
        //删除
        [[DUFavoritemanager manager]deleteModel:model];
        UIView *view = self.view.subviews[index];
        view.hidden = YES;
        return;
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[DUFavoritemanager manager]rollback];
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
