//
//  YYChooseTypeAlertViewCell.m
//  YYFramework
//
//  Created by 李永 on 2017/5/23.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import "YYChooseTypeAlertViewCell.h"

@interface YYChooseTypeAlertViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;

@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;


@end

@implementation YYChooseTypeAlertViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTypeImg:(NSString *)typeImg {
    _typeImg = typeImg;
    _typeImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",typeImg]];
}

- (void)setTypeName:(NSString *)typeName {
    _typeName = typeName;
    _typeNameLabel.text = typeName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
