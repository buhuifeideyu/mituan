//
//  RJPlayerListCell.h
//  Rice
//
//  Created by 李永 on 2018/9/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJStoryModel;

@interface RJPlayerListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *storyNum;

@property (weak, nonatomic) IBOutlet UILabel *storyName;

@property (weak, nonatomic) IBOutlet UIButton *sharedBtn;

@property (weak, nonatomic) IBOutlet UIButton *vip;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (nonatomic,strong) RJStoryModel *model;

@property (nonatomic, copy) void (^vipAction)(RJStoryModel * model);

@property (nonatomic, copy) void (^sherAction)(RJStoryModel * model);

@end
