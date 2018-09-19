//
//  RJFamilyFooterView.h
//  Rice
//
//  Created by 李永 on 2018/9/12.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJFamilyFooterView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *invitationBtn;


@property (weak, nonatomic) IBOutlet UIButton *familyBtn;


@property (copy, nonatomic) void (^invitationAction)(UIButton * sender);

@property (copy, nonatomic) void (^exitFamilyAction)(UIButton * sender);

@end
