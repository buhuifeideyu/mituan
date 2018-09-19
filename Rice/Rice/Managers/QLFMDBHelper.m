//
//  QLFMDBHelper.m
//  QLKit
//
//  Created by Sim on 13-2-1.
//  Copyright (c) 2013年 3gtv.net. All rights reserved.
//

#import "QLFMDBHelper.h"
#import "NSDictionary+QL.h"
#import "JSONKit.h"

//@interface DBTypeTestModel : NSObject
//@property (nonatomic,assign) int ia;
//@property (nonatomic,assign) NSInteger ib;
//@property (nonatomic,assign) float fa;
//@property (nonatomic,assign) CGFloat fb;
//@property (nonatomic,assign) double fc;
//@property (nonatomic,strong) NSString *str;
//@property (nonatomic,strong) NSDate *dt;
//@property (nonatomic,assign) long la;
//@property (nonatomic,assign) BOOL ba;
//@property (nonatomic,assign) char ca;
//@property (nonatomic,assign) Byte bt;
//@end

#define QLFMDBTableInfoTableKey @"QLFMDBTableInfoTable"

@implementation QLFMDBTableInfoTable

@end

@implementation QLFMDBHelper
{
     NSMutableDictionary *db_type_dic;
    NSMutableDictionary *db_to_model_type_dic;
}
static QLFMDBHelper *_defaultHelper;
static QLFMDBHelper *_cacheHelper;


+(id)shareInstance
{
    if (_defaultHelper == nil) {
        _defaultHelper = [self createDBInstance:FMDB_NAME];
    }
    return _defaultHelper;
}

+(id)cacheDBInstance
{
    if (_cacheHelper == nil) {
        _cacheHelper = [self createDBInstance:FMDB_CACHE];
    }
    return _cacheHelper;
}


+(void)releaseInstance:(QLFMDBHelper *)helper
{
    helper = nil;
}

+ (NSString *)documentDirectory{
    NSArray *documentPaths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    NSString *ourDocumentPath = [documentPaths objectAtIndex:0];
    return ourDocumentPath;
}

+ (id)createDBInstance:(NSString *)dbFileName{
    NSString *docsdir = [self documentDirectory] ;
    docsdir = [docsdir stringByAppendingPathComponent:@"qldb"];
    NSError *error;
    NSFileManager *filemng = [NSFileManager defaultManager];
    [filemng createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:&error];
    NSString *dbpath = [docsdir stringByAppendingPathComponent:dbFileName];
    QLFMDBHelper *newHelper = [[QLFMDBHelper alloc] initWithPath:dbpath];
    return newHelper;
}

- (void)initInstance{
     db_type_dic = [NSMutableDictionary dictionary];
    
    [db_type_dic ql_setObject:@"INTEGER" forKey:@"Ti"];
    [db_type_dic ql_setObject:@"INTEGER" forKey:@"Tq"];
    [db_type_dic ql_setObject:@"INTEGER" forKey:@"NSInteger"];
    [db_type_dic ql_setObject:@"INTEGER" forKey:@"int"];
    [db_type_dic ql_setObject:@"INTEGER" forKey:@"long"];
    [db_type_dic ql_setObject:@"INTEGER" forKey:@"Byte"];
    [db_type_dic ql_setObject:@"INTEGER" forKey:@"char"];
    [db_type_dic ql_setObject:@"INTEGER" forKey:@"BOOL"];
    [db_type_dic ql_setObject:@"REAL" forKey:@"NSNumber"];
    [db_type_dic ql_setObject:@"REAL" forKey:@"float"];
    [db_type_dic ql_setObject:@"REAL" forKey:@"NSDate"];
    [db_type_dic ql_setObject:@"REAL" forKey:@"CGFloat"];
    [db_type_dic ql_setObject:@"REAL" forKey:@"NSTimeInterval"];
    [db_type_dic ql_setObject:@"BLOB" forKey:@"NSData"];
    [db_type_dic ql_setObject:@"TEXT" forKey:@"NSString"];
    [db_type_dic ql_setObject:@"TEXT" forKey:@"NSArray"];
    
    db_to_model_type_dic = [NSMutableDictionary dictionary];
    [db_to_model_type_dic ql_setInterge:QL_NSSTRING forKey:@"T@\"NSString\""];
    [db_to_model_type_dic ql_setInterge:QL_INT forKey:@"Ti"];
    [db_to_model_type_dic ql_setInterge:QL_LONG forKey:@"Tl"];
    [db_to_model_type_dic ql_setInterge:QL_BOOL forKey:@"Tb"];
    [db_to_model_type_dic ql_setInterge:QL_FLOAT forKey:@"Tf"];
    [db_to_model_type_dic ql_setInterge:QL_DOUBLIE forKey:@"Td"];
    [db_to_model_type_dic ql_setInterge:QL_CHAR forKey:@"Tc"];
    [db_to_model_type_dic ql_setInterge:QL_OBJ forKey:@""];
    
}

