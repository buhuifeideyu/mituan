//
//  RJCallPhoneAlertView.m
//  Rice
//
//  Created by 李永 on 2018/9/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJCallPhoneAlertView.h"

@interface RJCallPhoneAlertView ()

@property (nonatomic, strong) RJCallPhoneAlertView * alertView;

@property (nonatomic, copy) NSString * callPhoneNum;

@end

@implementation RJCallPhoneAlertView


- (instancetype)initWithFrame:(CGRect)frame phoneNum:(NSString *)phoneNum
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        self.alertView.phoneNum.text = phoneNum;
        self.callPhoneNum = phoneNum;
        
    }
    return self;
}

- (void)createView
{
    self.backgroundColor = kColor(0, 0, 0, 0.5);
    
    //    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    //
    //    [self addGestureRecognizer:tap];
    
    self.alertView = [[NSBundle mainBundle] loadNibNamed:@"RJCallPhoneAlertView" owner:nil options:nil].firstObject;
    
    self.alertView.center = self.center;
    
    self.alertView.bounds = CGRectMake(0, 0, KScreenWidth * 0.8, 150);
    
    self.alertView.layer.cornerRadius = 10;
    
    self.alertView.layer.masksToBounds = YES;
    
    self.alertView.backgroundColor = [UIColor whiteColor];
    
    self.alertView.continueButton.layer.masksToBounds = YES;
    
    self.alertView.continueButton.layer.borderWidth = 0.5;
    
    self.alertView.continueButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.alertView.cancelButton.layer.masksToBounds = YES;
    
    self.alertView.cancelButton.layer.borderWidth = 0.5;
    
    self.alertView.cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    __weak typeof(self) weakSelf = self;
    
    // 嵌套两层
    // 所以需要再实现这个方法
    self.alertView.continueAction = ^(UIButton *sender) {
        if (weakSelf.continueAction) {
            weakSelf.continueAction(sender);
        }
    };
    
    self.alertView.cancelAction  = ^(UIButton *sender) {
        if (weakSelf.cancelAction) {
            weakSelf.cancelAction(sender);
        }
    };
    
    [self addSubview:self.alertView];
}

- (IBAction)continueAction:(UIButton *)sender {
    
    if (self.continueAction) {
        self.continueAction(sender);
    }
    [self.superview removeFromSuperview];
}

- (IBAction)cancelAction:(UIButton *)sender {
    
    if (self.cancelAction) {
        self.cancelAction(sender);
    }
    [self.superview removeFromSuperview];
}

//拨打电话
+ (UIWebView *)callPhoneClickWithWebViewWithCallPhoneNum:(NSString *)callPhoneNum {
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",callPhoneNum];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    return callWebview;
}

- (void)hideView
{
    [self removeFromSuperview];
}



@end
