//
//  RJAddChildBtnCell.m
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJAddChildBtnCell.h"

@implementation RJAddChildBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)addAction:(id)sender {
    if (self.didSelect) {
        self.didSelect(sender);
    }
}

@end
