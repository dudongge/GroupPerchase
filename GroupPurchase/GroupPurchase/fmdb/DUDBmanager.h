//
//  DUDBmanager.h
//  GroupPurchase
//
//  Created by qianfeng on 15/9/12.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface DUDBmanager : NSObject
{
    FMDatabase *_fmDB;
}

+(id)sharedManager;
- (BOOL)isExists:(NSString *)username;//用户是否存在
- (void)insertUsername:(NSString *)username withPassword:(NSString *)password;//添加用户和密码
- (BOOL)isCorrect:(NSString *)username withPassword:(NSString *)password;//是否匹配


@end
