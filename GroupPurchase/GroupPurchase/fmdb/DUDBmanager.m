//
//  DUDBmanager.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/12.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUDBmanager.h"

@implementation DUDBmanager
+(id)sharedManager
{
    static DUDBmanager *_m = nil;
    if (!_m) {
        _m = [[DUDBmanager alloc]init];
    }
    return _m;
}

//初始化环境
-(instancetype)init
{
    self = [super init];
    if (self) {
        //拼接沙河路径
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/login.db"];
        _fmDB = [[FMDatabase alloc]initWithPath:path];
      //  NSLog(@"%@",path);
        if ([_fmDB open]) {
            //sql语句创建login 库
            NSString *sql = @"create table if not exists login(username varchar(128),password varchar(128))";
            //执行以上操作，开启sql
            [_fmDB executeUpdate:sql];
        }
    }
    return self;
}
//判断是否存在
- (BOOL)isExists:(NSString *)username
{
    NSString *sql = @"select username from login where username=?";
    //查询是否存在
    FMResultSet *set = [_fmDB executeQuery:sql,username];
    return [set next];
}

//创建用户

- (void)insertUsername:(NSString *)username withPassword:(NSString *)password
{
    NSString *sql = @"insert into login (username,password) values (?,?)";
    [_fmDB executeUpdate:sql,username,password];
}

//判断用户名密码是否匹配

- (BOOL)isCorrect:(NSString *)username withPassword:(NSString *)password
{
    NSString *sql = @"select * from login where username=?";
    FMResultSet *set = [_fmDB executeQuery:sql,username];
    while ([set next]) {
        //获得密码
        NSString *pwd = [set stringForColumn:@"password"];
        //进行判断
        if ([pwd isEqualToString:password]) {
            return YES;
        }
    }
    return NO;
}






@end
