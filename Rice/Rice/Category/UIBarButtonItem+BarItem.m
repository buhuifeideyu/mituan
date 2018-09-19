//
//  UIBarButtonItem+BarItem.m
//  WeiPai
//
//  Created by XiaoBai on 15/8/9.
//  Copyright (c) 2015年 XiaoBai. All rights reserved.
//

#import "UIBarButtonItem+BarItem.h"

@implementation UIBarButtonItem (BarItem)

+ (instancetype)barButtonItemWithImageName:(NSString *)imageName addTarget:(id)target action:(SEL)action
{
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:imageName] style:UIBarButtonItemStylePlain target:target action:action];
    item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [item setTintColor:[UIColor whiteColor]];
    return item;
}

/**
 *  左边图片，右边文字
 */
+ (instancetype)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)color textFont:(CGFloat)font image:(UIImage *)image addTarget:(id)target action:(SEL)action {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setImage:image forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn.titleLabel sizeToFit];
    btn.frame = CGRectMake(0, 0, image.size.width + btn.titleLabel.width, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (instancetype)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)color textFont:(CGFloat)font image:(UIImage *)image addTarget:(id)target action:(SEL)action maxWidth:(CGFloat)maxWidth{
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setImage:image forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn.titleLabel sizeToFit];
    
    CGFloat btn_width = image.size.width + btn.titleLabel.width;
    btn_width = btn_width > maxWidth?maxWidth:btn_width;
    btn.frame = CGRectMake(0, 0, btn_width, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

/**
 *  图片+小图片
 */
+ (instancetype)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)color textFont:(CGFloat)font image:(UIImage *)image addTarget:(id)target action:(SEL)action andSmallImage:(NSString *)imageName{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn setImage:image forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [btn.titleLabel sizeToFit];
    btn.frame = CGRectMake(0, 0, image.size.width + btn.titleLabel.width, 44);
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    imageView.center = CGPointMake(CGRectGetMaxX(btn.frame) - 5, CGRectGetMinY(btn.frame) + 5);
    imageView.image = [UIImage imageNamed:imageName];
    imageView.tag = 111;
    [btn addSubview:imageView];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

/**
 *  纯文字
 */
+ (instancetype)barButtonItemWithText:(NSString *)text titleColor:(UIColor *)color textFont:(CGFloat)font addTarget:(id)target action:(SEL)action
{
    
    //    UILabel *textLabel = text;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [text length] * 22, 44)];
    [btn setTitle:text forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}

+ (instancetype)rightBarButtonItemWithImageName:(NSString *)imgName  addTarget:(id)target action:(SEL)action
{
    
    UIImage *img = [UIImage imageNamed:imgName];
    //    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, img.size.width, img.size.height);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    return item;
}
@end
