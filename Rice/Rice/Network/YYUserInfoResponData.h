//
//  YYUserInfoResponData.h
//  toothbrush
//
//  Created by XiaoBai on 15/11/3.
//  Copyright © 2015年 YueYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYUserInfoResponData : NSObject

@property (assign,nonatomic) int total;

@property (strong,nonatomic) id root;

@property (assign,nonatomic) int wp_error_code;

@property (assign,nonatomic) BOOL success;

@property (strong,nonatomic) NSString *wp_error_msg;

@property (assign,nonatomic) int comment_count;

@property (assign,nonatomic) int support_count;

@end
