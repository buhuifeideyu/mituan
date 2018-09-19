//
//  HttpResponData.m
//  金华佗医生版
//
//  Created by Sim on 15/7/21.
//  Copyright (c) 2015年 SiuJiYung. All rights reserved.
//

#import "HttpResponData.h"
#import "NSDictionary+QL.h"

@implementation HttpResponData

- (void)initWithDictionary:(NSDictionary *)info{
//    [super initWithDictionary:info];
    if (info == nil || info.count < 1) {
        return;
    }
    self.code = [info ql_intForKey:@"wp_error_code"];
    self.msg = [info ql_stringForKey:@"wp_error_msg"];
    self.success = [info ql_boolForKey:@"success"];
    self.token = [info ql_stringForKey:@"token"];
    self.errorMsg = [info ql_stringForKey:@"error"];
    self.result = [info ql_stringForKey:@"result"];
    self.otherInfo = info;
}

+ (instancetype)parseNetworkResponse:(QLNetworkResponse *)response{
    if (response == nil) {
        return nil;
    }
    return [self parseNetworkResponseDictionary:response.responseObject];
}

+ (instancetype)parseNetworkResponseDictionary:(NSDictionary *)response{
    if (response == nil || ![response isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    HttpResponData *_data = [[HttpResponData alloc] init];
    [_data initWithDictionary:response];
    return _data;
}
@end
