//
//  RJAddChildCell.h
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJFamilyModel;

@interface RJAddChildCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *childImg;

@property (weak, nonatomic) IBOutlet UIImageView *bindingImg;

@property (weak, nonatomic) IBOutlet UIButton *bindingBtn;

@property (weak, nonatomic) IBOutlet UILabel *childName;

@property (weak, nonatomic) IBOutlet UILabel *birthday;

@property (weak, nonatomic) IBOutlet UIView *imgBgView;

@property (nonatomic, copy) void (^didSelect)(RJFamilyModel * model);

@property (nonatomic,strong) RJFamilyModel *model;


@end
