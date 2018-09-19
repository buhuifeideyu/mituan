//
//  RJNavigationController.m
//  Rice
//
//  Created by 李永 on 2018/9/4.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJNavigationController.h"

@interface RJNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation RJNavigationController{
    __weak RJNavigationController *__self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    __self = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = __self;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
        navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

@end
