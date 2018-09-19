//
//  RJCallPhoneAlertView.h
//  Rice
//
//  Created by 李永 on 2018/9/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJCallPhoneAlertView : UIView

@property (weak, nonatomic) IBOutlet UILabel *phoneNum;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (copy, nonatomic) void (^continueAction)(UIButton * sender);

@property (copy, nonatomic) void (^cancelAction)(UIButton * sender);

- (instancetype)initWithFrame:(CGRect)frame phoneNum:(NSString *)phoneNum;

+ (UIWebView *)callPhoneClickWithWebViewWithCallPhoneNum:(NSString *)callPhoneNum;

@end
