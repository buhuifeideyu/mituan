//
//  RJMessageModel.h
//  Rice
//
//  Created by 李永 on 2018/9/7.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RJMessageModel : NSObject

@property (nonatomic,assign) NSInteger id;//id

@property (nonatomic,copy) NSString *type;//消息类型(0:系统,1:个人,2:家庭)

@property (nonatomic,copy) NSString *title;//标题

@property (nonatomic,copy) NSString *summary;//简介

@property (nonatomic,copy) NSString *content;//内容

@property (nonatomic,assign) NSInteger add_time;//添加时间

@property (nonatomic,copy) NSString *user_id;//发送对象,空0则为所有人

@property (nonatomic,copy) NSString *url;//关联URL

@property (nonatomic,copy) NSString *status;//状态(1:已读,2:删除,其他为未读)

@property (nonatomic,copy) NSString *content_url;//内容URL

@end
