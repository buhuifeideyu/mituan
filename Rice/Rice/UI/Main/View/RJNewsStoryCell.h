//
//  RJNewsStoryCell.h
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJStoryModel;
@class RJStoryListModel;

@interface RJNewsStoryCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImg;

@property (weak, nonatomic) IBOutlet UILabel *storyTitle;

@property (weak, nonatomic) IBOutlet UILabel *storyContent;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (weak, nonatomic) IBOutlet UIImageView *vipImg;


@property (nonatomic,strong) RJStoryModel *model;

@property (nonatomic,strong) RJStoryListModel *storyListmodel;


@end
