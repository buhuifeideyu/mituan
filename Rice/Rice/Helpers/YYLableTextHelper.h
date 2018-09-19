//
//  YYLableTextHelper.h
//  YYFramework
//
//  Created by 李永 on 2017/6/9.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYLableTextHelper : NSObject

+ (NSMutableAttributedString *)setLableTextWithString:(NSString *)string strFirstRange:(NSRange)firstRange andSecondRange:(NSRange)secondRange andThirdRange:(NSRange)thirdRange  firstRangeColor:(UIColor *)firstRangeColor andSecondRangeColor:(UIColor *)secondRangeColor andThirdRangeColor:(UIColor *)thirdRangeColor firstRangeFontSize:(CGFloat)firstRangeFontSize andSecondRangeFontSize:(CGFloat)secondRangeFontSize andThirdRangeFontSize:(CGFloat)thirdRangeFontSize;

+ (NSMutableAttributedString *)setLableTextWithString:(NSString *)string strFirstRange:(NSRange)firstRange andSecondRange:(NSRange)secondRange   firstRangeColor:(UIColor *)firstRangeColor andSecondRangeColor:(UIColor *)secondRangeColor  firstRangeFontSize:(CGFloat)firstRangeFontSize andSecondRangeFontSize:(CGFloat)secondRangeFontSize ;

+ (NSMutableAttributedString *)setLableTextWithString:(NSString *)string strFirstRange:(NSRange)firstRange andSecondRange:(NSRange)secondRange andThirdRange:(NSRange)thirdRange;

@end
