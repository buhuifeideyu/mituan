//
//  RJStoryModel.h
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <Foundation/Foundation.h>

//"id": 2,
//"title": "测试数据",
//"summary": "测试数据测试数据测试数据",
//"label": "标签",
//"likes": 0,
//"comments": 0,
//"views": 0,
//"thumb": "/uploads/upload/20180907/6fdd5a4b880091152be7b6e7ac2768c9.jpeg",
//"url": "/uploads/upload/20180907/e4858011491be9b55b1a7c3049360146.mp3",
//"length": 0,
//"vip": 0,
//"add_time": 1536317056,
//"recommend": 0,
//"recommend_time": 0,
//"try_play": 0,
//"try_play_length": 0,
//"sex_level": 0,
//"story_type": 1,
//"age_min": 0,
//"age_max": 0,
//"type_name": "百科"


@interface RJStoryModel : NSObject

@property (nonatomic,copy) NSString *title;//标题

@property (nonatomic,copy) NSString *summary;//描述

@property (nonatomic,copy) NSString *label;//标签

@property (nonatomic,copy) NSString *likes;//是否喜欢

@property (nonatomic,copy) NSString *descriptions;

@property (nonatomic,assign) NSInteger comments;

@property (nonatomic,copy) NSString *views;

@property (nonatomic,copy) NSString *thumb;

@property (nonatomic,copy) NSString *url;

@property (nonatomic,copy) NSString *length;

@property (nonatomic,copy) NSString *vip;

@property (nonatomic,copy) NSString *add_time;

@property (nonatomic,copy) NSString *recommend;

@property (nonatomic,copy) NSString *recommend_time;

@property (nonatomic,copy) NSString *try_play;

@property (nonatomic,copy) NSString *try_play_length;

@property (nonatomic,copy) NSString *sex_level;

@property (nonatomic,copy) NSString *age_min;

@property (nonatomic,copy) NSString *age_max;

@property (nonatomic,copy) NSString *type_name;

@property (nonatomic,copy) NSString *replace_thumb;

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,assign) NSInteger is_like;

@property (nonatomic,copy) NSString *like_id;

@property (nonatomic,copy) NSString *story_id;

@property (nonatomic,copy) NSString *child_id;

@property (nonatomic,strong) NSString *user_id;

@property (nonatomic,copy) NSString *listen_id;

@property (nonatomic,copy) NSString *num;

@end
