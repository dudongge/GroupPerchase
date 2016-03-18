//
//  DUBrandModel.h
//  GroupPurchase
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DUBrandModel : NSObject
@property(nonatomic,copy)NSString *ios_url;
@property(nonatomic,copy)NSString *brand_name;//品牌
@property(nonatomic,copy)NSString *detailUrlIos;//详情
@property(nonatomic,copy)NSString *catname;//栏目名称
@property(nonatomic,copy)NSString *imgurl;//图片链接
@property(nonatomic,copy)NSString *item_name;//品名
@property(nonatomic,copy)NSString *price;//价格
@property(nonatomic,copy)NSString *taobao_price;//淘宝价格
@property(nonatomic,copy)NSString *discount;//折扣
@property(nonatomic,copy)NSString *brand_rul;//品牌链接


@end
