//
//  RJChildInfoView.m
//  Rice
//
//  Created by 李永 on 2018/9/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJChildInfoView.h"

@interface RJChildInfoView ()

@property (nonatomic, strong) RJChildInfoView * alertView;

@end

@implementation RJChildInfoView


- (instancetype)initWithFrame:(CGRect)frame model:(RJFamilyModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        [self.alertView.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.head]] placeholderImage:KDefaultImage];
        self.alertView.name.text = model.nickname;
        self.alertView.birthDay.text = [NSString stringWithFormat:@"生日：%@",model.birth];
        self.alertView.sex.text = [NSString stringWithFormat:@"性别：%@",[model.sex integerValue] == 1 ? @"男" : [model.sex integerValue] == 2 ? @"女" : @"未知"];
        self.alertView.relationship.text = [NSString stringWithFormat:@"与宝宝的关系：%@",model.relation];
    }
    return self;
}

- (void)createView
{
    self.backgroundColor = kColor(0, 0, 0, 0.2);
    
    //    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    //
    //    [self addGestureRecognizer:tap];
    
    self.alertView = [[NSBundle mainBundle] loadNibNamed:@"RJChildInfoView" owner:nil options:nil].firstObject;
    
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
    
    self.alertView.birthDayEditorAction = ^(UIButton *sender, UILabel *label) {
        if (weakSelf.birthDayEditorAction) {
            weakSelf.birthDayEditorAction(sender, label);
        }
    };
    
    self.alertView.sexEditorAction = ^(UIButton *sender, UILabel *label) {
        if (weakSelf.sexEditorAction) {
            weakSelf.sexEditorAction(sender, label);
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

- (IBAction)birthDayAction:(id)sender {
    if (self.birthDayEditorAction) {
        self.birthDayEditorAction(sender, self.alertView.birthDay);
    }
}

- (IBAction)sexAction:(id)sender {
    if (self.sexEditorAction) {
        self.sexEditorAction(sender, self.alertView.sex);
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
