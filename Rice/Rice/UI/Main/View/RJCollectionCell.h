//
//  RJCollectionCell.h
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJStoryListModel;

@interface RJCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *coverImg;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UIButton *equipmentBtn;

@property (weak, nonatomic) IBOutlet UIButton *detailsBtn;

@property (weak, nonatomic) IBOutlet UIButton *fixedBtn;

@property (nonatomic,strong) RJStoryListModel *model;

@property (copy, nonatomic) void (^collectionPlaylistAction)(RJStoryListModel * model);

@property (copy, nonatomic) void (^collectionPlayAction)(RJStoryListModel * model);

@end
