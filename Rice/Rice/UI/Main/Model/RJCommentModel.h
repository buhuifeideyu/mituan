//
//  RJCommentModel.h
//  Rice
//
//  Created by 李永 on 2018/9/14.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <Foundation/Foundation.h>
//"id": 12,
//"type": 0,
//"user_id": 2,
//"album_id": 0,
//"story_id": 1,
//"add_time": 1536559536,
//"content": "吐痰",
//"album_title": "",
//"title": "故事1111"

@interface RJCommentModel : NSObject

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *user_id;

@property (nonatomic,copy) NSString *album_id;

@property (nonatomic,copy) NSString *story_id;

@property (nonatomic,copy) NSString *add_time;

@property (nonatomic,copy) NSString *content;

@property (nonatomic,copy) NSString *album_title;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,copy) NSString *thumb;


@end
