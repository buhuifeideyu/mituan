//
//  RJFamilySettingView.m
//  Rice
//
//  Created by 李永 on 2018/9/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJFamilySettingView.h"
#import "YYLableTextHelper.h"

@interface RJFamilySettingView ()

@property (nonatomic, strong) RJFamilySettingView * alertView;

@end

@implementation RJFamilySettingView

- (instancetype)initWithFrame:(CGRect)frame model:(RJFamilyListModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        [self.alertView.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,[RJUserHelper shareInstance].lastLoginUserInfo.head]] placeholderImage:KDefaultImage];
        self.alertView.name.text = model.family_name;
//        self.alertView.exitBtn.hidden = [memberModel.auth integerValue] == 0 ? YES : NO;
    }
    return self;
}

- (void)createView
{
    self.backgroundColor = kColor(0, 0, 0, 0.2);
    
    //    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    //
    //    [self addGestureRecognizer:tap];
    
    self.alertView = [[NSBundle mainBundle] loadNibNamed:@"RJFamilySettingView" owner:nil options:nil].firstObject;
    
    self.alertView.center = self.center;
    
    self.alertView.bounds = CGRectMake(0, 0, KScreenWidth * 0.8, 350);
    
    self.alertView.layer.cornerRadius = 10;
    
    self.alertView.layer.masksToBounds = YES;
    
    self.alertView.backgroundColor = kColor(235, 105, 93, 1);
    
    self.alertView.buyBtn.layer.masksToBounds = YES;
    
    self.alertView.buyBtn.layer.cornerRadius = 5;
    
    self.alertView.exitBtn.layer.masksToBounds = YES;
    
    self.alertView.exitBtn.layer.cornerRadius = 5;
    
    NSString *titleText = @"购买VIP可以免费全部故事！";
    NSRange strRange1 = [titleText rangeOfString:@"购买"];
    NSRange strRange2 = [titleText rangeOfString:@"VIP"];
    NSRange strRange3 = [titleText rangeOfString:@"可以免费全部故事！"];
    self.alertView.titleLabel.attributedText = [YYLableTextHelper setLableTextWithString:titleText strFirstRange:strRange1 andSecondRange:strRange2 andThirdRange:strRange3 firstRangeColor:[UIColor blackColor] andSecondRangeColor:[UIColor yellowColor] andThirdRangeColor:[UIColor blackColor] firstRangeFontSize:15 andSecondRangeFontSize:15 andThirdRangeFontSize:15];
    
    __weak typeof(self) weakSelf = self;
    
    // 嵌套两层
    // 所以需要再实现这个方法
    self.alertView.nameEditorAction = ^(UIButton *sender, UILabel *label) {
        if (weakSelf.nameEditorAction) {
            weakSelf.nameEditorAction(sender, label);
        }
    };
    
    self.alertView.exitAction = ^(UIButton *sender) {
        if (weakSelf.exitAction) {
            weakSelf.exitAction(sender);
        }
    };
    
    self.alertView.buyAction = ^(UIButton *sender) {
        if (weakSelf.buyAction) {
            weakSelf.buyAction(sender);
        }
    };
    
    [self addSubview:self.alertView];
}

- (IBAction)nameEditorAction:(id)sender {
    if (self.nameEditorAction) {
        self.nameEditorAction(sender, self.name);
    }
}

- (IBAction)exitAction:(id)sender {
    if (self.exitAction) {
        self.exitAction(sender);
    }
}


- (IBAction)buyAction:(id)sender {
    if (self.buyAction) {
        self.buyAction(sender);
    }
}



- (IBAction)closeAction:(id)sender {
    [self hideView];
    
}


- (void)hideView
{
    [self.superview removeFromSuperview];
    
}




@end
