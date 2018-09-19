//
//  PathHelper.m
//  DailyLesson
//
//  Created by 李永 on 2018/6/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "PathHelper.h"

@implementation PathHelper

+ (NSString *)getDocumentDirPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)getTempDirPath{
    return [NSString stringWithFormat:@"%@/tmp/",NSTemporaryDirectory()];
}

+ (NSString *)getCachDirPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

@end
