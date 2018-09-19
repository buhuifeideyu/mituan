//
//  QLCacheManager.m
//  TiYuHui
//
//  Created by Sim on 13-1-7.
//  Copyright (c) 2013年 Sim. All rights reserved.
//

#import "QLCacheManager.h"

@implementation QLCacheManager
{
}

#define QLCacheValidableLength 1
static QLCacheManager * _shareInstance;

+(id)shareInstance
{
    if (!_shareInstance) {
        _shareInstance = [[QLCacheManager alloc] init];
    }
    return _shareInstance;
}
+(void)releaseInstance
{
    if (_shareInstance) {
        _shareInstance = nil;
    }
}

-(id)init
{
    self = [super init];
    if (self) {
        defaultValidityTime = 60 * 60;//默认1小时的缓存有效期
        __block QLFMDBHelper *cacheHelper = [QLFMDBHelper cacheDBInstance];
        FMDatabaseQueue *dbq = [cacheHelper databaseQueue];
        [dbq inDatabase:^(FMDatabase *db) {
            if (![db open]) {
                return ;
            }
            BOOL exists = [cacheHelper isExistsTable:QLCacheTableName inDatabase:db];
            if (!exists) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:@"INTEGER PRIMARY KEY AUTOINCREMENT" forKey:QLCacheId];
                [params setObject:@"INTEGER" forKey:QLCacheContentType];
                [params setObject:@"text" forKey:QLCacheContent];
                [params setObject:@"text" forKey:QLCacheKey];
                [params setObject:@"INTEGER" forKey:QLCacheValidityTime];
                BOOL createTableResult = [cacheHelper createTableInDatabase:db WithTableName:QLCacheTableName options:params];
                if (!createTableResult) {
                    NSLog(@"create cache db failed.");
                }
            }
            [db close];
        }];
    }
    return self;
}

-(void)cacheString:(NSString *)text forKey:(NSString *)key
{
    [self cacheString:text forKey:key validityTime:defaultValidityTime];
}

-(void)cacheStringwithoutCheckValidableLength:(NSString *)text forKey:(NSString *)key validityTime:(NSTimeInterval)time
{
    if (!key || !text) {
        return;
    }
    
    NSDate *_dtNow = [NSDate date];
    NSTimeInterval validity =[_dtNow timeIntervalSinceDate:QLCacheBaseDateTime];
    validity += time;
    
    
    NSString *_condition = [NSString stringWithFormat:@"%@ = '%@'",QLCacheKey,key];
    NSMutableDictionary *_newValues = [NSMutableDictionary dictionary];
    
    [_newValues ql_setInterge:validity forKey:QLCacheValidityTime];
    [_newValues ql_setInterge:0 forKey:QLCacheContentType];
    [_newValues ql_setObject:key forKey:QLCacheKey];
    [_newValues ql_setObject:text forKey:QLCacheContent];
    
    QLFMDBHelper *cacheHelper = [QLFMDBHelper cacheDBInstance];
    FMDatabaseQueue *dbq = [cacheHelper databaseQueue];
    [dbq inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            return ;
        }
        BOOL result = [cacheHelper recordDataToDatabase:db withTable:QLCacheTableName where:_condition newValues:_newValues];
        if (!result) {
            NSLog(@"record for key:%@ faild.",key);
        }
        [db close];
    }];
    
}

-(void)cacheString:(NSString *)text forKey:(NSString *)key validityTime:(NSTimeInterval)time
{
    if (!key || !text || [text length] < QLCacheValidableLength) {
        return;
    }
    
    NSDate *_dtNow = [NSDate date];
    NSTimeInterval validity =[_dtNow timeIntervalSinceDate:QLCacheBaseDateTime];
    validity += time;
    
    
    NSString *_condition = [NSString stringWithFormat:@"%@ = '%@'",QLCacheKey,key];
    NSMutableDictionary *_newValues = [NSMutableDictionary dictionary];
    //    NSData *str_dt = [text dataUsingEncoding:NSUTF8StringEncoding];
    //    NSData *store_content = [QLNSDataGZipAdditions compressedDataWithData:str_dt];
    //    NSData *store_content = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    [_newValues ql_setInterge:validity forKey:QLCacheValidityTime];
    [_newValues ql_setInterge:0 forKey:QLCacheContentType];
    [_newValues ql_setObject:key forKey:QLCacheKey];
    [_newValues ql_setObject:text forKey:QLCacheContent];
    
    QLFMDBHelper *cacheHelper = [QLFMDBHelper cacheDBInstance];
    FMDatabaseQueue *dbq = [cacheHelper databaseQueue];
    [dbq inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            return ;
        }
        BOOL result = [cacheHelper recordDataToDatabase:db withTable:QLCacheTableName where:_condition newValues:_newValues];
        if (!result) {
            NSLog(@"record for key:%@ faild.",key);
        }
        [db close];
    }];
}

