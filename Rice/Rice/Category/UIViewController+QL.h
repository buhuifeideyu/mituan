//
//  UIViewController+QL.h
//  YYFramework
//
//  Created by dyj on 15/8/6.
//  Copyright (c) 2015年 YueYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (QL)

-(void)initNavigationBarWithTitle:(NSString *)title;

- (void)clickBack:(id)sender;

- (void)registKeyboardShowNotification;

- (void)unRegistKeyboardShowNotification;

/**
 *  滚动scrollview到 view所在的位置，以使其不被弹出的键盘挡住。
 *
 *  @param view       目标view，通常是UITextFiled ,UITextView 等输入控件
 *  @param mainView   主界面的根view
 *  @param scrollview 装载着view的scrollview.
 */
- (void)makeView:(UIView *)view visiableOnView:(UIView *)mainView scrollview:(UIScrollView *)scrollView;

@end
