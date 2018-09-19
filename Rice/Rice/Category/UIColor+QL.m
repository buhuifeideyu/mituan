//
//  UIColor+QL.m
//  LPBaby
//
//  Created by Sim on 15/7/8.
//  Copyright (c) 2015年 xiaoming. All rights reserved.
//

#import "UIColor+QL.h"

@implementation UIColor (QL)

// 将16进制颜色值转化为UIColor
+(UIColor *)ql_colorWithHex:(NSString *)hexColor {
    return [UIColor ql_colorWithHex:hexColor alpha:1.0];
}

// 可以设置透明值
+(UIColor *)ql_colorWithHex:(NSString *)hexColor alpha:(CGFloat)alpha {
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f)
                           green:(float)(green/255.0f)
                            blue:(float)(blue/255.0f)
                           alpha:alpha];
}

@end
