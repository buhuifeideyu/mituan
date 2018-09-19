//
//  YYEditView.m
//  YYFramework
//
//  Created by YYC on 16/6/29.
//  Copyright © 2016年 YueYun. All rights reserved.
//

#import "YYEditView.h"

@interface YYEditView ()<UITextFieldDelegate>
{
    NSString *_tit;
    UITextField *_textField;
    UIButton *_cancelBtn;
    UIButton *_confirBtn;
    CGRect selfFrame;
//    UIButton *cover;
    
    BOOL _empty;
}

@property (strong,nonatomic) UIButton *cover;

@property (copy, nonatomic) void (^callBack)(UIButton * button);

@end



@implementation YYEditView

#pragma mark - 

- (void)showSelectViewWithTitil:(NSString *)title callbBack:(void (^)(UIButton * button))callBack {
    self.cover = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.cover.backgroundColor = kColor(0, 0, 0, 0.5);
    self.cover.alpha = 0;
    [self.cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.cover];
    
    CGFloat selfW = KScreenWidth - 91;
    CGFloat selfH = 152;
    self.frame = CGRectMake(0, 0, selfW, selfH);
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self.cover addSubview:self];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, margins, selfW, 30)];
    titleLab.centerY = (selfH/3);
    titleLab.text = title;
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(-1, selfH - 50, CGRectGetWidth(self.frame)/2+1, 50);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kColor(18, 183, 252, 1) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    cancelBtn.layer.borderColor = kColor(234, 234, 234, 1).CGColor;
    cancelBtn.layer.borderWidth = 0.5f;
    [self addSubview:cancelBtn];
    _cancelBtn = cancelBtn;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(CGRectGetWidth(self.frame)/2, CGRectGetMinY(cancelBtn.frame), CGRectGetWidth(self.frame)/2+1, 50);
    [confirmBtn setTitle:@"退出" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:kColor(242, 87, 89, 1) forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    confirmBtn.layer.borderColor = kColor(234, 234, 234, 1).CGColor;
    confirmBtn.layer.borderWidth = 0.5f;
    [self addSubview:confirmBtn];
    _confirBtn = confirmBtn;
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    CGPoint center = self.cover.center;
    center.y -= 40;
    self.center = center;
    self.callBack = callBack;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)logoutViewWithTitle:(NSString *)title {
    
}

- (void)cancelBtnClick:(UIButton *)button {
    [self coverClick];
}

- (void)confirmBtnClick:(UIButton *)button {
    [self coverClick];
    if (self.callBack) {
        self.callBack(button);
    }
}


