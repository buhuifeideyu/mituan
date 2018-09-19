//
//  RJSignStoryIdSimple.h
//  Rice
//
//  Created by 李永 on 2018/9/13.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RJSignStoryIdSimple : NSObject

+(instancetype)manager;
@property (nonatomic, copy) NSString *storyID;
@property (nonatomic, assign) NSInteger isFirstClickedListPlayer;//第一次点击列表播放

@end
