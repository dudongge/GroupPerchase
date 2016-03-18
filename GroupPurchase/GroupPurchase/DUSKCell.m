//
//  DUSKCell.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/9.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUSKCell.h"
#import "UIImageView+WebCache.h"

@implementation DUSKCell
{
   
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(DUSKModel *)model
{
    _model = model;
//    [_ima2imageView setImageWithURL:[NSURL URLWithString:model.imgurl]placeholderImage:[UIImage imageNamed:@"r2"]];
    
    [_ima2imageView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"r2"]];
    _priceLable.text = [NSString stringWithFormat:@"¥%.2f", [model.price floatValue]];
    _item_nameLable.text = model.item_name;
    _taobao_priceLable.text = [NSString stringWithFormat:@"¥%.2f",[model.taobao_price floatValue]];
    _item_shortnameLable.text = model.item_shortname;
    _endtimeLable.text = [NSString stringWithFormat:@"离开抢还剩:%d:%d:%d",arc4random()%10,arc4random()%60,arc4random()%60];
    [self creatTimer];
    
}

 - (void)creatTimer
{
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getData) userInfo:nil repeats:YES];
}

- (void)getData
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    int timer = arc4random() %1000000 +1000;
   
    int hour = (int)(timer /3600);
    int minute = (int) ((timer - hour * 3600 ))/60;
    int second = (int) (timer - hour * 3600 - minute * 60 ) / 60;
    _leftString = [NSString stringWithFormat:@"%2d:%2d:%2d",hour,minute,second];
    
}









- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
