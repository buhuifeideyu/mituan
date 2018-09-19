//
//  RJSpecialColumnOtherCollectionReusableView.h
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJStoryListModel;

@interface RJSpecialColumnOtherCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *specialColumnTitle;

@property (weak, nonatomic) IBOutlet UILabel *specialColumnContent;

@property (nonatomic, copy) void (^moreAction)(UIButton * sender, UILabel *label);

@property (nonatomic,strong) RJStoryListModel *model;

@end
