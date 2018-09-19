//
//  RJCollectionCell.m
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJCollectionCell.h"
#import "RJStoryListModel.h"

@implementation RJCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(RJStoryListModel *)model {
    _model = model;
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.thumb]] placeholderImage:KDefaultImage];
}

- (IBAction)collectionPlayAction:(id)sender {
    if (self.collectionPlayAction) {
        self.collectionPlayAction(self.model);
    }
}

- (IBAction)collectionPlayListAction:(id)sender {
    if (self.collectionPlaylistAction) {
        self.collectionPlaylistAction(self.model);
    }
}

@end
