//
//  NSString+QL.h
//  YYFramework
//
//  Created by dyj on 16/5/23.
//  Copyright © 2016年 YueYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QL)

- (CGSize)ql_fontSizeWithFont:(UIFont *)font andMaxWidth:(CGFloat)width;
/**
 *  计算字符串占用size
 *
 *  @param fontSize 字体大小
 *  @param maxWidth 最大宽度
 *
 *  @return
 */
-(CGSize)ql_fontSize:(int)fontSize maxWidth:(CGFloat)maxWidth;


/**
 *  计算字符串占用size
 *
 *  @param fontSize  字体大小
 *  @param maxHeight 最大高度
 *
 *  @return
 */
-(CGSize)ql_fontSize:(int)fontSize maxHeight:(CGFloat)maxHeight;

- (CGSize)ql_fontSizeWithFont:(UIFont *)font andMaxHeight:(CGFloat)maxHeight;

-(BOOL)ql_isValidateEmailAddr;

+ (BOOL)ql_isEmpty:(NSString *)str;

- (BOOL)isValidUrl:(NSString *)string;

- (BOOL)ql_mactch:(NSString *)exp;


@end
