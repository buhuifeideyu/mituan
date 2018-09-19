//
//  UIImage+QL.m
//  金华佗医生版
//
//  Created by Sim on 15/7/23.
//  Copyright (c) 2015年 SiuJiYung. All rights reserved.
//

#import "UIImage+QL.h"

@implementation UIImage (QL)

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


-(UIImage *)scaleToSize:(CGSize)size{
    CGFloat _width = self.size.width;
    CGFloat _height = self.size.height;
    
//    if (_width <= size.width && _height <= size.height) {
//        return self;
//    }
    if (_width == 0 || _height == 0) {
        return self;
    }
    
    CGFloat widthFactor = size.width / _width;
    CGFloat heightFactor = size.height / _height;
    CGFloat scaleFactor = (widthFactor < heightFactor ? widthFactor:heightFactor);
    
    CGFloat scaledWidth = _width * scaleFactor;
    CGFloat scaledHeight = _height * scaleFactor;
    CGSize targeSize = CGSizeMake(scaledWidth, scaledHeight);
    
    UIGraphicsBeginImageContext(targeSize);
    [self drawInRect:CGRectMake(0, 0, scaledWidth, scaledHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

-(UIImage *)GeometricscaleToSize:(CGSize)size{
    CGFloat _width = self.size.width;
    CGFloat _height = self.size.height;
    
    if (_width <= size.width && _height <= size.height) {
        return self;
    }
    
    CGFloat widthFactor = size.width / _width;
    CGFloat heightFactor = size.height / _height;
    CGFloat scaleFactor = (widthFactor < heightFactor ? widthFactor:heightFactor);
    
    CGFloat scaledWidth = _width * scaleFactor;
    CGFloat scaledHeight = _height * scaleFactor;
    CGSize targeSize = CGSizeMake(scaledWidth, scaledHeight);
    
    UIGraphicsBeginImageContext(targeSize);
    [self drawInRect:CGRectMake(0, 0, scaledWidth, scaledHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (UIImage *)imageInRect:(CGRect)rect {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *subImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return subImage;
}

- (UIImage *)imageInMiddleRect {
    
    float width = self.size.width;
    float height = self.size.height;
    
    if (width == height) {
        return self;
    }
    CGRect rect;
    // 中心区域距离两端距离
    float interval = 0;
    if (width > height) {
        interval = (width - height) / 2;
        rect = CGRectMake(interval, 0, height, height);
    } else {
        interval = (height - width) / 2;
        rect = CGRectMake(0, interval, width, width);
    }
    return [self imageInRect:rect];
}

+ (UIImage*)imageFromView:(UIView*)view {
    UIGraphicsBeginImageContext(view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
