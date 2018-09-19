//
//  RJLikesCell.m
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJLikesCell.h"
#import "RJStoryListModel.h"

@implementation RJLikesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(RJStoryListModel *)model {
    _model = model;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.thumb]] placeholderImage:KDefaultImage];
}

- (IBAction)likesPlayAction:(id)sender {
    if (self.likesPlayAction) {
        self.likesPlayAction(self.model);
    }
}

- (IBAction)likesPlayListAction:(id)sender {
    if (self.likesPlaylistAction) {
        self.likesPlaylistAction(self.model);
    }
}





@end
