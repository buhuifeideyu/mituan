//
//  RJFamilyMemberCell.m
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJFamilyMemberCell.h"
#import "RJFamilyModel.h"

@implementation RJFamilyMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImg.layer.masksToBounds = YES;
    self.headImg.layer.cornerRadius = ((KScreenWidth - 200) / 3) / 2;
    
}

- (void)setModel:(RJFamilyModel *)model {
    _model = model;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.head]] placeholderImage:KDefaultImage];
    self.name.text = model.relation;
}

@end
