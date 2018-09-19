//
//  UIView+titleView.m
//  WeiPai
//
//  Created by XiaoBai on 15/8/8.
//  Copyright (c) 2015年 XiaoBai. All rights reserved.
//

#import "UIView+titleView.h"

@implementation UIView (titleView)

+ (id)titleViewWithTitle:(NSString *)text font:(NSInteger)size textColor:(UIColor *)color
{
    UILabel *lable = [[UILabel alloc] init];
    lable.text = text;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = color;
    
    UIFont *titleFont = [UIFont systemFontOfSize:size];
    
    CGSize maxSize =  CGSizeMake(MAXFLOAT, 44);
    
    CGSize titleSize = [lable.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleFont} context:nil].size;
//    [lable sizeToFit];
    lable.bounds = CGRectMake(0, 0, titleSize.width, titleSize.height);
    lable.font = titleFont;

    
    return lable;
}


+ (id)titleViewWithTitle:(NSString *)text font:(NSInteger)size textColor:(UIColor *)color andImage:(NSString *)imageName
{
    UIView * bgView = [[UIView alloc]init];
    
    UILabel *lable = [[UILabel alloc] init];
    lable.text = text;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = color;
    
    UIFont *titleFont = [UIFont systemFontOfSize:size];
    
    CGSize maxSize =  CGSizeMake(MAXFLOAT, 44);
    
    CGSize titleSize = [lable.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:titleFont} context:nil].size;
    //    [lable sizeToFit];
    
    lable.frame = CGRectMake(0, 0, titleSize.width, 44);
    lable.font = titleFont;
    
    CGFloat imageView_H = 10;
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = CGRectMake(CGRectGetMaxX(lable.frame)+5, (44-imageView_H)/2, imageView_H, imageView_H);
    imageView.image = [UIImage imageNamed:imageName];
    
    bgView.frame = CGRectMake(0, 0, CGRectGetMaxX(imageView.frame), 44);
    
    [bgView addSubview:imageView];
    [bgView addSubview:lable];
    
    return bgView;
}

@end
