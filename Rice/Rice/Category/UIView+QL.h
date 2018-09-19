//
//  UIView+QL.h
//  Weibo
//
//  Created by Vincent_Guo on 15-3-16.
//  Copyright (c) 2015年 Fung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QL)

/**
 *  UIView的尺寸
 */
@property (nonatomic,assign) CGSize size;

/**
 *  获取或者更改控件的宽度
 */
@property (nonatomic,assign) CGFloat width;

/**
 *  获取或者更改控件的高度
 */
@property (nonatomic,assign) CGFloat height;

/**
 *  获取或者更改控件的x坐标
 */
@property (nonatomic,assign) CGFloat x;

/**
 *  获取或者更改控件的y坐标
 */
@property (nonatomic,assign) CGFloat y;

@property (nonatomic,assign) CGFloat centerX;

@property (nonatomic,assign) CGFloat centerY;

/**
 *  绑定的属性名
 */
@property (nonatomic,copy) NSString *ql_bindName;

@property (nonatomic,strong) id ql_autoValue;

@end
