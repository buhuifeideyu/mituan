//
//  RJBannerInfo.m
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJBannerInfo.h"

@implementation RJBannerInfo

+(instancetype)createWithImageURL:(NSString *)url title:(NSString *)title andId:(NSInteger)_id{
    RJBannerInfo *info = [[RJBannerInfo alloc] init];
    info.pic= url;
    info.title = title;
    info.id = _id;
    return info;
}

+(instancetype)createWithName:(NSString *)name title:(NSString *)title andId:(NSInteger)_id{
    RJBannerInfo *info = [[RJBannerInfo alloc] init];
    info.pic_name = name;
    info.title = title;
    info.id = _id;
    return info;
}

+(instancetype)createWithName:(NSString *)name{
    return [self createWithName:name title:nil andId:0];
}

+(instancetype)createWithImgageURL:(NSString *)url{
    return [self createWithImageURL:url title:nil andId:0];
}

@end
