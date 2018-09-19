//
//  RJSpecialColumnCollectionReusableView.m
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJSpecialColumnCollectionReusableView.h"
#import "RJStoryListModel.h"

@implementation RJSpecialColumnCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.specialColumnTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
}

- (IBAction)moreAction:(id)sender {
    if (self.moreAction) {
        self.moreAction(sender,self.specialColumnTitle);
    }
}

- (void)setModel:(RJStoryListModel *)model {
    _model = model;
    self.specialColumnTitle.text = model.title;
    self.specialColumnContent.text = model.summary;
}

@end
