//
//  DUFavoritemanager.h
//  GroupPurchase
//
//  Created by qianfeng on 15/9/12.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DUAppModel.h"


//收藏，访问详情的url，图片的URL ，
@interface DUFavoritemanager : NSObject

+ (id)manager;
//添加收藏
- (void)addMOdel:(DUAppModel *)model;

- (void)deleteModel:(DUAppModel *)model;


- (NSMutableArray *)allModels;

- (BOOL)isExists:(id)model;

//事务：一组数据的操作

- (void)beginTransaction;


//当开启事务之后，遇到回滚，那么开启事务之后所做的操作全部撤销


- (void)rollback;



//提交，开启事务之后所做的操作真实有效


- (void)commit;












@end
