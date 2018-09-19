//
//  RJFamilyFooterView.m
//  Rice
//
//  Created by 李永 on 2018/9/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJFamilyFooterView.h"

@implementation RJFamilyFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.invitationBtn.layer.masksToBounds = YES;
    self.invitationBtn.layer.cornerRadius = 5;
    
    self.familyBtn.layer.masksToBounds = YES;
    self.familyBtn.layer.cornerRadius = 5;
}

- (IBAction)invitationAction:(id)sender {
    if (self.invitationAction) {
        self.invitationAction(sender);
    }
}

- (IBAction)exitAction:(id)sender {
    if (self.exitFamilyAction) {
        self.exitFamilyAction(sender);
    }
}



@end
