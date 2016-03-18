//
//  DUTreasure.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/13.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUTreasure.h"
#import "DUAppCell.h"
#import "DUAppModel.h"
#import "DUDetailVC.h"
#import "DUFavoritemanager.h"
#import "DUDetailVC.h"
#import  "DUBrandDetailController.h"



@interface DUTreasure ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    BOOL _isFavorite;
}
@end

@implementation DUTreasure

- (void)viewWillAppear:(BOOL)animated
{
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    [self uiCongig];
    [self prepareData];
    
}

- (void)uiCongig
{
     _dataArray = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [button setTitle:@"编辑" forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = button;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑"style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick:)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

- (void)prepareData
{
   // DUAppModel *model = _model;
    //NSLog(@"%@",_model.name);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changed" object:nil ];
    NSArray *arr = [[DUFavoritemanager manager]allModels];
    for (DUAppModel *model in arr) {
        [_dataArray addObject:model];
    }

}

- (void)rightItemClick:(UIBarButtonItem *)BarItem
{
    if (_tableView.editing == NO)
    {
        [_tableView setEditing:YES];
        _tableView.allowsMultipleSelectionDuringEditing = NO;
        BarItem.title = @"完成";
            }
    else
    {
        [_tableView setEditing:NO];
        _tableView.allowsMultipleSelectionDuringEditing = NO;
        BarItem.title = @"删除";
    }
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"DUAppCell" owner:self options:nil]lastObject];
        
        cell.model = _dataArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //先删除数据源
        DUAppModel *model = _dataArray[indexPath.row];
        [[DUFavoritemanager manager]deleteModel:model];
        [_dataArray removeObjectAtIndex:indexPath.row];
        //再删除cell
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
  //  [_tableView reloadData];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DUBrandDetailController *detailVC = [[DUBrandDetailController alloc]init];
    detailVC.appModel = _model;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}





@end