/**
 *  检查是否需要升级表结构
 *
 *  @param clz 类
 *  @param db  数据库
 *
 *  @return YES:需要升级表；NO：无需升级
 */
- (BOOL)needUpdateTable:(Class)clz db:(FMDatabase *)db{
    NSString *talbeName = NSStringFromClass(clz);
    if ([talbeName isEqualToString:QLFMDBTableInfoTableKey]) {
        return NO;
    }
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(clz, &count);
    
    NSString *where = [NSString stringWithFormat:@"tableName = '%@'",clz];
    NSArray *rows_infos = [self query:[QLFMDBTableInfoTable class] where:where];
    if (rows_infos == nil || rows_infos.count < 1) {
        free(properties);
        return YES;
    }
    QLFMDBTableInfoTable *old_table_rows_info = [rows_infos firstObject];
    NSArray *rows_list = [old_table_rows_info.rowsInfo objectFromJSONString];
    if (rows_list.count != count) {
        free(properties);
        return YES;
    }
    BOOL _update = NO;
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *property_name = [NSString stringWithUTF8String:property_getName(property)];
        if(![rows_list containsObject:property_name]){
            _update = YES;
            break;
        }
    }
    free(properties);
    
    return _update;
}

/**
 *  更新表结构
 *
 *  @param clz 类
 *  @param db  数据库
 */
- (void)updateTable:(Class)clz db:(FMDatabase *)db{
    NSString *tableName = NSStringFromClass(clz);
    QLFMDBHelper *helper = [QLFMDBHelper shareInstance];
    BOOL upgradResult = NO;
    
    //重命名旧表，以备份数据
    NSString *renameSQL = [NSString stringWithFormat:@"alter table %@ rename to old_%@",tableName,tableName];
    BOOL renameResult = [db executeUpdate:renameSQL];
    
    if (renameResult) {
        BOOL createTableResult = [helper createTableWithClass:clz inDatabase:db];
        if (createTableResult) {
            //创建新表成功，复制旧数据到新表
            NSArray *newTableRowNames = [self getClassPropertyList:clz];
            
            NSString *old_talbe_info_where = [NSString stringWithFormat:@"tableName = '%@'",tableName];
            NSArray *talbe_info_set = [self query:[QLFMDBTableInfoTable class] where:old_talbe_info_where];
            
            QLFMDBTableInfoTable *old_talble_info = [talbe_info_set firstObject];
            NSArray *talbe_rows_list = [old_talble_info.rowsInfo objectFromJSONString];
            
            NSMutableArray *propertyToCopy = [NSMutableArray array];//需要复制数据的列
            for (NSString *p in talbe_rows_list) {
                for (NSString *_tk in newTableRowNames) {
                    if ([p isEqualToString:_tk]) {
                        [propertyToCopy addObject:p];
                        break;
                    }
                }
            }
            NSInteger keyCount = [propertyToCopy count];
            NSMutableString *propertys = [NSMutableString string];
            for (int idx = 0; idx < keyCount; ++idx) {
                NSString *key = [propertyToCopy objectAtIndex:idx];
                if (idx != keyCount -1) {
                    [propertys appendFormat:@"%@,",key];
                }else{
                    [propertys appendString:key];
                }
            }
            BOOL copyResult = NO;
            if (keyCount > 0) {
                NSString *copyDataSQL = [NSString stringWithFormat:@"insert into %@ (%@) select %@ from old_%@",
                                         tableName,
                                         propertys,
                                         propertys,
                                         tableName];
                copyResult = [db executeUpdate:copyDataSQL];
            }
            upgradResult = YES;
            NSLog(@"create new table success ,restore %@ 's data %@",tableName,copyResult?@"successful.":@"failed.");
            NSString *delOldTable = [NSString stringWithFormat:@"drop table old_%@",tableName];
            BOOL delTableResult = [db executeUpdate:delOldTable];
            NSLog(@"deleted old table %@ %@",tableName,delTableResult?@"successful.":@"failed.");
            
        }else{
            NSLog(@"try to create new table %@ failed,we had to restore this table.",tableName);
            NSString *restoreTableName = [NSString stringWithFormat:@"alter table old_%@ rename to %@",tableName,tableName];
            BOOL restoreResult = [db executeUpdate:restoreTableName];
            NSLog(@"resore table %@ %@",tableName,restoreResult?@"successful.":@"failed.");
        }
    }else{
        NSLog(@"try to upgrad table %@ failed,as rename to old_%@ failed.",tableName,tableName);
    }
    
    
    if (upgradResult) {
        //升级成功!保存新的表结构
        NSArray *propertyList = [self getClassPropertyList:clz];
        QLFMDBTableInfoTable *newTableRowsInfo = [[QLFMDBTableInfoTable alloc] init];
        newTableRowsInfo.tableName = tableName;
        newTableRowsInfo.rowsInfo = [propertyList JSONString];
        newTableRowsInfo.numberOfRows = [NSString stringWithFormat:@"%li",propertyList.count ];
        
    }
    
    
}

