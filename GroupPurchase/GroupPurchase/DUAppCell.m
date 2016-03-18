//
//  DUAppCell.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUAppCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"


@implementation DUAppCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(DUAppModel *)model
{
    _model = model;
    _nameLable.text = model.name;
//    [_image setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"r2"]];
    [_image sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"r2"]];
    _cPriceLable.text = [NSString stringWithFormat:@"¥%.2f",[model.cPrice doubleValue]];
    _oPriceLable.text = [NSString stringWithFormat:@"¥%.2f",[model.oPrice doubleValue]];
    _discountLable.text = [NSString stringWithFormat:@"%.1f折",[model.discount floatValue]];
    _express_feeLable.text = [model.express_fee boolValue] ?@"免运费":@"";
    int i = [model.source intValue];
    _tianmaoLable.text = i % 2==0 ? @"天猫":@"淘宝";
    _tianmaoLable.textColor = i % 2 == 0 ?[UIColor purpleColor] :[UIColor blackColor];
    
}







- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
