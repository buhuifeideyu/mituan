//
//  AppDelegate.m
//  Rice
//
//  Created by 李永 on 2018/9/4.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "AppDelegate.h"
#import "RJStartViewController.h"
#import "RJNavigationController.h"
#import "RJLoginViewController.h"
#import "RJHomeTabBarViewController.h"
#import "RJBannerInfo.h"

@interface AppDelegate ()

@property (nonatomic,strong) UIView *launchView;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self getLaunchImage];
    [self setKeyboardManager];
    return YES;
}

#pragma mark ---------------------------键盘管理
- (void)setKeyboardManager {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    
    keyboardManager.enable = YES; // 控制整个功能是否启用
    
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    
    keyboardManager.shouldToolbarUsesTextFieldTintColor = NO; // 控制键盘上的工具条文字颜色是否用户自定义
    
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    
    keyboardManager.shouldShowTextFieldPlaceholder = YES; // 是否显示占位文字
    
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    
    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}

#pragma mark ---------------------------登录流程和进入主界面
- (void)makeViewController {
    // 状态栏的状态
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    id key = (id)kCFBundleVersionKey;
    NSDictionary *info = [NSBundle mainBundle].infoDictionary;
    NSString *currentVersion = [info objectForKey:key];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *saveVersion = [defaults objectForKey:key];
    if ([currentVersion isEqualToString:saveVersion]){
        if ([RJUserHelper shareInstance].lastLoginUserInfo) {
            [self createTabBarControllerAndPresent];
        }else {
            // 未登录
            RJLoginViewController *Login = [[RJLoginViewController alloc] init];
            RJNavigationController *navVC = [[RJNavigationController alloc] initWithRootViewController:Login];
            self.window.rootViewController = navVC;
        }
    }else{
        [defaults setObject:currentVersion forKey:key];
        [defaults synchronize];
        RJStartViewController *Start = [[RJStartViewController alloc] init];
        RJNavigationController *navVC = [[RJNavigationController alloc] initWithRootViewController:Start];
        self.window.rootViewController = navVC;
    }
    [self.window makeKeyAndVisible];
}

//创建
- (void)createTabBarControllerAndPresent {
    RJHomeTabBarViewController *tabBarVC = [[RJHomeTabBarViewController alloc] init];
    
    self.window.rootViewController = tabBarVC;
}

-(void)getLaunchImage{
    
    [self.window makeKeyAndVisible];
    
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    self.launchView = viewController.view;

    [self.window addSubview:self.launchView];
    
    UIImageView *imageV=[[UIImageView alloc]init];
    
    imageV.backgroundColor=[UIColor whiteColor];
    
    [self.launchView addSubview:imageV];
    
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.launchView);
        
        make.left.right.equalTo(self.launchView);
        
        make.right.equalTo(self.launchView);
        
        make.bottom.equalTo(self.launchView);
        
    }];
    
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    
    [RJHttpRequest postAdWithPosition:kStartPage callback:^(NSDictionary *result) {
        if (result && [result isKindOfClass:[NSDictionary class]] && [result ql_boolForKey:@"status"]) {
            NSArray *rootList = [result objectForKey:@"data"];
            if (rootList && rootList.count > 0) {
                
                for (NSDictionary *info in rootList) {
                    RJBannerInfo *ad = [[RJBannerInfo alloc] init];
                    [ad initWithDictionary:info];
                    //图片资源
                    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,ad.pic]]];
                    UIImage *img = [UIImage imageWithData:imgData];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageV.image = img;
                    });
                }
            }
        }
    }];
    
    [self.window bringSubviewToFront:self.launchView];
    
    
    
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(removeADView) userInfo:nil repeats:NO];
    
}

-(void)removeADView {
    
    [self.launchView removeFromSuperview];
    
    [self makeViewController];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
