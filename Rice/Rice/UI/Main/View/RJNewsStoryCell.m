//
//  RJNewsStoryCell.m
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJNewsStoryCell.h"
#import "RJStoryModel.h"
#import "RJStoryListModel.h"

@implementation RJNewsStoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(RJStoryModel *)model {
    _model = model;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.thumb]] placeholderImage:KDefaultImage];
    
    self.storyTitle.text = model.title;
    
    self.storyContent.text = model.summary;
    
    self.vipImg.hidden = [model.vip integerValue] > 0 ? NO : YES;
    
    [self.likeBtn setTitle:[NSString stringWithFormat:@"%ld",(long)model.is_like] forState:UIControlStateNormal];
}

- (void)setStoryListmodel:(RJStoryListModel *)storyListmodel {
    _storyListmodel = storyListmodel;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,storyListmodel.thumb]] placeholderImage:KDefaultImage];
    
    self.storyTitle.text = storyListmodel.title;
    
    self.storyContent.text = storyListmodel.summary;
    
    self.vipImg.hidden = YES;
    
    self.likeBtn.hidden = YES;

}

@end
