//
//  DUCacheManager.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/11.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUCacheManager.h"
#import "NSString+MD5Addition.h"


@implementation DUCacheManager
{
    NSFileManager *_fileManager;
    NSString *_basePath;
}
+ manager;
{
    static DUCacheManager *_m = nil;
    if (!_m) {
        _m = [[DUCacheManager alloc]init];
    }
    return _m;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
        _basePath = [[NSHomeDirectory()stringByAppendingPathComponent:@"Ducuments"]stringByAppendingPathComponent:@"GroupPurchase"];
     //   NSLog(@"%@",_basePath);
        //如果文件不存在
        if (![_fileManager fileExistsAtPath:_basePath])
        {
            //创建
            [_fileManager createDirectoryAtPath:_basePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
    }
    return self;
}


- (BOOL)isExists:(NSString *)cachename
{
    return [_fileManager fileExistsAtPath:[self urlWithCacheName:cachename]];
}
- (NSData *)getCache:(NSString*)cachename
{
    return [NSData dataWithContentsOfFile:[self urlWithCacheName:cachename]];
}
- (void)saveCache:_data forName:_urlString
{
    NSString *path = [self urlWithCacheName:_urlString];
    [_data writeToFile:path atomically:YES];
}
- (void)saveCache:(id)_data forName:(id)_urlString currentPage:(NSInteger)page
{
    if (page == 1) {
        [self saveCache:_data forName:_urlString];
        return ;
    }
    //先取出之前的数据并解析
    NSData *oldData = [self getCache:_urlString];
    NSDictionary *oldDic = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableLeaves error:nil];
    NSArray *oldArr = oldDic[@"goodsArray"];
    //解析现在新的数据
    NSDictionary *newDict = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableLeaves error:nil];
    NSArray *newArr = newDict[@"goodsArray"];
    //拼接两个数组
    NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:oldArr];
    [arr addObjectsFromArray:newArr];
    //将数组按照之前的格式保存到本地
    NSDictionary *dic  = @{@"goodsArray":arr};
    NSData *dat = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [self saveCache:dat forName:_urlString];
    
    //保存当前的页数
    [[NSUserDefaults standardUserDefaults]setValue:@(page) forKey:_urlString];
    [[NSUserDefaults standardUserDefaults]synchronize];

    
    
    
    
    
    
}






- (NSString *)urlWithCacheName:(NSString *)name
{
    NSString *urlmd5 = [name stringFromMD5];
    return [_basePath stringByAppendingPathComponent:urlmd5];
}


@end
