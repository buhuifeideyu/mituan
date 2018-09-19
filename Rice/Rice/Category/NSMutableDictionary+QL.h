//
//  NSMutableDictionary+QL.h
//  QLKit
//
//  Created by Sim on 13-4-18.
//  Copyright (c) 2013年 3gtv.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (QL)

-(void)ql_setBoolean:(BOOL)boolValue forKey:(id<NSCopying>)key;
-(void)ql_setObject:(id)obj forKey:(id<NSCopying>)key;
-(void)ql_setInterge:(NSInteger)intNum forKey:(id<NSCopying>)key;
-(void)ql_setFloat:(float)floatNum forKey:(id<NSCopying>)key;
-(void)ql_setLong:(long)longNum forKey:(id<NSCopying>)key;
-(void)ql_setDate:(NSDate *)date forKey:(id<NSCopying>)key;
@end
