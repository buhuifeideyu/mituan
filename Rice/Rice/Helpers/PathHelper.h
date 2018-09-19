//
//  PathHelper.h
//  DailyLesson
//
//  Created by 李永 on 2018/6/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathHelper : NSObject

/*
 *获取用户文档目录
 */
+ (NSString *)getDocumentDirPath;

/**
 *获取临时文件夹
 */
+ (NSString *)getTempDirPath;

/**
 *获取缓存文件夹
 */
+ (NSString *)getCachDirPath;

@end
