//
//  NSObject+QL.m
//  QLFramework
//
//  Created by Zhiyong Xiao on 14/12/19.
//  Copyright (c) 2014年 SiuJiYung. All rights reserved.
//

#import "NSObject+QL.h"
#import "JSONKit.h"

@implementation NSObject (QL)

+ (instancetype)fromDictionary:(NSDictionary *)dic{
    if(dic == nil && [dic isKindOfClass:[NSDictionary class]] && ((NSDictionary *)dic).count > 0)
        return nil;
    id instance = [[self class] new];
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id v = [dic valueForKey:key];
        if(v != nil && v != [NSNull null]){
            @try {
                [instance setValue:v forKey:key];
            }
            @catch (NSException *exception) {
                NSLog(@"parse data error when init value from NSDictionary with key :%@ ,des:%@",key,exception.reason);
            }
            @finally {}
        }
    }
    free(properties);
    return instance;
}

+ (NSArray *)fromArray:(NSArray *)list{
    if (list == nil) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in list) {
        id _instance = [self fromDictionary:dic];
        if (_instance) {
            [array addObject:_instance];
        }
    }
    return array;
}

+ (NSArray *)fromJson:(NSString *)json arrayName:(NSString *)name{
    if (json == nil) {
        return nil;
    }
    NSArray *src_array = nil;
    id tmp = [json objectFromJSONString];
    if (name == nil && [tmp isKindOfClass:[NSArray class]]) {
        src_array = [json objectFromJSONString];
    }else if (name != nil && [tmp isKindOfClass:[NSDictionary class]]){
        id tmpv = [tmp valueForKey:name];
        if (tmpv != nil && [tmpv isKindOfClass:[NSArray class]]) {
            src_array = tmpv;
        }
    }
    
    NSMutableArray *array = [NSMutableArray array];
    if (src_array != nil) {
        for (NSDictionary *_info in src_array) {
            id _instance = [self fromDictionary:_info];
            [array addObject:_instance];
        }
    }
    return array;
}

+ (instancetype)fromJson:(NSString *)json name:(NSString *)name{
    if (json == nil) {
        return nil;
    }
    id tmp = [json objectFromJSONString];
    if (name == nil && [tmp isKindOfClass:[NSDictionary class]]) {
        return  [self fromDictionary:tmp];
    }else if (name != nil && [tmp isKindOfClass:[NSDictionary class]]){
        id tmp2 = [tmp valueForKey:name];
        if (tmp2 != nil && [tmp2 isKindOfClass:[NSDictionary class]]) {
            return [self fromDictionary:(NSDictionary *)tmp2];
        }
    }
    return nil;
}



- (void)initWithDictionary:(NSDictionary *)info{
    if(info == nil && [info isKindOfClass:[NSDictionary class]] && ((NSDictionary *)info).count > 0)
        return;
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
//                id v = [info objectForKey:key];
        id v;
        if ([key isEqualToString:@"descriptions"]) {
            v = [info valueForKey:@"description"];
        }else {
            v = [info valueForKey:key];
        }
        if(v != nil && v != [NSNull null]){
            @try {
                [self setValue:v forKey:key];
            }
            @catch (NSException *exception) {
                NSLog(@"parse data error when init value from NSDictionary with key :%@ ,des:%@",key,exception.reason);
            }
            @finally {}
        }
    }
    free(properties);
}

-(NSString *)toJsonString{
    NSDictionary *dict = [self ql_toDictionary:self];
//    return [dict JSONString];
    
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


- (NSDictionary *) ql_toDictionary:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        if ([obj valueForKey:key] != nil) {
            [dict setObject:[obj valueForKey:key] forKey:key];
        }
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}
@end
