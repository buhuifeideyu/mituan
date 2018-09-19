//
//  YYLableTextHelper.m
//  YYFramework
//
//  Created by 李永 on 2017/6/9.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import "YYLableTextHelper.h"

@implementation YYLableTextHelper

+ (NSMutableAttributedString *)setLableTextWithString:(NSString *)string strFirstRange:(NSRange)firstRange  andSecondRange:(NSRange)secondRange andThirdRange:(NSRange)thirdRange  firstRangeColor:(UIColor *)firstRangeColor andSecondRangeColor:(UIColor *)secondRangeColor andThirdRangeColor:(UIColor *)thirdRangeColor  firstRangeFontSize:(CGFloat)firstRangeFontSize andSecondRangeFontSize:(CGFloat)secondRangeFontSize andThirdRangeFontSize:(CGFloat)thirdRangeFontSize {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:firstRangeColor range:firstRange];
    [str addAttribute:NSForegroundColorAttributeName value:secondRangeColor range:secondRange];
    [str addAttribute:NSForegroundColorAttributeName value:thirdRangeColor range:thirdRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:firstRangeFontSize] range:firstRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:secondRangeFontSize] range:secondRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:thirdRangeFontSize] range:thirdRange];
    return str;
}

+ (NSMutableAttributedString *)setLableTextWithString:(NSString *)string strFirstRange:(NSRange)firstRange andSecondRange:(NSRange)secondRange firstRangeColor:(UIColor *)firstRangeColor andSecondRangeColor:(UIColor *)secondRangeColor firstRangeFontSize:(CGFloat)firstRangeFontSize andSecondRangeFontSize:(CGFloat)secondRangeFontSize {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:firstRangeColor range:firstRange];
    [str addAttribute:NSForegroundColorAttributeName value:secondRangeColor range:secondRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:firstRangeFontSize] range:firstRange];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:secondRangeFontSize] range:secondRange];
    return str;
}

+ (NSMutableAttributedString *)setLableTextWithString:(NSString *)string strFirstRange:(NSRange)firstRange andSecondRange:(NSRange)secondRange andThirdRange:(NSRange)thirdRange {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:secondRange];
    return str;
}

@end
