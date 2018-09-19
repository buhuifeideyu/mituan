//
//  RJLoginPhoneViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/5.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJLoginPhoneViewController.h"
#import "RJLoginInfoViewController.h"
#import "RJHomeTabBarViewController.h"
#import "AppDelegate.h"

@interface RJLoginPhoneViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UIView *phoneBgView;

@property (weak, nonatomic) IBOutlet UIView *codeBgView;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *weixinLoginBtn;

@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

//定时器
@property (nonatomic,strong) NSTimer *timer;

//初始时间
@property (nonatomic,assign) int subTime;

@end

@implementation RJLoginPhoneViewController

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
    [self setUI];
}

- (void)setUI {
    self.phoneBgView.layer.masksToBounds = YES;
    self.phoneBgView.layer.cornerRadius = 5;
    
    self.codeBgView.layer.masksToBounds = YES;
    self.codeBgView.layer.cornerRadius = 5;
    
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 10;
    
    [self.phoneTextField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeTextField setValue:[UIColor darkGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
}

//获取验证码
- (IBAction)codeAction:(id)sender {
    if (self.phoneTextField.text.length == 11) {
        [RJHttpRequest postPhoneCode:self.phoneTextField.text  type:20 callback:^(NSDictionary *result) {
            if ([result ql_boolForKey:@"status"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"发送成功";
                [hud hideAnimated:YES afterDelay:1];
                if (self.timer == nil) {
                    self.subTime = 60;
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getCodeTimer) userInfo:nil repeats:YES];
                    [self.timer fire];
                }else {
                    [self.timer setFireDate:[NSDate date]];
                }
            }else {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"发送失败";
                [hud hideAnimated:YES afterDelay:1];
            }
        }];
    }else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请输入正确的手机号码";
        [hud hideAnimated:YES afterDelay:1];
    }
    
}

//验证码倒计时
- (void)getCodeTimer {
    if (self.subTime == 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.subTime = 60;
        self.codeBtn.userInteractionEnabled = YES;
        [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    }else {
        self.subTime--;
        self.codeBtn.userInteractionEnabled = NO;
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%zd",(long)self.subTime] forState:UIControlStateNormal];
        [self.codeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
}

//点击登录
- (IBAction)loginAction:(id)sender {
    
    [self loginApp];
    
}


//返回
- (IBAction)backVCAciton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---------------------------UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@"\n"]){
        
        [textField resignFirstResponder];
        return NO;
    }
    
    return YES;
    
}

#pragma mark ---------------------------netWork
//登录
- (void)loginApp {
    __weak RJLoginPhoneViewController *weakSelf = self;
//    if (self.phoneTextField.text.length == 11 && self.codeTextField.text.length > 0) {
    if (self.phoneTextField.text.length == 11 ) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.text = @"正在登录";
        [RJHttpRequest postLogin:@"1" phone:self.phoneTextField.text code:self.codeTextField.text.length < 1 ? @"654321" :self.codeTextField.text password:nil type:20 openid:nil access_token:nil uid:nil callback:^(NSDictionary *result) {
            
            if ([result ql_boolForKey:@"status"]) {
                NSDictionary *dic = [result objectForKey:@"data"];
                if (dic && dic.count > 0) {
                    [[RJUserHelper shareInstance] loginWithResultInfo:result loginType:RJLoginType_PhoneNumber];
                    [[RJUserHelper shareInstance] synUserInfoToUserDefault];
                    [hud hideAnimated:YES afterDelay:1];
                    if (![RJUserHelper shareInstance].lastLoginUserInfo.nickname && ![RJUserHelper shareInstance].lastLoginUserInfo.sex) {
                        RJLoginInfoViewController *loginInfoVC = [[RJLoginInfoViewController alloc] init];
                        [weakSelf.navigationController pushViewController:loginInfoVC animated:YES];
                    }else {
//                        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//                        
//                        RJHomeTabBarViewController *tabViewController = (RJHomeTabBarViewController *) appDelegate.window.rootViewController;
//                        
//                        [tabViewController setSelectedIndex:0];
                        RJHomeTabBarViewController *tabBarVC = [[RJHomeTabBarViewController alloc] init];
                        [UIApplication sharedApplication].windows.firstObject.rootViewController = tabBarVC;
                    }
                }
            }else {
                hud.label.text = @"登录失败";
                [hud hideAnimated:YES afterDelay:1];
            }
        }];
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
