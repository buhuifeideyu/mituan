//
//  UIView+titleView.h
//  WeiPai
//
//  Created by XiaoBai on 15/8/8.
//  Copyright (c) 2015年 XiaoBai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (titleView)

+ (id)titleViewWithTitle:(NSString *)text font:(NSInteger)size textColor:(UIColor *)color;

+ (id)titleViewWithTitle:(NSString *)text font:(NSInteger)size textColor:(UIColor *)color andImage:(NSString *)imageName;

@end
