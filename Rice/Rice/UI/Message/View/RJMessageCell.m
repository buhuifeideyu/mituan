//
//  RJMessageCell.m
//  Rice
//
//  Created by 李永 on 2018/9/7.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJMessageCell.h"
#import "RJMessageModel.h"

@implementation RJMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.redView.layer.masksToBounds = YES;
//    self.redView.layer.cornerRadius = self.redView.height / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(RJMessageModel *)model {
    _model = model;
    self.redView.hidden = [model.status integerValue] > 0 ? YES : NO;
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    
    NSTimeInterval dateNum  = [[NSDate date] timeIntervalSince1970] - model.add_time;
    
    if (dateNum > 0 && dateNum < 1) {
        self.timeLabel.text = [NSString stringWithFormat:@"1秒前"];
    }else if (dateNum > 1 && dateNum < 60) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld秒前",(long)dateNum];
    }else if (dateNum < 3600) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld分钟前",(long)dateNum / 60];
    }else if (dateNum < 60 * 60 * 24) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld小时前",(long)dateNum / 3600];
    }else if (dateNum < 60 * 60 * 24 * 30) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld天前",(long)dateNum / (60 * 60 * 24)];
    }else if (dateNum < 60 * 60 * 24 * 365) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld月前",(long)dateNum / (60 * 60 * 24 * 30)];
    }else if (dateNum > 60 * 60 * 24 * 365) {
        self.timeLabel.text = [NSString stringWithFormat:@"%ld年前",(long)dateNum / (60 * 60 * 24 * 365)];
    }
//    self.timeLabel.text = [NSString stringWithFormat:@"%ld",model.add_time];
}

@end
