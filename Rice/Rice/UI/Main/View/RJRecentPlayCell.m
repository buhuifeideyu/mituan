//
//  RJRecentPlayCell.m
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJRecentPlayCell.h"
#import "RJStoryListModel.h"

@implementation RJRecentPlayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(RJStoryListModel *)model {
    _model = model;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.thumb]] placeholderImage:KDefaultImage];
}

- (IBAction)recentPlayAction:(id)sender {
    if (self.recentPlayAction) {
        self.recentPlayAction(self.model);
    }
}

- (IBAction)recentPlayListAction:(id)sender {
    if (self.recentPlaylistAction) {
        self.recentPlaylistAction(self.model);
    }
}

@end
