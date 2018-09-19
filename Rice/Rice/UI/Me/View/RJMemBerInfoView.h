//
//  RJMemBerInfoView.h
//  Rice
//
//  Created by 李永 on 2018/9/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJFamilyModel.h"

@interface RJMemBerInfoView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *remark;

@property (weak, nonatomic) IBOutlet UILabel *jurisdiction;

@property (weak, nonatomic) IBOutlet UILabel *relationship;

@property (weak, nonatomic) IBOutlet UIButton *exitBtn;


@property (copy, nonatomic) void (^deleteAction)(UIButton * sender);

@property (copy, nonatomic) void (^nameEditorAction)(UIButton * sender, UILabel *label);

@property (copy, nonatomic) void (^remarkEditorAction)(UIButton * sender, UILabel *label);

@property (copy, nonatomic) void (^jurisdictionAction)(UIButton * sender, UILabel *label);

@property (copy, nonatomic) void (^relationshipEditorAction)(UIButton * sender, UILabel *label);

- (instancetype)initWithFrame:(CGRect)frame model:(RJFamilyModel *)model;

@end
