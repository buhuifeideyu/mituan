//
//  UIScrollView+QL.m
//  YYFramework
//
//  Created by dyj on 16/5/26.
//  Copyright © 2016年 YueYun. All rights reserved.
//

#import "UIScrollView+QL.h"

@implementation UIScrollView (QL)

- (void)scrollToView:(UIView *)view{
    if (view == nil) {
        return;
    }
    CGRect rectOfScrollView = [view convertRect:view.frame toView:self];
    [self scrollRectToVisible:rectOfScrollView animated:YES];
}

@end
