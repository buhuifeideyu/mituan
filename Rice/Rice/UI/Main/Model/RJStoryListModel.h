//
//  RJStoryListModel.h
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <Foundation/Foundation.h>
//"id": 4,
//"title": "专栏4",
//"summary": "专栏4",
//"description": "<p>专栏4</p>",
//"thumb": "/uploads/upload/20180914/061b2448b6cc23105982a4873ebaab17.png",
//"add_time": 1536747142,
//"recommend": 0,
//"recommend_time": 0,
//"style": 4,
//"show_num": 2,
//"storyList": []

@interface RJStoryListModel : NSObject

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *summary;

@property (nonatomic,copy) NSString *descriptions;

@property (nonatomic,copy) NSString *thumb;

@property (nonatomic,copy) NSString *add_time;

@property (nonatomic,copy) NSString *recommend;

@property (nonatomic,copy) NSString *recommend_time;

@property (nonatomic,copy) NSString *style;

@property (nonatomic,copy) NSString *show_num;

@property (nonatomic,strong) NSArray *storyList;

@property (nonatomic,assign) NSInteger id;

@end