- (BOOL)createTable:(NSString *)tableName withClass:(Class)clz inDatabase:(FMDatabase *)db{
    NSString *table_name = [tableName copy];//NSStringFromClass(clz);
    if ([self isExistsTable:table_name inDatabase:db]) {
        //检查表结构，是否需要升级。
        BOOL updateTable = [self needUpdateTable:clz db:db];
        if (updateTable) {
            [self updateTable:clz db:db];
        }
        return YES;
    }
    NSMutableDictionary *table_info = [NSMutableDictionary dictionary];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(clz, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *property_name = [NSString stringWithUTF8String:property_getName(property)];
        NSString *property_Attributes = [NSString stringWithUTF8String:property_getAttributes(property)];
        NSRange range = [property_Attributes rangeOfString:@","];
        NSString *property_type_str = [property_Attributes substringToIndex:range.location];
        NSString *dbtype = [self getDatabaseType:property_type_str];
        NSLog(@"%@ ,type:%@ dbtype:%@",property_name,property_type_str,dbtype);
        if([property_name isEqualToString:@"_id"]){
            //默认为数据表的主键
            BOOL auto_increment_enable = [dbtype isEqualToString:@"INTEGER"]?YES:NO;
            NSString *_type = [NSString stringWithFormat:@"%@ PRIMARY KEY%@",dbtype,auto_increment_enable?@" AUTOINCREMENT":@""];
            [table_info ql_setObject:_type forKey:property_name];
        }else{
            [table_info ql_setObject:dbtype forKey:property_name];
        }
    }
    [table_info ql_setObject:@"TEXT" forKey:table_name];
    if (![table_name isEqualToString:QLFMDBTableInfoTableKey]) {
        //记录表结构到 QLFMDBTableInfoTable
        NSArray *propertyList = [self getClassPropertyList:clz];
        QLFMDBTableInfoTable *tableInfo = [[QLFMDBTableInfoTable alloc]init];
        tableInfo.tableName = table_name;
        tableInfo.rowsInfo = [propertyList JSONString];
        tableInfo.numberOfRows = [NSString stringWithFormat:@"%li",propertyList.count];
        NSString *where = [NSString stringWithFormat:@"tableName = '%@'",table_name];
        [self save:tableInfo inDatabase:db where:where];
        [db open];
    }
    
    free(properties);
    NSLog(@"class:%@",table_name);
    return [self createTableInDatabase:db WithTableName:table_name options:table_info];
}

- (BOOL)createTableWithClass:(Class)clz inDatabase:(FMDatabase *)db{
    NSString *table_name = NSStringFromClass(clz);
    return [self createTable:table_name withClass:clz inDatabase:db];
}

