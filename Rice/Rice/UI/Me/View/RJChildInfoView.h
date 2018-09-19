//
//  RJChildInfoView.h
//  Rice
//
//  Created by 李永 on 2018/9/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJFamilyModel.h"

@interface RJChildInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *birthDay;

@property (weak, nonatomic) IBOutlet UILabel *sex;

@property (weak, nonatomic) IBOutlet UILabel *relationship;

@property (copy, nonatomic) void (^nameEditorAction)(UIButton * sender, UILabel *label);

@property (copy, nonatomic) void (^birthDayEditorAction)(UIButton * sender, UILabel *label);

@property (copy, nonatomic) void (^sexEditorAction)(UIButton * sender, UILabel *label);

@property (copy, nonatomic) void (^relationshipEditorAction)(UIButton * sender, UILabel *label);

@property (copy, nonatomic) void (^deleteAction)(UIButton * sender);

- (instancetype)initWithFrame:(CGRect)frame model:(RJFamilyModel *)model;

@end
