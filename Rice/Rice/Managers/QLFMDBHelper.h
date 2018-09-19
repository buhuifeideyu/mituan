//
//  QLFMDBHelper.h
//  QLKit
//
//  Created by Sim on 13-2-1.
//  Copyright (c) 2013年 3gtv.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMDatabaseAdditions.h"
#import "RegexKitLite.h"
#import "NSMutableDictionary+QL.h"

#define FMDB_NAME @"rice_db.sqlite"
#define FMDB_CACHE @"rice_cache_db.sqlite"

typedef enum{
    QL_INT = 1,
    QL_NSINTEGER = 1,
    QL_FLOAT = 2,
    QL_DOUBLIE = 2,
    QL_NSSTRING = 3,
    QL_BOOL = 4,
    QL_LONG = 5,
    QL_CHAR = 6,
    QL_OBJ = 99
} QL_DB_TO_OBC_TYPE;

@interface QLFMDBTableInfoTable:NSObject

@property (nonatomic,assign) long _id;
@property (nonatomic,strong) NSString *tableName;
@property (nonatomic,strong) NSString *rowsInfo;
@property (nonatomic,strong) NSString *numberOfRows;
@end

@interface QLFMDBHelper : NSObject
{
    NSString *_dbpath;
    NSString *_dbName;
}

@property (nonatomic,assign) BOOL printSQL;

+(id)shareInstance;
+(id)cacheDBInstance;
+(void)releaseInstance:(QLFMDBHelper *)helper;

-(FMDatabaseQueue *)databaseQueue;
/**
 *  获取默认数据库
 *
 *  @return
 */
-(FMDatabase *)getDatabaseHandle;

/**
 *  创建表
 *
 *  @param clz 需要映射的类
 *  @param db  数据库
 *  @return 是否创建成功
 */
- (BOOL)createTableWithClass:(Class)clz inDatabase:(FMDatabase *)db;


/**
 创建数据表

 @param tableName 表名
 @param clz 需要隐射的类
 @param db 数据库
 @return 是否创建成功
 */
- (BOOL)createTable:(NSString *)tableName withClass:(Class)clz inDatabase:(FMDatabase *)db;

/**
 *  保存数据记录
 *
 *  @param obj   需要保存的数据
 *  @param db    保存的数据库
 *  @param where 保存条件，允许为空nil,当条件为空时，只会插入数据，不会更新数据。
 *
 *  @return 保存是否成功
 */
- (BOOL)save:(id)obj inDatabase:(FMDatabase *)db where:(NSString *)where;

/**
 *  清除表记录
 *
 *  @param clz 类对象
 *  @param db  操作的数据库
 *
 *  @return 操作结果
 */
- (BOOL)cleanTableWithClass:(Class)clz inDatabase:(FMDatabase *)db;

/**
 *  清除表记录
 *
 *  @param clz 类对象
 *
 *  @return 操作结果
 */
- (BOOL)cleanTable:(Class)clz;

/**
 *  删除记录
 *
 *  @param clz   记录类
 *  @param where 操作条件
 *  @param db    操作数据库
 *
 *  @return 操作结果
 */
- (BOOL)remove:(Class)clz where:(NSString *)where inDatabase:(FMDatabase *)db;

/**
 *  删除记录
 *
 *  @param clz   记录类
 *  @param where 操作条件
 *
 *  @return 操作结果
 */
- (BOOL)remove:(Class)clz where:(NSString *)where;

/**
 *  查询默认数据库的数据记录
 *
 *  @param clz   查询的对象类型
 *  @param where 查询条件,允许为空nil,（sql 语句的查询条件，eg: '_id' = 1234）
 *
 *  @return 查询结果列表
 */
- (NSArray *)query:(Class)clz where:(NSString *)where;

/**
 *  查询数据记录
 *
 *  @param clz   查询的对象类型
 *  @param where 查询条件,允许为空nil,（sql 语句的查询条件，eg: '_id' = 1234）
 *  @param db    数据库
 *
 *  @return 查询结果列表
 */
- (NSArray *)query:(Class)clz where:(NSString *)where inDatabase:(FMDatabase *)db;

