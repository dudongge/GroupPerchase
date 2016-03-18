//
//  DUAppCell.h
//  GroupPurchase
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DUAppModel.h"
@interface DUAppCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *cPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *oPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *discountLable;
@property (weak, nonatomic) IBOutlet UILabel *express_feeLable;
@property (weak, nonatomic) IBOutlet UILabel *tianmaoLable;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, strong)DUAppModel *model;


@end
