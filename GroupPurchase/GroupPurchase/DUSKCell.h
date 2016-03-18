//
//  DUSKCell.h
//  GroupPurchase
//
//  Created by qianfeng on 15/9/9.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DUSKModel.h"



@interface DUSKCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ima2imageView;
@property (weak, nonatomic) IBOutlet UILabel *item_nameLable;
@property (weak, nonatomic) IBOutlet UILabel *item_shortnameLable;
@property (weak, nonatomic) IBOutlet UILabel *priceLable;
@property (weak, nonatomic) IBOutlet UILabel *taobao_priceLable;
@property (weak, nonatomic) IBOutlet UILabel *endtimeLable;
@property (nonatomic, strong) DUSKModel *model;
@property (nonatomic, copy)NSString *leftString;
@end
