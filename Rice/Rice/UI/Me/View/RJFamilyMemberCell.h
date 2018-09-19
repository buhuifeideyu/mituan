//
//  RJFamilyMemberCell.h
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJFamilyModel;

@interface RJFamilyMemberCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (nonatomic,strong) RJFamilyModel *model;


@end
