//
//  RJMemBerInfoView.m
//  Rice
//
//  Created by 李永 on 2018/9/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJMemBerInfoView.h"

@interface RJMemBerInfoView ()

@property (nonatomic, strong) RJMemBerInfoView * alertView;

@end

@implementation RJMemBerInfoView


- (instancetype)initWithFrame:(CGRect)frame model:(RJFamilyModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        [self.alertView.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.head]] placeholderImage:KDefaultImage];
        self.alertView.name.text = model.nickname;
        self.alertView.remark.text = [NSString stringWithFormat:@"备注：%@",model.nickname];
        self.alertView.jurisdiction.text = [NSString stringWithFormat:@"权限设置：%@",[model.auth integerValue] == 0 ? @"创建者" : [model.auth integerValue] == 2 ? @"管理员" : @"成员"];
        self.alertView.relationship.text = [NSString stringWithFormat:@"与宝宝的关系：%@",model.relation];
        self.alertView.exitBtn.hidden = [model.auth integerValue] == 1 ? YES : NO;
    }
    return self;
}

- (void)createView
{
    self.backgroundColor = kColor(0, 0, 0, 0.2);
    
    //    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    //
    //    [self addGestureRecognizer:tap];
    
    self.alertView = [[NSBundle mainBundle] loadNibNamed:@"RJMemBerInfoView" owner:nil options:nil].firstObject;
    
    self.alertView.center = self.center;
    
    self.alertView.bounds = CGRectMake(0, 0, KScreenWidth * 0.8, 350);
    
    self.alertView.layer.cornerRadius = 10;
    
    self.alertView.layer.masksToBounds = YES;
    
    self.alertView.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self) weakSelf = self;
    
    // 嵌套两层
    // 所以需要再实现这个方法
    self.alertView.nameEditorAction = ^(UIButton *sender, UILabel *label) {
        if (weakSelf.nameEditorAction) {
            weakSelf.nameEditorAction(sender, label);
        }
    };
    
    self.alertView.remarkEditorAction = ^(UIButton *sender, UILabel *label) {
        if (weakSelf.remarkEditorAction) {
            weakSelf.remarkEditorAction(sender, label);
        }
    };
    
    self.alertView.jurisdictionAction = ^(UIButton *sender, UILabel *label) {
        if (weakSelf.jurisdictionAction) {
            weakSelf.jurisdictionAction(sender, label);
        }
    };
    
    self.alertView.relationshipEditorAction = ^(UIButton *sender, UILabel *label) {
        if (weakSelf.relationshipEditorAction) {
            weakSelf.relationshipEditorAction(sender, label);
        }
    };
    
    self.alertView.deleteAction = ^(UIButton *sender) {
        if (weakSelf.deleteAction) {
            weakSelf.deleteAction(sender);
        }
    };
    
    [self addSubview:self.alertView];
}


- (IBAction)nameEditorAction:(id)sender {
    if (self.nameEditorAction) {
        self.nameEditorAction(sender, self.alertView.name);
    }
}


- (IBAction)remarkEditorAction:(id)sender {
    if (self.remarkEditorAction) {
        self.remarkEditorAction(sender, self.alertView.remark);
    }
}

- (IBAction)jurisdictionAction:(id)sender {
    if (self.jurisdictionAction) {
        self.jurisdictionAction(sender, self.alertView.jurisdiction);
    }
}


- (IBAction)relationshipAction:(id)sender {
    if (self.relationshipEditorAction) {
        self.relationshipEditorAction(sender, self.alertView.relationship);
    }
}


- (IBAction)deleteAction:(id)sender {
    if (self.deleteAction) {
        self.deleteAction(sender);
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
