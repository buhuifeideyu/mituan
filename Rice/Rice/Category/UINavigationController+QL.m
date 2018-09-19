//
//  UINavigationController+QL.m
//  YYFramework
//
//  Created by dyj on 16/5/23.
//  Copyright © 2016年 YueYun. All rights reserved.
//

#import "UINavigationController+QL.h"

@implementation UINavigationController (QL)

- (void)ql_setNavigationStyle{
    self.interactivePopGestureRecognizer.enabled = YES;
    
    self.navigationBar.tintColor = [UIColor blueColor];
    self.navigationBar.translucent = YES;
    self.navigationBar.barStyle = UIBarStyleDefault;
}

@end
