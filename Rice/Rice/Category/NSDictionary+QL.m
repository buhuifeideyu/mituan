//
//  NSDictionary+QL.m
//  QLKit
//
//  Created by JiYung Siu
//  Copyright (c) 2013年 3gtv.net. All rights reserved.
//

#import "NSDictionary+QL.h"

@implementation NSDictionary (QL)

+(NSDictionary*)initFromJSONObject:(NSString *)json
{
    Class JSONSerialization = NSClassFromString(@"NSJSONSerialization");
    if (JSONSerialization) {
        NSError *error = nil;
        id object = [JSONSerialization
                     JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                     options:NSJSONReadingAllowFragments
                     error:&error];
        
        if (error) {
            return nil;
        }
        if ([object isKindOfClass:[NSDictionary class]]) {
            return (NSDictionary*)object;
        }
    }
    return nil;
}

- (NSString *)ql_stringForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [object isEqual:[NSNull null]]) {
        return nil;
    }
    if ([object isKindOfClass:[NSNumber class]]) {
        return [object stringValue];
    }
    return object;
}


- (int)ql_intForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [object isEqual:[NSNull null]] ) {
        return -999;
    }
    return [object intValue];
}

- (NSInteger)ql_integerForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [object isEqual:[NSNull null]] ) {
        return -999;
    }
    return [object integerValue];
}

- (float)ql_floatForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [object isEqual:[NSNull null]]) {
        return -999;
    }
    return [object floatValue];
}

- (BOOL)ql_boolForKey:(id)key {
    id object = [self objectForKey:key];
    if (object == nil || [object isEqual:[NSNull null]]) {
        return NO;
    }else if ([object integerValue] == -1) {
        return NO;
    }
    return [object boolValue];
}

- (long)ql_longForKey:(id)key
{
    id object = [self objectForKey:key];
    if (object == nil || [object isEqual:[NSNull null]]) {
        return -999;
    }
    return [object longValue];
}

-(NSDate*)ql_dateForKey:(id)key
{
    if ([self ql_hasObjectForKey:key]) {
        NSString *strobj = [self ql_stringForKey:key];
        if (strobj != nil || ![strobj isEqual:[NSNull null]]) {
            NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
            [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.s"];
            NSDate *_tmpDate = [_formatter dateFromString:strobj];
            if (!_tmpDate) {
                [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                _tmpDate = [_formatter dateFromString:strobj];
            }
            return _tmpDate;
        }
    }
    return nil;
}

- (BOOL)ql_hasObjectForKey:(id)key {
    if ([self objectForKey:key]) {
        return YES;
    }
    return NO;
}

- (BOOL)ql_validate {
    return [[self allKeys] count] > 0 ? YES : NO;
}

- (BOOL)ql_validateArrayForKey:(NSString *)key {
    NSArray *array = [self objectForKey:key];
    return [array count] > 0 ? YES : NO;
}

- (BOOL)ql_validateDictionaryForKey:(NSString *)key {
    NSDictionary *dictionary = [self objectForKey:key];
    return [[dictionary allKeys] count] > 0 ? YES : NO;
}


@end
