//
//  RJPlayView.m
//  Rice
//
//  Created by 李永 on 2018/9/13.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJPlayView.h"
#import "RJStoryModel.h"
#import "RJStoryListModel.h"

@implementation RJPlayView

-(instancetype)init {
    self = [super init];
    if (self) {
       self = [[NSBundle mainBundle] loadNibNamed:@"RJPlayView" owner:nil options:nil].firstObject;
        [self.playerSlider setThumbImage:[UIImage new] forState:UIControlStateNormal];
        [self.playerSlider setThumbImage:[UIImage new] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)setStoryListModel:(RJStoryListModel *)storyListModel {
    _storyListModel = storyListModel;
}

- (void)setStorymodel:(RJStoryModel *)storymodel {
    _storymodel = storymodel;
}

- (IBAction)playerSliderAction:(id)sender {
    if (self.playerSliderAction) {
        self.playerSliderAction(self.storymodel, self.playerSlider);
    }
}

- (IBAction)playLisetAction:(id)sender {
    if (self.playlistAction) {
        self.playlistAction(self.storyListModel);
    }
}

- (IBAction)nextAction:(id)sender {
    if (self.nextStoryAction) {
        self.nextStoryAction(self.storyListModel);
    }
}

- (IBAction)playStoryAction:(id)sender {
    if (self.playStoryAction) {
        self.playStoryAction(self.storyListModel, self.playStoryBtn);
    }
}

- (IBAction)likeStoryAction:(id)sender {
    if (self.likeStoryAction) {
        self.likeStoryAction(self.storymodel, self.likeBtn);
    }
}

- (IBAction)timeAction:(id)sender {
    if (self.timeAction) {
        self.timeAction(self.storymodel, self.timeBtn);
    }
}


@end
