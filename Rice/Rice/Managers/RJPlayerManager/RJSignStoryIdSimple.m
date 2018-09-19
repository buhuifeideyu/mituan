//
//  RJSignStoryIdSimple.m
//  Rice
//
//  Created by 李永 on 2018/9/13.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJSignStoryIdSimple.h"

@implementation RJSignStoryIdSimple

+(instancetype)manager{
    static RJSignStoryIdSimple *storyID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        storyID = [[RJSignStoryIdSimple alloc] init];
    });
    return storyID;
}

@end
