//
//  RJPlayView.h
//  Rice
//
//  Created by 李永 on 2018/9/13.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJStoryModel;
@class RJStoryListModel;

@interface RJPlayView : UIView

@property (weak, nonatomic) IBOutlet UISlider *playerSlider;

@property (weak, nonatomic) IBOutlet UIImageView *playerImg;

@property (weak, nonatomic) IBOutlet UILabel *playerTitle;

@property (weak, nonatomic) IBOutlet UILabel *playStoryName;

@property (weak, nonatomic) IBOutlet UILabel *storyTime;

@property (weak, nonatomic) IBOutlet UIButton *playlistBtn;

@property (weak, nonatomic) IBOutlet UIButton *nextStoryBtn;

@property (weak, nonatomic) IBOutlet UIButton *playStoryBtn;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (weak, nonatomic) IBOutlet UIButton *timeBtn;

@property (copy, nonatomic) void (^playerSliderAction)(RJStoryModel * model,UISlider *playerSlider);

@property (copy, nonatomic) void (^playlistAction)(RJStoryListModel * model);

@property (copy, nonatomic) void (^nextStoryAction)(RJStoryListModel * model);

@property (copy, nonatomic) void (^playStoryAction)(RJStoryListModel * model, UIButton *playStoryBtn);

@property (copy, nonatomic) void (^likeStoryAction)(RJStoryModel * model, UIButton *likeBtn);

@property (copy, nonatomic) void (^timeAction)(RJStoryModel * model, UIButton *timeBtn);

@property (nonatomic,strong) RJStoryModel *storymodel;

@property (nonatomic,strong) RJStoryListModel *storyListModel;

- (instancetype)init;

@end
