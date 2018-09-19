//
//  RJHomePlayListCell.m
//  Rice
//
//  Created by 李永 on 2018/9/13.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJHomePlayListCell.h"
#import "RJStoryModel.h"

@implementation RJHomePlayListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.vip.layer.masksToBounds = YES;
    self.vip.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(RJStoryModel *)model {
    _model = model;
    self.storyName.text = model.title;
    self.time.text = [NSDate getHHMMSSFromSS:model.length];
}

- (IBAction)playAction:(id)sender {
    if (self.playAction) {
        self.playAction(self.model);
    }
}

- (IBAction)moreAction:(id)sender {
    if (self.moreAction) {
        self.moreAction(self.model);
    }
}

@end
