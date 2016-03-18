//
//  DUAppModel.h
//  GroupPurchase
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DUAppModel : NSObject
@property(nonatomic,copy)NSString *cPrice;
@property(nonatomic,copy)NSString *currenttime;
@property(nonatomic,copy)NSString *detailUrl;

@property(nonatomic,copy)NSString *detailUrllos;
@property(nonatomic,copy)NSString *discount;
@property(nonatomic,copy)NSString *endtime;
@property(nonatomic,copy)NSString *express_fee;
@property(nonatomic,copy)NSString *is_hot;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *oPrice;
@property(nonatomic,copy)NSString *picUrl;
@property(nonatomic,copy)NSString *previewUrl;
@property(nonatomic,copy)NSString *starttime;
@property(nonatomic,assign)NSInteger viewtotal;
@property (nonatomic,copy) NSString *source;
@end