- (NSString *)getDatabaseType:(NSString *)type{
    if(type == nil || [type isEqualToString:@""]){
        return nil;
    }else{
        NSString *new_type = [db_type_dic ql_stringForKey:type];
        if (new_type == nil) {
            //没有找到对应的数据类型,强制转换成json string.
            return @"TEXT";
        }
        return new_type;
    }
}

/**
 *  Objective-C 对象转换成 NSDictionary
 *
 *  @param obj Objective-C 对象
 *
 *  @return
 */
- (NSDictionary *)objectToFMDatebaseDictionary:(id)obj{
    NSMutableDictionary *_info = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *property_name = [NSString stringWithUTF8String:property_getName(property)];
        NSString *property_Attributes = [NSString stringWithUTF8String:property_getAttributes(property)];
        NSRange range = [property_Attributes rangeOfString:@","];
        NSString *property_type_str = [property_Attributes substringToIndex:range.location];
        NSString *dbtype = [self getDatabaseType:property_type_str];
        NSLog(@"%@ ,type:%@ dbtype:%@",property_name,property_type_str,dbtype);
        [_info ql_setObject:dbtype forKey:property_name];
    }
    
    free(properties);
    return _info;
}

/**
 *  获取类属性列表
 *
 *  @param clz 类
 *
 *  @return
 */
- (NSArray *)getClassPropertyList:(Class)clz{
    NSMutableArray *list = [NSMutableArray array];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(clz, &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *property_name = [NSString stringWithUTF8String:property_getName(property)];
        [list addObject:property_name];
    }
    free(properties);

    return list;
}

/**
 *  保存对象到数据库
 *
 *  @param obj   需要保存的对象
 *  @param db    操作数据库
 *  @param where 操作条件
 *
 *  @return 操作结果
 */
- (BOOL)save:(id)obj inDatabase:(FMDatabase *)db where:(NSString *)where{
    NSString *clzName = NSStringFromClass([obj class]);
//    NSString *clzName = [NSString stringWithUTF8String:object_getClassName(obj)];
    NSMutableDictionary *_info = [NSMutableDictionary dictionary];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([obj valueForKey:key] != nil) {
            [_info setObject:[obj valueForKey:key] forKey:key];
        }
    }
    NSString *json_content = [obj JSONString];
    [_info setObject:json_content forKey:clzName];
    free(properties);

    BOOL result = [self recordDataToDatabase:db withTable:clzName where:where newValues:_info];
    return result;
}

- (BOOL)remove:(Class)clz where:(NSString *)where inDatabase:(FMDatabase *)db{
    NSString *tableName = NSStringFromClass(clz);
    return [self removeRecordsInDatabase:db Table:tableName where:where params:nil];
}

- (BOOL)remove:(Class)clz where:(NSString *)where{
    FMDatabase *db = [self getDatabaseHandle];
    [db open];
    return [self remove:clz where:where inDatabase:db];
}

- (BOOL)cleanTableWithClass:(Class)clz inDatabase:(FMDatabase *)db{
    NSString *tableName = NSStringFromClass(clz);
    return [self cleanTable:tableName inDatabase:db];
}

- (BOOL)cleanTable:(Class)clz{
    FMDatabase *db = [self getDatabaseHandle];
    [db open];
    return [self cleanTableWithClass:clz inDatabase:db];
}


/**
 *  查询数据记录
 *
 *  @param clz   查询的对象类型
 *  @param where 查询条件,允许为空nil,（sql 语句的查询条件，eg: '_id' = 1234）
 *
 *  @return 查询结果列表
 */
- (NSArray *)query:(Class)clz where:(NSString *)where{
    FMDatabase *db = [self getDatabaseHandle];
    [db open];
    return [self query:clz where:where inDatabase:db];
}


