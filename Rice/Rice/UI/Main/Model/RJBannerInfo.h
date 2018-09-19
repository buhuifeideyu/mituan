//
//  RJBannerInfo.h
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RJBannerInfo : NSObject

@property (nonatomic,assign) NSInteger id;

@property (nonatomic,copy) NSString *position;//位置标示

@property (nonatomic,copy) NSString *remark;//位置备注

@property (nonatomic,copy) NSString *pic;//图片

@property (nonatomic,copy) NSString *pic_name;//本地图片

@property (nonatomic,copy) NSString *title;//标题

@property (nonatomic,copy) NSString *link_type;//跳转类型

@property (nonatomic,copy) NSString *link;//跳转信息

@property (nonatomic,copy) NSString *delay;//时长秒,默认0

+(instancetype)createWithImageURL:(NSString *)url title:(NSString *)title andId:(NSInteger)_id;

+(instancetype)createWithName:(NSString *)name title:(NSString *)title andId:(NSInteger)_id;

+(instancetype)createWithName:(NSString *)name;

+(instancetype)createWithImgageURL:(NSString *)url;

@end
