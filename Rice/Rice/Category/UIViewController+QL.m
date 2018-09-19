//
//  UIViewController+QL.m
//  YYFramework
//
//  Created by dyj on 15/8/6.
//  Copyright (c) 2015年 YueYun. All rights reserved.
//

#import "UIViewController+QL.h"
#import "UIScrollView+QL.h"

@implementation UIViewController (QL)


-(void)initNavigationBarWithTitle:(NSString *)title{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:236/255.0 blue:235/255.0 alpha:1];
    
    //    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:46/255.0 green:170/255.0 blue:236/255.0 alpha:1];
    self.title = title;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(([self.title length] < 10 ?NSTextAlignmentCenter : NSTextAlignmentLeft), 0, 480,44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text=self.title;
    [label sizeToFit];
    self.navigationItem.titleView = label;

    
    UIImage *image = [UIImage imageNamed:@"返回.png"];
    UIButton *left = [[UIButton alloc]init];
    left.bounds =CGRectMake(0, 0, image.size.width, image.size.height);
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:left];
    [left setBackgroundImage:image forState:UIControlStateNormal];
    [left addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *right = [[UIButton alloc]init];
    right.bounds =CGRectMake(0, 0, 10,20);
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:right];
}

- (void)clickBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  注册键盘通知
 */
- (void)registKeyboardShowNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardFrameChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

/**
 *  解除键盘通知
 */
- (void)unRegistKeyboardShowNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)didKeyboardFrameChange:(NSNotification *)notification{
    if(notification.userInfo == nil){
        return;
    }
    NSValue *avalue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [avalue CGRectValue].size;
    CGFloat keyboardHeight = 0;
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        keyboardHeight = keyboardSize.width;
    } else {
        keyboardHeight = keyboardSize.height;
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setFloat:keyboardHeight forKey:@"KeyboardHeight"];
    [ud synchronize];
}

-(void)didKeyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    //获取高度
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    float keyboardHeight = 0;
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        keyboardHeight = keyboardSize.width;
    } else {
        keyboardHeight = keyboardSize.height;
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setFloat:keyboardHeight forKey:@"KeyboardHeight"];
    [ud synchronize];
}

/**
 *  向上查找符合类型的父控件
 *
 *  @param parentView 父控件类型
 *  @param view       起点控件
 *
 *  @return 如果没有，返回nil
 */
- (UIView *)lookForParentView:(Class)parentView of:(UIView *)view{
    if (view == nil ) {
        return nil;
    }
    UIView *_parent = view.superview;
    if (_parent && [_parent isKindOfClass:parentView]) {
        return _parent;
    }else{
        return [self lookForParentView:parentView of:_parent];
    }
}

/**
 *  向下查找符合类型的子控件
 *
 *  @param viewType 控件类型
 *  @param view     起始控件
 *
 *  @return
 */
- (UIView *)lookForSubView:(Class)viewType of:(UIView *)view{
    if (view == nil) {
        return nil;
    }
    NSArray *_subViews = view.subviews;
    if (_subViews == nil) {
        return nil;
    }
    for (UIView *sbview in _subViews) {
        if ([sbview isKindOfClass:viewType]) {
            return sbview;
        }
        UIView *_tmpView = [self lookForSubView:viewType of:sbview];
        if (_tmpView && [_tmpView isKindOfClass:viewType]) {
            return _tmpView;
        }
    }
    return nil;
}

/**
 *  查找根View
 *
 *  @param view 查找起点
 *
 *  @return
 */
- (UIView *)getRootView:(UIView *)view{
    if (view == nil) {
        return nil;
    }
    UIView *_tmpSuperView = view.superview;
    if (_tmpSuperView == nil) {
        return view;
    }
    return [self getRootView:_tmpSuperView];
}




/**
 *  滚动scrollview到 view所在的位置，以使其不被弹出的键盘挡住。
 *
 *  @param view       目标view，通常是UITextFiled ,UITextView 等输入控件
 *  @param mainView   主界面的根view
 *  @param scrollview 装载着view的scrollview.
 */
- (void)scrollToView:(UIView *)view{
    //查找view控件的父控件，是否有UIScrllView.
    UIScrollView *parentScrollView = (UIScrollView *)[self lookForParentView:[UIScrollView class] of:view];
    CGFloat keyboardViewHeight = 45.0f;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    keyboardViewHeight = [ud floatForKey:@"KeyboardHeight"];
    if (parentScrollView != nil) {
        //存在scrollview
        CGRect rectViewInScrollView = [view convertRect:view.frame toView:parentScrollView];
        CGFloat _toScrollViewBottom = parentScrollView.contentSize.height - (rectViewInScrollView.origin.y + rectViewInScrollView.size.height);

        UIView *_rootView = [self getRootView:parentScrollView];
        CGRect rectScrollViewInRootView = [parentScrollView convertRect:parentScrollView.frame toView:_rootView];
//        CGFloat _toRootViewBottom = rectScrollViewInRootView.origin.y + rectScrollViewInRootView.size.height -
//        rectScrollViewInRootView.origin.y + rectScrollViewInRootView.size.height;
    }
    
    
//    [UIView animateWithDuration:0.5 animations:^{
//        
////        CGPoint viewPoint = [view convertPoint:view.frame.origin toView:mainView];
//        CGPoint viewPoint = view.frame.origin;
//        float toBottomOffset = scrollView.contentSize.height - viewPoint.y - CGRectGetHeight(view.frame);
//        
//        NSLog(@"MainHeight:%f,KeyboardHeight:%f,view.y:%f",MainHeight,kKeyboardHeight,viewPoint.y);
//        CGFloat offset = toBottomOffset - (MainHeight - kKeyboardHeight - 44);
//        if (offset < 0) {
//            scrollView.transform = CGAffineTransformMakeTranslation(0, offset);//-250
//        }
//    }];
}

@end
