//
//  RJLoginViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/4.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJLoginViewController.h"
#import "RJLoginPhoneViewController.h"
#import "RJHomeTabBarViewController.h"
#import "MD5Util.h"
#import "AppDelegate.h"

@interface RJLoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;


@end

@implementation RJLoginViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.chooseBtn setImage:[UIImage imageNamed:@"gouxuan"] forState:UIControlStateSelected];
    [self.chooseBtn setImage:[UIImage imageNamed:@"weigouxuan"] forState:UIControlStateNormal];
}

//跳过
- (IBAction)nextAction:(id)sender {
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//
//    RJHomeTabBarViewController *tabViewController = (RJHomeTabBarViewController *) appDelegate.window.rootViewController;
   
    
    
    
    RJHomeTabBarViewController *tabBarVC = [[RJHomeTabBarViewController alloc] init];
    
    [UIApplication sharedApplication].windows.firstObject.rootViewController = tabBarVC;
    
    if ([RJUserHelper shareInstance].lastLoginUserInfo) {
        [tabBarVC setSelectedIndex:0];
    }else {
        [tabBarVC setSelectedIndex:3];
    }
    
}

//微信登录
- (IBAction)weixinLoginAction:(id)sender {
//    [RJHttpRequest postQueryUser:@"18674707227" callback:^(NSDictionary *result) {
//        if ([result ql_boolForKey:@"status"]) {
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.label.text = @"该账号已注册";
//            [hud hideAnimated:YES afterDelay:1];
//        }
//    }];
    
}

//勾选协议
- (IBAction)chooseAction:(id)sender {
    self.chooseBtn.selected = !self.chooseBtn.selected;
}

//QQ登录
- (IBAction)qqLoginAction:(id)sender {
    
}


//手机登录
- (IBAction)phoneAction:(id)sender {
    RJLoginPhoneViewController *loginPhoneVC = [[RJLoginPhoneViewController alloc] init];
    [self.navigationController pushViewController:loginPhoneVC animated:YES];
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
