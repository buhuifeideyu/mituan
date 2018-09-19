//
//  NSDictionary+QL.h
//  QLKit
//
//  Created by JiYung Siu
//  Copyright (c) 2013年 3gtv.net. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

@interface NSDictionary (QL)

+(NSDictionary*)initFromJSONObject:(NSString *)json;

- (NSString *)ql_stringForKey:(id)key;

- (int)ql_intForKey:(id)key;

- (NSInteger)ql_integerForKey:(id)key;

- (float)ql_floatForKey:(id)key;

- (BOOL)ql_boolForKey:(id)key;

- (long)ql_longForKey:(id)key;

- (NSDate*)ql_dateForKey:(id)key;

- (BOOL)ql_hasObjectForKey:(id)key;

- (BOOL)ql_validate;

- (BOOL)ql_validateArrayForKey:(id)key;

- (BOOL)ql_validateDictionaryForKey:(id)key;

@end