- (NSArray *)query:(Class)clz where:(NSString *)where inDatabase:(FMDatabase *)db{
    NSString *clzName = NSStringFromClass(clz);
    NSString *mainSql = nil;
    if (where != nil) {
        NSString *conditionSql = [NSString stringWithFormat:@" where %@",where];
        mainSql = [NSString stringWithFormat:@"select * from %@ %@",clzName,conditionSql];
    }else{
        mainSql = [NSString stringWithFormat:@"select * from %@",clzName];
    }
    FMResultSet *resultSet = [db executeQuery:mainSql];
    NSMutableArray *resultForReturn = nil;
    if (resultSet != nil) {
        resultForReturn = [NSMutableArray array];
        unsigned int propertyCount;
        objc_property_t *properties = class_copyPropertyList(clz, &propertyCount);
        NSMutableArray *propertiNames = [NSMutableArray array];
        for(int idx = 0 ; idx < propertyCount ; ++idx){
            NSString *pname = [NSString stringWithUTF8String:property_getName(properties[idx])];
            [propertiNames addObject:pname];
        }
        free(properties);
        
        while ([resultSet next]) {
            id instance = [[clz alloc] init];
            id content = [resultSet objectForColumnName:clzName];
            NSInteger _id = [resultSet intForColumn:@"_id"];
            if (content != nil && content != NULL && content != [NSNull null]) {
                NSDictionary *_dic = [content objectFromJSONString];
                NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:_dic];
                [_params ql_setInterge:_id forKey:@"_id"];
                [(Class)instance initWithDictionary:_params];
                [resultForReturn addObject:instance];
            }
//            for (NSString *propertyName in propertiNames) {
//                id value = [resultSet objectForColumnName:propertyName];
//                if (value != nil && value != [NSNull null]) {
//                    [instance setValue:value forKey:propertyName];
//                }
//            }
            
        }
        [resultSet close];
    }
    return resultForReturn;
}

- (NSString *)getPropertyType:(objc_property_t)property_t{
    unsigned int outCount;
    objc_property_attribute_t *attribute_list = property_copyAttributeList(property_t, &outCount);
    for (int i = 0 ; i < outCount; ++i) {
        NSString *_arrt_name = [NSString stringWithUTF8String:attribute_list[i].name];
        if ([@"T" isEqualToString:_arrt_name]) {
            return [NSString stringWithUTF8String:attribute_list[i].value];
        }
    }
    return nil;
}

- (id)getValueForProperty:(NSString *)propertyName propertyAttributes:(NSString *)attr srcValue:(id)value{
    NSRange firstFlagRan = [attr rangeOfString:@","];
    NSString *type_str = [attr substringToIndex:firstFlagRan.location];
    return nil;
}


-(id)initWithPath:(NSString *)path;
{
    self = [super init];
    if (self) {
        _dbpath = [[NSString alloc] initWithString:path];
        self.printSQL = YES;
        [self initInstance];
        FMDatabase *db = [self getDatabase];
        [db open];
        [self createTableWithClass:[QLFMDBTableInfoTable class] inDatabase:db];
    }
    return self;
}

-(FMDatabase *)getDatabaseHandle
{
    @synchronized(self){
        return [self getDatabase];
    }
}

-(FMDatabase *)getDatabase
{
    FMDatabase *db = [FMDatabase databaseWithPath:_dbpath];
    return db; 
}

-(FMDatabaseQueue *)databaseQueue
{
    FMDatabaseQueue *dbq = [FMDatabaseQueue databaseQueueWithPath:_dbpath];
    return dbq;
}

-(BOOL)isExistsTable:(NSString *)table inDatabase:(FMDatabase *)db
{
    BOOL result = NO;
    result = [db tableExists:table];
    return result;
}


- (void)releaseAll{
    
}

-(BOOL)createTableInDatabase:(FMDatabase *)db WithTableName:(NSString *)tableName options:(NSDictionary *)param
{
    if (!tableName || !param ||!db) {
        return NO;
    }
    if ([db tableExists:tableName]) {
        NSLog(@"table whitch name %@ had exist.",tableName);
        return YES;
    }
    NSMutableString *_params = [NSMutableString string];
    NSArray *propertyList = [param allKeys];
    BOOL endFlag = NO;
    int idx = -1;
    NSInteger count = [propertyList count];
    NSString *_value = nil;
    for (NSString *_property in propertyList) {
        idx++;
        endFlag = (idx == (count - 1))?YES:NO;
        _value = [param objectForKey:_property];
        [_params appendFormat:@"%@ %@%@",_property,_value,endFlag?@"":@","];
        
    }
    NSString *_sql = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)",tableName,_params];
    if (self.printSQL) {
        NSLog(@"create table :%@",_sql);
    }
    BOOL result = [db executeUpdate:_sql];
    return result;
}

