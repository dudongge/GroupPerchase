//
//  DUCacheManager.h
//  GroupPurchase
//
//  Created by qianfeng on 15/9/11.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DUCacheManager : NSObject
+ manager;
- (BOOL)isExists:(NSString *)cachename;
- (NSData *)getCache:(NSString*)cachename;
- (void)saveCache:_data forName:_urlString;
- (void)saveCache:(id)_data forName:(id)_urlString currentPage:(NSInteger)page;
@end
