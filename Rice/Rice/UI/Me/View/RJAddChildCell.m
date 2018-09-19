//
//  RJAddChildCell.m
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJAddChildCell.h"
#import "RJFamilyModel.h"

@implementation RJAddChildCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgBgView.layer.masksToBounds = YES;
    //设置边框线的宽
    [self.imgBgView.layer setBorderWidth:1];
    //设置边框线的颜色
    [self.imgBgView.layer setBorderColor:[UIColor grayColor].CGColor];
    
    
    self.childImg.layer.masksToBounds = YES;
    self.childImg.layer.cornerRadius = 118 / 2;
//    self.childImg.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setModel:(RJFamilyModel *)model {
    _model = model;
    self.childName.text = model.child_name;
    [self.childImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.head]] placeholderImage:KDefaultImage];
    self.birthday.text = [NSString stringWithFormat:@"生日:%@",model.birth];
}

- (IBAction)binddingAction:(id)sender {
    if (self.didSelect) {
        self.didSelect(self.model);
    }
}


@end
