//
//  NSObject+QL.h
//  QLFramework
//
//  Created by Zhiyong Xiao on 14/12/19.
//  Copyright (c) 2014年 SiuJiYung. All rights reserved.
//

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

@interface NSObject (QL)

/**
 *  从Dictionary构建一个实例
 *
 *  @param dic
 *
 *  @return
 */
+ (instancetype)fromDictionary:(NSDictionary *)dic;

/**
 *  从Array数组构建多个实例
 *
 *  @param list
 *
 *  @return
 */
+ (NSArray *)fromArray:(NSArray *)list;

/**
 *  从json初始化一组实例
 *
 *  @param json json字符串
 *  @param name 字典关键字（允许为空）；如果json字符串本身是一个Json数组，则name允许为空；否则需要指定json数组名称。
 *
 *  @return
 */
+ (NSArray *)fromJson:(NSString *)json arrayName:(NSString *)name;

/**
 *  从json初始化一个实例
 *
 *  @param json json 字符串
 *  @param name 字典关键字（允许为空）；如果json就是该对象的object对象，则允许name为空;否则需要指定该对象对应的json名称。
 *
 * 例如：1、{"key1":"v1","key2":"v2"},则无需指定name
 * {"key":{"key1":"v1","key2":"v2"}},则需要指定name为key.
 *
 *  @return
 */
+ (instancetype)fromJson:(NSString *)json name:(NSString *)name;

- (void)initWithDictionary:(NSDictionary *)info;

- (NSString *)toJsonString;

- (NSDictionary *) ql_toDictionary:(id)obj;

@end