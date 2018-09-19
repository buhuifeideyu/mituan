//
//  NSString+QL.m
//  YYFramework
//
//  Created by dyj on 16/5/23.
//  Copyright © 2016年 YueYun. All rights reserved.
//

#import "NSString+QL.h"

@implementation NSString (QL)

- (CGSize)ql_fontSizeWithFont:(UIFont *)font andMaxWidth:(CGFloat)width{
    CGSize maxSize =  CGSizeMake(width, MAXFLOAT);
    CGSize textSize = [self boundingRectWithSize:maxSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil].size;
    return textSize;
}

-(CGSize)ql_fontSize:(int)fontSize maxWidth:(CGFloat)maxWidth{
    UIFont *textFont = [UIFont systemFontOfSize:fontSize];
    CGSize maxSize =  CGSizeMake(maxWidth, MAXFLOAT);
    CGSize textSize = [self boundingRectWithSize:maxSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:textFont}
                                         context:nil].size;
    return textSize;
    
}

-(CGSize)ql_fontSize:(int)fontSize maxHeight:(CGFloat)maxHeight{
    UIFont *textFont = [UIFont systemFontOfSize:fontSize];
    CGSize maxSize =  CGSizeMake(MAXFLOAT, maxHeight);
    CGSize textSize = [self boundingRectWithSize:maxSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:textFont}
                                         context:nil].size;
    return textSize;
}

- (CGSize)ql_fontSizeWithFont:(UIFont *)font andMaxHeight:(CGFloat)maxHeight{
    CGSize maxSize = CGSizeMake(MAXFLOAT, maxHeight);
    CGSize textSize = [self boundingRectWithSize:maxSize
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil].size;
    return textSize;
}


- (BOOL)ql_mactch:(NSString *)exp{
    BOOL mactch = NO;
    
    NSError *error;
    NSRegularExpression *regularExp = [NSRegularExpression regularExpressionWithPattern:exp options:0 error:&error];
    if (!error) {
        NSRange searchRange = NSMakeRange(0, self.length);
        NSTextCheckingResult *textCheckResult = [regularExp firstMatchInString:self options:0 range:searchRange];
        mactch = textCheckResult && textCheckResult.range.length > 0;
    }
    
    return mactch;
}

- (BOOL)isTelephoneNumber{
    if ([self length] >= 11) {
        return YES;
    }
    return NO;
}

+ (BOOL)ql_isEmpty:(NSString *)str{
    return str == nil||[@"" isEqualToString:str];
}

/*邮箱验证
 MODIFIED BY HELENSONG*/
-(BOOL)ql_isValidateEmailAddr{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    
    return[emailTest evaluateWithObject:self];
    
}

//思路:传入一个请求的URL,进行网络请求,如果返回失败信息则说明此URL不可用
//1.首先进行第一步判断传入的字符串是否符合HTTP路径的语法规则,即”HTTPS://” 或 “HTTP://”
- (BOOL)isValidUrl:(NSString *)string{
    
    NSString *regex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([pred evaluateWithObject:string]) {
        NSString  *regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        return [self ql_mactch:regulaStr];
    }else {
        return NO;
    }
    
}

@end
