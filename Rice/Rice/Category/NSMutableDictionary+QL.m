//
//  NSMutableDictionary+QL.m
//  QLKit
//
//  Created by Sim on 13-4-18.
//  Copyright (c) 2013年 3gtv.net. All rights reserved.
//

#import "NSMutableDictionary+QL.h"

@implementation NSMutableDictionary (QL)

-(void)ql_setObject:(id)obj forKey:(id<NSCopying>)key
{
    if (obj == nil) {
        return;
    }
    [self setObject:obj forKey:key];
}

-(void)ql_setInterge:(NSInteger)intNum forKey:(id<NSCopying>)key
{
    id num = [NSNumber numberWithInteger:intNum];
    [self setObject:num forKey:key];
}


-(void)ql_setBoolean:(BOOL)boolValue forKey:(id<NSCopying>)key
{
    id num = [NSNumber numberWithBool:boolValue];
    [self setObject:num forKey:key];
}

-(void)ql_setFloat:(float)floatNum forKey:(id<NSCopying>)key
{
    id num = [NSNumber numberWithFloat:floatNum];
    [self setObject:num forKey:key];
}

-(void)ql_setLong:(long)longNum forKey:(id<NSCopying>)key
{
    id num = [NSNumber numberWithLong:longNum];
    [self setObject:num forKey:key];
}

-(void)ql_setDate:(NSDate *)date forKey:(id<NSCopying>)key
{
    if (!date) {
        return;
    }
    NSDateFormatter *_formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dtstr = [_formatter stringFromDate:date];
    if (dtstr) {
        [self setObject:dtstr forKey:key];
    }
}
@end
