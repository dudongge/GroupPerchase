//
//  DUFavoritemanager.m
//  GroupPurchase
//
//  Created by qianfeng on 15/9/12.
//  Copyright (c) 2015年 dudongge. All rights reserved.
//

#import "DUFavoritemanager.h"
#import "FMDatabase.h"


@implementation DUFavoritemanager
{
    FMDatabase *_fmdb;
}

+(id)manager
{
    static DUFavoritemanager *_m = nil;
    if (!_m) {
        _m = [[DUFavoritemanager alloc]init];
    }
    return _m;
}
//利用数据库进行数据的本地管理要初始化本地的环境
-(instancetype)init
{
    self = [super init];
    if (self) {
        //path :指数据库文件的位置,采用拼接字符串的方法
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]stringByAppendingPathComponent:@"GPFavorite.db"];
      //  NSLog(@"%@",path);
        _fmdb = [[FMDatabase alloc]initWithPath:path];
        //打开数据库
        //如果不存在，就先创建
        //如果存在，就直接打开使用
        BOOL succes = [_fmdb open];
        if (succes) {
            //如果打开成功，就常见数据库表
            NSString *sql = @"create table if not exists app(detailUrl varchar(256),name varchar(128),picUrl varchar(256) ,oPrice varchar(128),cPrice varchar(128),discount varchar(128))";
            
            if (![_fmdb executeUpdate:sql]) {
                NSLog(@"创建数据失败");
            }
        }
      
    }
    return self;
}

//添加收藏
-(void)addMOdel:(DUAppModel *)model
{
    NSString *sql = @"insert into app(detailUrl,name,picUrl,oPrice,cPrice,discount) values (?,?,?,?,?,?)";
    BOOL success = [_fmdb executeUpdate:sql,model.detailUrl,model.name,model.picUrl,model.oPrice,model.cPrice,model.discount];
    if (success) {
        NSLog(@"收藏成功");
    }
 
}

//删除收藏

- (void)deleteModel:(DUAppModel *)model
{
    NSString *sql = @"delete from app where detailUrl=?";
    [_fmdb executeUpdate:sql,model.detailUrl,model.oPrice,model.cPrice,model.discount];
}

//获得所有的模型
- (NSMutableArray *)allModels
{
    NSMutableArray *resArr = [[NSMutableArray alloc]init];
    NSString *sql = @"select * from app";
    FMResultSet *result= [_fmdb executeQuery:sql];
    while ([result next]) {
        NSString *detail = [result stringForColumn:@"detailUrl"];
        NSString *name = [result stringForColumn:@"name"];
        NSString *picUrl = [result stringForColumn:@"picUrl"];
        NSString *oPrice = [result stringForColumn:@"oPrice"];
        NSString *cPrice = [result stringForColumn:@"cPrice"];
        NSString *discount = [result stringForColumn:@"discount"];
        DUAppModel *model = [[DUAppModel alloc]init];
        model.detailUrl = detail;
        model.name = name;
        model.picUrl= picUrl;
        model.oPrice = oPrice;
        model.cPrice = cPrice;
        model.discount = discount;
        [resArr addObject:model];
    }
    return resArr;

}

//判断是否存在
- (BOOL)isExists:(id)model
{
    NSString *detail;
    if ([model isKindOfClass:[DUAppModel class]]) {
        detail = [(DUAppModel *)model detailUrl];
    }
    else
    {
        detail = model;
    }
    
    NSString *sql = @"select * from app where detailUrl=?";
    FMResultSet *result = [_fmdb executeQuery:sql,detail];
    return [result next];
}



//事务：一组数据库的操作


- (void)beginTransaction
{
    //在开启事务之后不能在开启事务
    if([_fmdb inTransaction])
    {
        [_fmdb beginTransaction];
    }

}

//开启事务之后遇到回滚，那么开启事务所做的操作全部清除


- (void)rollback
{
    if ([_fmdb inTransaction]) {
        [_fmdb rollback];
    }
}


//提交，开启事务之后所做的操作真实有效

- (void)commit
{
    if ([_fmdb inTransaction]) {
        [_fmdb commit];
    }
}








@end
