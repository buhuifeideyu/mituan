//
//  RJHomePlayListCell.h
//  Rice
//
//  Created by 李永 on 2018/9/13.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJStoryModel;

@interface RJHomePlayListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *storyName;

@property (weak, nonatomic) IBOutlet UIButton *vip;

@property (weak, nonatomic) IBOutlet UIButton *more;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIButton *play;

@property (nonatomic,strong) RJStoryModel *model;

@property (copy, nonatomic) void (^playAction)(RJStoryModel * model);

@property (copy, nonatomic) void (^moreAction)(RJStoryModel * model);

@end
