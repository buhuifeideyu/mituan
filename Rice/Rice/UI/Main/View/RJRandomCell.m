//
//  RJRandomCell.m
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJRandomCell.h"
#import "RJStoryListModel.h"

@implementation RJRandomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(RJStoryListModel *)model {
    _model = model;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.thumb]] placeholderImage:KDefaultImage];
}

//播放列表
- (IBAction)randomPlaylistAction:(id)sender {
    if (self.randomPlaylistAction) {
        self.randomPlaylistAction(self.model);
    }
}

- (IBAction)randomplayAction:(id)sender {
    if (self.randomPlayAction) {
        self.randomPlayAction(self.model,self.playBtn);
    }
}

@end