//查询（tableName）库中是否存在符合 条件为(where) 的记录
-(BOOL)isExistsRecordInDatabase:(FMDatabase *)db withTable:(NSString *)tableName where:(NSString *)where params:(NSDictionary *)params
{
    NSInteger _count = [self numberOfCountRecordsInDatabase:db withTable:tableName where:where params:params];
    BOOL exists = _count < 1 ? NO : YES;
    return exists;
}

//查询库中有多少条符合条件的记录，where eg: userName = '张三'
-(NSInteger)numberOfCountRecordsInDatabase:(FMDatabase *)db withTable:(NSString *)tableName where:(NSString *)where params:(NSDictionary *)params
{
    if (!tableName || !db) {
        return 0;
    }
    NSInteger numOfCount = 0;
    FMResultSet *result = [self selectRecordsInDatabase:db withTable:tableName where:where params:params];
    if (result) {
        int _count = 0;
        while ([result next]) {
            _count ++;
        }
        numOfCount = _count;
    }
    return numOfCount;
}

-(FMResultSet *)selectRecordsInDatabase:(FMDatabase *)db withTable:(NSString *)tableName where:(NSString *)wheres params:(NSDictionary *)params
{
    if (!tableName || !db) {
        return nil ;
    }
    NSString *_sql = nil;
    NSMutableDictionary *_queryParams = nil;
    if (wheres) {
        _sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@",tableName,wheres];
        if (params) {
            _queryParams = [NSMutableDictionary dictionary];
            NSArray *_tmpParams = [wheres componentsMatchedByRegex:@"(\\w+)\\s?(?=<=|=|>=|<|>)(?=\\s??\\s?)"];
            id _tmpValue = nil;
            for (NSString *_tmpItem in _tmpParams) {
                _tmpValue = [params objectForKey:_tmpItem];
                [_queryParams ql_setObject:_tmpValue forKey:_tmpItem];
            }
        }
    }else{
        _sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    }
    FMResultSet *result = [db executeQuery:_sql withParameterDictionary:_queryParams];
    if (result == nil) {
        NSLog(@"query error:%@ with sql:%@",[db lastErrorMessage],_sql);
    }
    
    return result;
}

-(id)selectRecodrdInDatabase:(FMDatabase *)db withTable:(NSString *)tableName where:(NSString *)where propertyName:(NSString *)propertyName params:(NSDictionary *)params
{
    if (!db) {
        return nil;
    }
    FMResultSet *result = [self selectRecordsInDatabase:db withTable:tableName where:where params:params];
    id _value = nil;
    if (result) {
        if ([result next]) {
            if (![result columnIsNull:propertyName]) {
                _value = [result objectForColumnName:propertyName];
            }
        }
    }
    return _value;
}

- (BOOL)insert:(NSArray *)datas inTable:(NSString *)table withRows:(NSArray<NSString *>*)rows inDatabase:(FMDatabase *)db{
    if (datas == nil || [datas count] < 1 || table == nil || db == nil) {
        return NO;
    }
    NSMutableString *params = [NSMutableString string];
    NSMutableString *values = [NSMutableString string];
    
    if (rows == nil) {
        NSMutableArray<NSString *> *tmpRows = [NSMutableArray array];
        id item = [datas firstObject];
        NSDictionary *info = [item ql_toDictionary:item];
        [tmpRows addObjectsFromArray:[info allKeys]];
        if([tmpRows containsObject:@"_id"]){
            [tmpRows removeObject:@"_id"];
        }
        rows = [tmpRows copy];
    }
    for (NSInteger idx = 0; idx < [rows count]; ++idx) {
        NSString *rowName = [rows objectAtIndex:idx];
        [params appendString:rowName];
        if (idx < [rows count] - 1) {
            [params appendString:@","];
        }
    }
    
    [db beginTransaction];
    
    @try {
        for (id item in datas) {
            NSDictionary *info = [item ql_toDictionary:item];
            for (NSInteger idx = 0;idx < [rows count] ; ++ idx) {
                NSString *row = [rows objectAtIndex:idx];
                id value = [info valueForKey:row];
                if (value) {
                    [values appendString:[NSString stringWithFormat:@"%@",value]];
                }else{
                    [values appendString:@""];
                }
                if (idx < [rows count] - 1) {
                    [values appendString:@","];
                }
            }
            NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@);",table,params,values];
            [db executeUpdate:sql];
        }
    } @catch (NSException *exception) {
        [db rollback];
        NSLog(@"%@",exception);
    } @finally {
        [db commit];
    }
    
    return YES;
}

