//
//  UIImage+QL.h
//  金华佗医生版
//
//  Created by Sim on 15/7/23.
//  Copyright (c) 2015年 SiuJiYung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QL)

- (UIImage *)fixOrientation:(UIImage *)aImage;
- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)GeometricscaleToSize:(CGSize)size;
- (UIImage *)imageInRect:(CGRect)rect;
- (UIImage *)imageInMiddleRect;
+ (UIImage*)imageFromView:(UIView*)view ;

@end
