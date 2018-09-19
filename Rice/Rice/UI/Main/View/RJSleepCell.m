//
//  RJSleepCell.m
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJSleepCell.h"
#import "RJStoryListModel.h"

@implementation RJSleepCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(RJStoryListModel *)model {
    _model = model;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.thumb]] placeholderImage:KDefaultImage];
}

//播放列表
- (IBAction)sleepPlaylistAction:(id)sender {
    if (self.sleepPlaylistAction) {
        self.sleepPlaylistAction(self.model);
    }
}

- (IBAction)playAction:(id)sender {
    if (self.sleepPlayAction) {
        self.sleepPlayAction(self.model,self.playBtn);
    }
}


@end
