//
//  RJHomeTabBarViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/5.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJHomeTabBarViewController.h"
#import "RJNavigationController.h"
#import "RJMainViewController.h"
#import "RJMessageViewController.h"
#import "RJFamilyViewController.h"
#import "RJFoundViewController.h"
#import "RJMytabBar.h"

@interface RJHomeTabBarViewController ()

// 保存之前选中的按钮
@property (nonatomic, retain) UIButton *preSelBtn;

@end

@implementation RJHomeTabBarViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createViewControllers];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createViewControllers];
//
//    [self createTabBar];
}

- (void)createViewControllers {
    [self.tabBar setTintColor:[UIColor whiteColor]];
    
    //故事
    RJMainViewController *mainVC = [[RJMainViewController alloc]init];
    RJNavigationController *mainNav = [[RJNavigationController alloc] initWithRootViewController:mainVC];
    mainNav.navigationBar.barTintColor = [UIColor whiteColor];
    mainVC.tabBarItem.title = @"故事";
    
    [mainVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont   systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor darkGrayColor]}   forState:UIControlStateNormal];

    [mainVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
//    [mainVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    UIImage *liveUnselImg = [[UIImage imageNamed:@"tabBarImg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *liveSelImg = [[UIImage imageNamed:@"tabBarImg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainVC.tabBarItem.image = liveUnselImg;
    mainVC.tabBarItem.selectedImage = liveSelImg;
    mainVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -10);

    
    RJFoundViewController *foundVC = [[RJFoundViewController alloc] init];
    RJNavigationController *foundNav = [[RJNavigationController alloc] initWithRootViewController:foundVC];
    foundNav.navigationBar.barTintColor = [UIColor whiteColor];
    foundVC.tabBarItem.title = @"发现";
    [foundVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont   systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor darkGrayColor]}   forState:UIControlStateNormal];

    [foundVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    UIImage *msgUnselImg = [UIImage imageNamed:@"tabBarImg"];
    foundVC.tabBarItem.image = [msgUnselImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UIImage *msgSelImg = [UIImage imageNamed:@"tabBarImg"];
    foundVC.tabBarItem.selectedImage = [msgSelImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    foundVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -10);
    
    
    RJMessageViewController *messageVC = [[RJMessageViewController alloc] init];
    RJNavigationController *messageNav = [[RJNavigationController alloc] initWithRootViewController:messageVC];
    messageNav.navigationBar.barTintColor = [UIColor whiteColor];
    messageVC.tabBarItem.title = @"消息";
    [messageVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont   systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor darkGrayColor]}   forState:UIControlStateNormal];

    [messageVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    UIImage *conUnselImg = [UIImage imageNamed:@"tabBarImg"];
    messageVC.tabBarItem.image = [conUnselImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UIImage *conSelImg = [UIImage imageNamed:@"tabBarImg"];
    messageVC.tabBarItem.selectedImage = [conSelImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -10);
    
    
    RJFamilyViewController *familyVC = [[RJFamilyViewController alloc] init];
    RJNavigationController *familyNav = [[RJNavigationController alloc] initWithRootViewController:familyVC];
    familyNav.navigationBar.barTintColor = [UIColor whiteColor];
    familyVC.tabBarItem.title = @"家庭";
    [familyVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont   systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor darkGrayColor]}   forState:UIControlStateNormal];

    [familyVC.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]} forState:UIControlStateSelected];
    UIImage *myUnselImg = [UIImage imageNamed:@"tabBarImg"];
    familyVC.tabBarItem.image = [myUnselImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *mySelImg = [UIImage imageNamed:@"tabBarImg"];
    familyVC.tabBarItem.selectedImage = [mySelImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    familyVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -10);

    NSArray *controllers = [NSArray arrayWithObjects:mainNav, foundNav, messageNav, familyNav ,nil];
    [self setViewControllers:controllers animated:YES];
    
}

//// 定制tabBar  tabBar 49
//- (void)createTabBar
//{
//    // 0. 隐藏分栏控制器自带的tabbar
//    CGRect rect = self.tabBar.frame;
//    [self.tabBar removeFromSuperview];
//
//    RJMytabBar *tabBr = [[RJMytabBar alloc] initWithFrame:rect];
//
//    tabBr.delegate = self;
//
//    [self.view addSubview:tabBr];
//}

//#pragma mark - MyTabBarDelegate协议方法
//- (void)tabBar:(RJMytabBar *)tabBar didSelectItemWithIndex:(NSUInteger)toIndex
//{
//    // 设置分栏控制器选中的视图控制器
//    self.selectedIndex = toIndex;
//}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    id vc = self.selectedViewController;
    if (vc && [vc respondsToSelector:@selector(didCurrViewControllerSelected)]) {
        [vc didCurrViewControllerSelected];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