- (void)keyboardWillShow:(NSNotification *)aNotification{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat height = keyboardRect.size.height;
    if (self.cover != nil) {
        selfFrame = self.frame;
        if (CGRectGetMaxY(self.frame)>(KScreenHeight-height)) {
            self.frame = CGRectMake(selfFrame.origin.x, (KScreenHeight-height-selfFrame.size.height), selfFrame.size.width, selfFrame.size.height);
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification{
    if (selfFrame.origin.y != self.frame.origin.y) {
        if (selfFrame.origin.x != 0 || selfFrame.origin.y != 0 ||
            selfFrame.size.width != 0 || selfFrame.size.height != 0) {
            self.frame = selfFrame;
        }
    }
}

- (void)showEditViewWithTitil:(NSString *)title andName:(NSString *)name canBeEmpty:(BOOL)empty{
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    _empty = empty;
    _tit = title;
    self.cover = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.cover.backgroundColor = kColor(0, 0, 0, 0.5);
    self.cover.alpha = 0;
    [self.cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.cover];
    
    CGFloat selfW = KScreenWidth - 91;
    self.frame = CGRectMake(0, 0, selfW, selfW);
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self.cover addSubview:self];
    
    UIView * topBgView = [UIView new];
    topBgView.frame = CGRectMake(0, 0, selfW, 44);
    topBgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topBgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(margins, margins, selfW - margins * 2, 30)];
    titleLab.text = title;
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textColor = [UIColor darkGrayColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(titleLab.frame)+27, 11.5, 16)];
    imageView.image = [UIImage imageNamed:@"icon_pen.png"];
    [self addSubview:imageView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)+11, 0, CGRectGetWidth(self.frame) - 11 - CGRectGetMaxX(imageView.frame) - 22, 21)];
    _textField.centerY = imageView.centerY;
    _textField.placeholder = title;
    _textField.text = name;
    _textField.delegate = self;
    [self addSubview:_textField];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+10, 240, 0.5f)];
    line.backgroundColor = kColor(234, 234, 234, 1);
    line.centerX = self.width/2;
    [self addSubview:line];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelBtn.frame = CGRectMake(-1, CGRectGetMaxY(line.frame) + margins*2, CGRectGetWidth(self.frame)/2+1, 50);
    cancelBtn.frame = CGRectMake(CGRectGetWidth(self.frame)/2, CGRectGetMaxY(line.frame) + margins*2, CGRectGetWidth(self.frame)/2+1, 50);
    [cancelBtn setTitle:@"确定" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:kColor(18, 183, 252, 1) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    cancelBtn.layer.borderColor = kColor(234, 234, 234, 1).CGColor;
    cancelBtn.layer.borderWidth = 0.5f;
    [self addSubview:cancelBtn];
    _cancelBtn = cancelBtn;
    [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    confirmBtn.frame = CGRectMake(CGRectGetWidth(self.frame)/2, CGRectGetMaxY(line.frame) + margins*2, CGRectGetWidth(self.frame)/2+1, 50);
    confirmBtn.frame = CGRectMake(-1, CGRectGetMaxY(line.frame) + margins*2, CGRectGetWidth(self.frame)/2+1, 50);
    [confirmBtn setTitle:@"取消" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    confirmBtn.layer.borderColor = kColor(234, 234, 234, 1).CGColor;
    confirmBtn.layer.borderWidth = 0.5f;
    [self addSubview:confirmBtn];
    _confirBtn = confirmBtn;
    [confirmBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.frame = CGRectMake(0, 0, selfW, CGRectGetMaxY(_confirBtn.frame)-1);
    CGPoint center = self.cover.center;
    center.y -= 40;
    self.center = center;
    
    [_textField becomeFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}



- (void)showEditViewWithTitil:(NSString *)title {
    _tit = title;
    self.cover = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.cover.backgroundColor = kColor(0, 0, 0, 0.6);
    self.cover.alpha = 0;
    [self.cover addTarget:self action:@selector(coverClick) forControlEvents:UIControlEventTouchUpInside];
    [[UIApplication sharedApplication].keyWindow addSubview:self.cover];
    
    CGFloat selfW = KScreenWidth - margins * 4;
    self.frame = CGRectMake(0, 0, selfW, selfW);
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    [self.cover addSubview:self];
    
    UIView * topBgView = [UIView new];
    topBgView.frame = CGRectMake(0, 0, selfW, 44);
    topBgView.backgroundColor = kColor(191, 191, 191, 1);
    [self addSubview:topBgView];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(margins, margins, selfW - margins * 2, 30)];
    titleLab.text = title;
    titleLab.font = [UIFont systemFontOfSize:18];
    titleLab.textColor = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLab];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(margins * 2, CGRectGetMaxY(titleLab.frame) + margins*3, titleLab.width - margins * 2, titleLab.height)];
    _textField.placeholder = title;
    _textField.delegate = self;
    [self addSubview:_textField];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_textField.frame), CGRectGetMaxY(_textField.frame), _textField.width, 1)];
    line.backgroundColor = kColor(170, 170, 170, 1);
    [self addSubview:line];
    
    // 竖线
    UIView * verticalLine = [UIView new];
    verticalLine.frame = CGRectMake(self.width/2, CGRectGetMaxY(line.frame)+margins, 1, 20);
    verticalLine.backgroundColor =kColor(170, 170, 170, 1);
    [self addSubview:verticalLine];
    
    CGFloat btnW = selfW / 2;
    CGFloat btnX = 0;
    for (int i = 0; i < 2; i++) {
        btnX = i * btnW;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(btnX, CGRectGetMaxY(line.frame) + margins , btnW, 20)];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        if (i == 0) {
            _cancelBtn = btn;
            [btn setTitle:@"确定" forState:UIControlStateNormal];
            [btn setTitleColor:kColor(18, 183, 252, 1) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            
        }else {
            _confirBtn = btn;
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        }
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    self.frame = CGRectMake(0, 0, selfW, CGRectGetMaxY(_confirBtn.frame) + margins);
    CGPoint center = self.cover.center;
    center.y -= 80;
    self.center = center;
    
    [_textField becomeFirstResponder];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)btnClick:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"取消"]) {
        [self coverClick];
    }else {
        if (_textField.text.length == 0 && _empty == NO) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"%@不能为空", _tit];
            [hud hide:YES afterDelay:1];
        }else {
//            NSString * str = _textField.text;
            if ([_tit isEqualToString:@"设置昵称"] || [_tit isEqualToString:@"设置备注"]) {
                if (_textField.text.length > 8) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"昵称长度超过8位";
                    [hud hide:YES afterDelay:1];
                    return;
                }
            }
            
            if (self.isPhone) {//需要进行手机号码判断
                if ([self checkTelNumber1:_textField.text]) {
                    //有手机判断而且通过了判断
                    [self goBlock];
                }else{
                    //没通过判断
                    [self notCorrect];
                }
            }
            if (self.isTel) {//需要进行电话号码判断
                if ([self checkTelNumber2:_textField.text]) {
                    //有手机判断而且通过了判断
                    [self goBlock];
                }else{
                    //没通过判断
                    [self notCorrect];
                }
            }
            if (self.isEmail) {//需要进行邮箱判断
                if ([self checkTelNumber3:_textField.text]) {
                    //有手机判断而且通过了判断
                    [self goBlock];
                }else{
                    //没通过判断
                    [self notCorrect];
                }
            }
            if (self.isUrl) {//需要进行网址判断
                if ([_textField.text isEqualToString:@""] || [_textField.text isValidUrl:_textField.text]) {
                    //通过了判断
                    [self goBlock];
                }else{
                    //没通过判断
                    [self notCorrect];
                }
            }
            //如果不用进行手机号码、电话号码以及邮箱的判断
            if (!self.isPhone && !self.isEmail && !self.isTel && !self.isUrl) {
                [self goBlock];
            }
        }
    }
}
//回调
-(void)goBlock{
    if (self.returnTextBlock != nil) {
        self.returnTextBlock(_textField.text);
    }
    [self coverClick];
}
//检查手机、电话、邮箱结果不正确的反馈
-(void)notCorrect{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    if (self.isPhone) {
        hud.labelText = @"手机号码格式不正确";
    }else if (self.isTel){
        hud.labelText = @"电话号码格式不正确";
    }else if (self.isEmail){
        hud.labelText = @"邮箱格式不正确";
    }
    else if (self.isUrl){
        hud.labelText = @"网址格式不正确";
    }
    [hud hide:YES afterDelay:1];
}


