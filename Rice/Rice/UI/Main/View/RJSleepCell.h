//
//  RJSleepCell.h
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJStoryListModel;

@interface RJSleepCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImg;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UIButton *equipmentBtn;

@property (weak, nonatomic) IBOutlet UIButton *detailsBtn;

@property (nonatomic,strong) RJStoryListModel *model;

@property (copy, nonatomic) void (^sleepPlaylistAction)(RJStoryListModel * model);

@property (copy, nonatomic) void (^sleepPlayAction)(RJStoryListModel * model ,UIButton *playButton);

@end