-(BOOL)recordDataToDatabase:(FMDatabase *)db withTable:(NSString *)tableName where:(NSString *)where newValues:(NSDictionary *)params
{
    if (tableName == nil || params == nil || !db) {
        return NO;
    }
    long _id = (long)[params ql_longForKey:@"_id"];
    BOOL existID = _id > 0;
    if (existID && where == nil) {
        where = [NSString stringWithFormat:@"_id=%li",_id];
    }
    BOOL existRecord = where == nil ?NO:[self isExistsRecordInDatabase:db withTable:tableName where:where params:params];
    BOOL operationResult = NO;
    NSString *_sql = nil;
    
    if (existRecord) {
        //执行更新操作
        NSMutableString *_params = [NSMutableString string];
        NSArray *_keys = [params allKeys];
        NSMutableArray *_valueList = [NSMutableArray array];
        int _idx = 0;
        NSInteger _count = [_keys containsObject:@"_id"]?_keys.count - 1: _keys.count;
        id _val = nil;
        for (NSString * key in _keys) {
            if ([key isEqualToString:@"_id"]) {
                continue;
            }
            if (_idx == (_count -1)) {
                [_params appendFormat:@"'%@' = ?",key];
            }else{
                [_params appendFormat:@"'%@' = ?,",key];
            }
            _val = [params objectForKey:key];
            [_valueList addObject:_val];
            _idx ++;
        }
        _sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",tableName,_params,where];
        if (self.printSQL) {
            NSLog(@"%@",_sql);
        }
        operationResult = [db executeUpdate:_sql withArgumentsInArray:_valueList];
    }else{
        //执行插入操作
        NSArray *_propertyArray = [params allKeys];
        NSMutableArray *_valueParamList = [NSMutableArray array];
        NSMutableString *_propertyList = [NSMutableString string];
        NSMutableString *_valueList = [NSMutableString string];
        NSString *_tmpDicKey = nil;
        NSString *_tmpDicValue = nil;
        NSInteger count = [_propertyArray count];
        for (int idx = 0; idx < count; ++idx) {
            _tmpDicKey = [_propertyArray objectAtIndex:idx];
            _tmpDicValue = [params objectForKey:_tmpDicKey];
            if([_tmpDicKey isEqualToString:@"_id"])
                continue;
            [_propertyList appendFormat:@"%@%@",_tmpDicKey,(idx == count - 1 ?@"":@",")];
            [_valueList appendFormat:@"%@%@",@"?",(idx == count - 1 ?@"":@",")];
            [_valueParamList addObject:_tmpDicValue];
        }
        _sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",tableName,_propertyList,_valueList];
        if (self.printSQL) {
            NSLog(@"%@",_sql);
        }
        operationResult= [db executeUpdate:_sql withArgumentsInArray:_valueParamList];
    }
    return operationResult;
}

//删除记录
-(BOOL)removeRecordsInDatabase:(FMDatabase *)db Table:(NSString *)tableName where:(NSString *)where params:(NSDictionary *)params
{
    BOOL operationResult = NO;
    if (tableName == nil || where == nil) {
        return operationResult;
    }
    
    NSString *_sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ ",tableName,where];
    operationResult = [db executeUpdate:_sql];
    return operationResult;
}

//清除表数据
-(BOOL)cleanTable:(NSString *)tableName inDatabase:(FMDatabase *)db
{
    if (!tableName || !db) {
        return NO;
    }
    NSString *_sql = [NSString stringWithFormat:@"DELETE FROM %@ ",tableName];
    BOOL result = [db executeUpdate:_sql];
    return result;
}

//使用自定义SQL条件语句查询数据
-(FMResultSet*)selectDataInDataBase:(FMDatabase *)db withTable:(NSString *)table withwhere:(NSString*)condiction withValueList:(NSArray *)values
{
    FMResultSet *result = nil;
    if (!table || !condiction ||!db) {
        return nil;
    }
    result = [db executeQuery:condiction withArgumentsInArray:values];
    return result;
}

@end
