//
//  QLCacheManager.h
//  TiYuHui
//
//  Created by Sim on 13-1-7.
//  Copyright (c) 2013年 Sim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLFMDBHelper.h"
#import "NSMutableDictionary+QL.h"
#import "NSDate+QL.h"

typedef void(^QLCacheResultBlock)(id key , id content);

typedef enum{
      kQLCacheContentTypeString = 0,
      kQLCacheContentTypeData = 1
}QLCacheContentType;

#define QLCacheTableName @"ql_cache_tb"
#define QLMessageTableName @"ql_message_tb"
#define QLGameFollowTableName @"ql_gamefollow_tb"
#define QLReserverInfoTableName @"ql_reserverinfo_tb"
#define QLCacheId @"cacheId"
#define QLCacheContentType @"cacheContentType"
#define QLCacheKey @"cacheKey"
#define QLCacheContent @"cacheContent"
#define QLCacheValidityTime @"cacheLiveTime"
#define QLCacheBaseDateTime [NSDate ql_dateWithString:@"2015-01-01 00:00:00"]

@interface QLCacheManager : NSObject
{
    NSTimeInterval defaultValidityTime;//默认有效期
}

+(id)shareInstance;
+(void)releaseInstance;

//缓存内容，并默认有效期为1小时。
-(void)cacheString:(NSString *)text forKey:(NSString *)key;

//缓存一段string内容，并设置于 |time| 秒后缓存过期。
-(void)cacheString:(NSString *)text forKey:(NSString *)key validityTime:(NSTimeInterval)time;

//缓存一段string内容，但不校验数据的长度。
-(void)cacheStringwithoutCheckValidableLength:(NSString *)text forKey:(NSString *)key validityTime:(NSTimeInterval)time;

//提取缓存内容（默认），并检查有效期。
-(void)stringCacheForKey:(NSString *)key resultCallback:(QLCacheResultBlock)callback;

//提取缓存内容，可设置是否忽略有效期。
//-(NSString *)stringCacheForKey:(NSString *)key ignoreValidity:(BOOL)validity;
-(void)stringCacheForKey:(NSString *)key ignoreValidity:(BOOL)validity resultCallback:(QLCacheResultBlock)callback;

//删除指定缓存
-(void)removeCacheForKey:(NSString *)key;

//清理失效缓存
-(void)cleanInvalidityCache;

//清除所有缓存
-(void)cleanAllCache;
@end
