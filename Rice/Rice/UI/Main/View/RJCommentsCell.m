//
//  RJCommentsCell.m
//  Rice
//
//  Created by 李永 on 2018/9/13.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJCommentsCell.h"
#import "RJCommentModel.h"

@implementation RJCommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(RJCommentModel *)model {
    _model = model;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.thumb]] placeholderImage:KDefaultImage];
//    self.name.text = model
    self.content.text = model.content;

}

@end
