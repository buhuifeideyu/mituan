//
//  HttpResponData.h
//  金华佗医生版
//
//  Created by Sim on 15/7/21.
//  Copyright (c) 2015年 SiuJiYung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLNetworkResponse.h"

@interface HttpResponData : NSObject

@property (nonatomic,assign) int code;

@property (nonatomic,assign) BOOL success;

@property (nonatomic,copy) NSString *msg;

@property (nonatomic,copy) NSString *token;

@property (nonatomic,strong) id otherInfo;

@property (nonatomic,copy) NSString *errorMsg;

@property (nonatomic,copy) NSString *result;


+ (instancetype)parseNetworkResponse:(QLNetworkResponse *)response;

+ (instancetype)parseNetworkResponseDictionary:(NSDictionary *)response;

- (id)parseName:(NSString *)name to:(Class)clz;

@end
