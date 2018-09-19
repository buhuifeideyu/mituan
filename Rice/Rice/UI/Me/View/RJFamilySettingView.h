//
//  RJFamilySettingView.h
//  Rice
//
//  Created by 李永 on 2018/9/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJFamilyListModel.h"
#import "RJFamilyModel.h"

@interface RJFamilySettingView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (weak, nonatomic) IBOutlet UIButton *exitBtn;

@property (copy, nonatomic) void (^nameEditorAction)(UIButton * sender, UILabel *label);

@property (copy, nonatomic) void (^buyAction)(UIButton * sender);

@property (copy, nonatomic) void (^exitAction)(UIButton * sender);

- (instancetype)initWithFrame:(CGRect)frame model:(RJFamilyListModel *)model;

@end