-(void)stringCacheForKey:(NSString *)key resultCallback:(QLCacheResultBlock)callback
{
    if (!key) {
        if (callback) {
            callback(key,nil);
        }
        return;
    }
    [self stringCacheForKey:key ignoreValidity:NO resultCallback:callback];
}

-(void)stringCacheForKey:(NSString *)key ignoreValidity:(BOOL)validity resultCallback:(QLCacheResultBlock)callback
{
    if (!key) {
        if (callback) {
            callback(nil,nil);
        }
        return;
    }
    __block QLFMDBHelper *cacheHelper = [QLFMDBHelper cacheDBInstance];
    FMDatabaseQueue *dbq = [cacheHelper databaseQueue];
    [dbq inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            if (callback) {
                callback(nil,nil);
            }
            return ;
        }
        NSString *_condition = [NSString stringWithFormat:@"%@ = '%@'",QLCacheKey,key];
        FMResultSet *_results = [cacheHelper selectRecordsInDatabase:db withTable:QLCacheTableName where:_condition params:nil];
        //        NSData *content = nil;
        NSString *_strcontent = nil;
        if (_results) {
            if ([_results next]) {
                NSTimeInterval validityTime = [_results intForColumn:QLCacheValidityTime];
                NSDate *dtnow = [NSDate date];
                NSTimeInterval ti_now = [dtnow timeIntervalSinceDate:QLCacheBaseDateTime];
                int offset = validityTime - ti_now;
                if (validity || offset > 0) {
                    //忽略缓存有效期/处于有效期内
                    _strcontent = [_results objectForColumnName:QLCacheContent];
                }else{
                    //删除失效的缓存
                    NSString *_delCondition = [NSString stringWithFormat:@"%@ = '%@'",QLCacheKey,key];
                    [cacheHelper removeRecordsInDatabase:db Table:QLCacheTableName where:_delCondition params:nil];
                }
            }
        }
        [db close];
        if (callback) {
            callback(key,_strcontent);
        }
    }];
    
}

-(void)removeCacheForKey:(NSString *)key
{
    if (!key) {
        return ;
    }
    NSString *_condition = [NSString stringWithFormat:@"%@ = %@",QLCacheKey,key];
    __block QLFMDBHelper *cacheHelper = [QLFMDBHelper cacheDBInstance];
    FMDatabaseQueue *dbq = [cacheHelper databaseQueue];
    [dbq inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            return ;
        }
        [cacheHelper removeRecordsInDatabase:db Table:QLCacheTableName where:_condition params:nil];
        [db close];
    }];
}

-(void)cleanInvalidityCache
{
    NSDate *dtNow = [NSDate date];
    NSTimeInterval ti_now = [dtNow timeIntervalSinceDate:QLCacheBaseDateTime];
    NSString *_condition = [NSString stringWithFormat:@"%@ < %f",QLCacheValidityTime,ti_now];
    __block QLFMDBHelper *cacheHelper = [QLFMDBHelper cacheDBInstance];
    FMDatabaseQueue *dbq = [cacheHelper databaseQueue];
    [dbq inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            return ;
        }
        [cacheHelper removeRecordsInDatabase:db Table:QLCacheTableName where:_condition params:nil];
        [db close];
    }];
}

-(void)cleanAllCache
{
    __block QLFMDBHelper *cacheHelper = [QLFMDBHelper cacheDBInstance];
    FMDatabaseQueue *dbq = [cacheHelper databaseQueue];
    [dbq inDatabase:^(FMDatabase *db) {
        if (![db open]) {
            return ;
        }
        [cacheHelper cleanTable:QLCacheTableName inDatabase:db];
        [db close];
    }];
}

@end
