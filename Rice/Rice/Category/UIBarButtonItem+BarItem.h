//
//  UIBarButtonItem+BarItem.h
//  WeiPai
//
//  Created by XiaoBai on 15/8/9.
//  Copyright (c) 2015年 XiaoBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BarItem)

+ (instancetype)barButtonItemWithImageName:(NSString *)imageName addTarget:(id)target action:(SEL)action;

/**
 *  左边图片，右边文字
 */
+ (instancetype)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)color textFont:(CGFloat)font image:(UIImage *)image addTarget:(id)target action:(SEL)action;

/**
 *  左边图片，右边文字
 */
+ (instancetype)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)color textFont:(CGFloat)font image:(UIImage *)image addTarget:(id)target action:(SEL)action maxWidth:(CGFloat)maxWidth;

/**
 *  纯文字
 */
+ (instancetype)barButtonItemWithText:(NSString *)text titleColor:(UIColor *)color textFont:(CGFloat)font addTarget:(id)target action:(SEL)action;

+ (instancetype)rightBarButtonItemWithImageName:(NSString *)imgName  addTarget:(id)target action:(SEL)action;

/**
 *  图片+小图片
 */
+ (instancetype)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)color textFont:(CGFloat)font image:(UIImage *)image addTarget:(id)target action:(SEL)action andSmallImage:(NSString *)imageName;

@end
