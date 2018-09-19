//
//  RJPlayerListCell.m
//  Rice
//
//  Created by 李永 on 2018/9/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJPlayerListCell.h"
#import "RJStoryModel.h"

@implementation RJPlayerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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

//vip
- (IBAction)vipAction:(id)sender {
    if (self.vipAction) {
        self.vipAction(self.model);
    }
}

- (IBAction)sharedAction:(id)sender {
    if (self.sherAction) {
        self.sherAction(self.model);
    }
}



@end