- (void)coverClick {
    [_textField resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.cover.alpha = 0;
    } completion:^(BOOL finished) {
        [self.cover removeFromSuperview];
        self.cover = nil;
    }];
    
}

#pragma mark - 正则匹配手机号
//1.手机号码
- (BOOL)checkTelNumber1:(NSString *)telNumber {
//    
//    NSString * MOBIL = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBIL];
//    return [regextestmobile evaluateWithObject:MOBIL];
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";//移动
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";//联通
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";//电信
    NSPredicate *regextestmobile1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestmobile2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestmobile3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if ([regextestmobile1 evaluateWithObject:telNumber] || [regextestmobile2 evaluateWithObject:telNumber] || [regextestmobile3 evaluateWithObject:telNumber]) {
        return YES;
    }
    return NO;
    
}
//2.电话号码
- (BOOL)checkTelNumber2:(NSString *)telNumber {
    
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestTel = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    return[regextestTel evaluateWithObject:telNumber];
}
//3.邮箱地址
- (BOOL)checkTelNumber3:(NSString *)telNumber {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *regextestEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return[regextestEmail evaluateWithObject:telNumber];
}
////3.网址
//- (BOOL)checkTelNumber4:(NSString *)telNumber {
//    
//    NSString *regex =@"[a-zA-z]+://[^\\s]*";
//    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    return [urlTest evaluateWithObject:telNumber];
//}

#pragma mark - textField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length > 0) {
        
        _textField.returnKeyType = UIReturnKeyDone;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (![textField.text isEqualToString:@""]) {
        
        [self goBlock];
        
        [self coverClick];
    }
    return YES;
}

@end
