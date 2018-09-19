//
//  UIColor+QL.h
//  LPBaby
//
//  Created by Sim on 15/7/8.
//  Copyright (c) 2015年 xiaoming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QL)

+(UIColor *)ql_colorWithHex:(NSString *)hexColor;

+(UIColor *)ql_colorWithHex:(NSString *)hexColor alpha:(CGFloat)alpha;
@end
