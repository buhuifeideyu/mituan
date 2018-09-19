//
//  QLNetworkResponse.h
//  TianYueMobileOA
//
//  Created by SiuJiYung on 14-1-23.
//  Copyright (c) 2014年 tianyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLNetworkResponse : NSObject

@property (nonatomic,strong) NSString *baseURL;
@property (nonatomic,strong) NSString *responseString;
@property (nonatomic,strong) NSData *responseData;
@property (nonatomic,assign) int statusCode;
@property (nonatomic,assign) BOOL isCache;
@property (nonatomic,strong) NSString *cacheKey;
@property (nonatomic,assign) NSTimeInterval cacheCreateTime;
@property (nonatomic,assign) NSTimeInterval cacheInvalebleTime;
@property (nonatomic,assign) id responseObject;

@end