/**
 *  检查表<table>是否存在
 *
 *  @param table 表名
 *  @param db    数据库
 *
 *  @return 是否存在
 */
-(BOOL)isExistsTable:(NSString *)table inDatabase:(FMDatabase *)db;

/**
 *  在数据库中创建表
 *
 *  @param db        数据库
 *  @param tableName 表名
 *  @param param     附加参数
 *
 *  @return 创建结果
 */
-(BOOL)createTableInDatabase:(FMDatabase *)db WithTableName:(NSString *)tableName options:(NSDictionary *)param;

/**
 *  清空表数据
 *
 *  @param tableName 表名
 *  @param db        数据库
 *
 *  @return 清空结果
 */
-(BOOL)cleanTable:(NSString *)tableName inDatabase:(FMDatabase *)db;

/**
 *  是否存在记录
 *  查询（tableName）库中是否存在符合 条件为(where) 的记录
 *
 *  @param db        数据库
 *  @param tableName 表名
 *  @param where     查询条件
 *  @param params    条件参数
 *
 *  @return 查询结果
 */
-(BOOL)isExistsRecordInDatabase:(FMDatabase *)db withTable:(NSString *)tableName where:(NSString *)where params:(NSDictionary *)params;

/**
 *  查询库中有多少条符合条件的记录，where eg: userName = '张三'
 *
 *  @param db        数据库
 *  @param tableName 表名
 *  @param where     查询条件
 *  @param params    条件参数
 *
 *  @return
 */
-(NSInteger)numberOfCountRecordsInDatabase:(FMDatabase *)db withTable:(NSString *)tableName where:(NSString *)where params:(NSDictionary *)params;

/**
 *  //查询N行记录集合 (注意：记得手动关闭数据集)
 *
 *  @param db        数据库
 *  @param tableName 表名
 *  @param wheres    操作条件
 *  @param params    操作参数
 *
 *  @return
 */
-(FMResultSet *)selectRecordsInDatabase:(FMDatabase *)db withTable:(NSString *)tableName where:(NSString *)wheres params:(NSDictionary *)params;

/**
 *  查询一条记录内的属性值，如果存在多条记录，只返回第一条记录的结果
 *
 *  @param db           数据库
 *  @param tableName    表名
 *  @param where        操作条件
 *  @param propertyName 属性名集合
 *  @param params       参数列表
 *
 *  @return 返回查询结果集
 */
-(id)selectRecodrdInDatabase:(FMDatabase *)db withTable:(NSString *)tableName where:(NSString *)where propertyName:(NSString *)propertyName params:(NSDictionary *)params;

/**
 *  更新/插入 记录（推荐）
 *
 *  @param db        数据库
 *  @param tableName 表名
 *  @param where     操作条件
 *  @param params    参数列表
 *
 *  @return 操作是否成功
 */
-(BOOL)recordDataToDatabase:(FMDatabase *)db withTable:(NSString *)tableName where:(NSString *)where newValues:(NSDictionary *)params;

/**
 *  删除记录
 *
 *  @param db        数据库
 *  @param tableName 表名
 *  @param where     操作条件
 *  @param params    操作参数
 *
 *  @return 删除结果
 */
-(BOOL)removeRecordsInDatabase:(FMDatabase *)db Table:(NSString *)tableName where:(NSString *)where params:(NSDictionary *)params;

/**
 *  使用自定义SQL条件语句查询数据
 *
 *  @param db         数据库
 *  @param table      表名
 *  @param condiction 操作条件语句
 *  @param values     操作参数
 *
 *  @return 返回结果集
 */
-(FMResultSet*)selectDataInDataBase:(FMDatabase *)db withTable:(NSString *)table withwhere:(NSString*)condiction withValueList:(NSArray *)values;


/**
 插入数据

 @param datas 需要插入的数据
 @param table 操作的表
 @param rows 插入列名
 @param db 数据库
 @return 是否操作成功
 */
- (BOOL)insert:(NSArray *)datas inTable:(NSString *)table withRows:(NSArray<NSString *>*)rows inDatabase:(FMDatabase *)db;

@end
