//
//  RJMessageCell.h
//  Rice
//
//  Created by 李永 on 2018/9/7.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJMessageModel;

@interface RJMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *redView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,strong) RJMessageModel *model;


@end
