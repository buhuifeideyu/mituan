//
//  RJFeedbackViewController.m
//  Rice
//
//  Created by 李永 on 2018/9/18.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJFeedbackViewController.h"

@interface RJFeedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation RJFeedbackViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = kNavColor;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI {
    self.title = @"意见反馈";

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithImageName:@"ReturnButton" addTarget:self action:@selector(backAction)];
    
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5;
    
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 5;
    
}

#pragma mark ---------------------------Action
#pragma mark ---提交
- (IBAction)submitFeedBackAction:(id)sender {
    [self submitFeedBack];
}

#pragma mark ---返回
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView {
    NSString *nsTextCotent = textView.text;
    NSInteger existTextNum = [nsTextCotent length];
    self.numLabel.text = [NSString stringWithFormat:@"%ld/200",existTextNum > 200 ? 200 : (long)existTextNum];
    self.textView.text = nsTextCotent.length > 200 ? [self.textView.text substringToIndex:200] : self.textView.text;
    self.promptLabel.hidden = existTextNum > 0 ? YES : NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        
        [textView resignFirstResponder];
        
        return NO;
        
    }
    
    return YES;
    
}

#pragma mark ---------------------------textField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}

- (void)submitFeedBack {
    if ([NSString ql_isEmpty:self.textView.text]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请填写反馈意见";
        [hud hideAnimated:YES afterDelay:1];
        return ;
    }else if ([NSString ql_isEmpty:self.textField.text] || self.textField.text.length != 11) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"请填写正确的手机号码";
        [hud hideAnimated:YES afterDelay:1];
        return ;
    }
    [RJHttpRequest postFeedbackAddWithContent:self.textView.text contact:self.textField.text image:nil callback:^(NSDictionary *result) {
        if ([result ql_boolForKey:@"status"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"提交成功";
            [hud hideAnimated:YES afterDelay:1];
            [self backAction];
        }
    }];
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
