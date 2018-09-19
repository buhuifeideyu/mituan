//
//  RJMytabBar.h
//  Rice
//
//  Created by 李永 on 2018/9/9.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RJMytabBar;

@protocol MyTabBarDelegate <NSObject>

@optional
- (void)tabBar:(RJMytabBar *)tabBar didSelectItemWithIndex:(NSUInteger)toIndex;

- (void)tabBar:(RJMytabBar *)tabBar didSelectItemWithIndex:(NSUInteger)toIndex fromIndex:(NSUInteger)fromIndex;

@end


@interface RJMytabBar : UIView

@property (nonatomic, assign) id <MyTabBarDelegate> delegate;

@end
