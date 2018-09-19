//
//  UIBezierPath+YY.h
//  YYFramework
//
//  Created by dyj on 15/11/12.
//  Copyright © 2015年 YueYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBezierPath (YY)

- (UIBezierPath*)smoothedPathWithGranularity:(NSInteger)granularity;

@end
