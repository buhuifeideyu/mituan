//
//  RJFoundCell.h
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RJLabelModel;

@interface RJFoundCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *titleName;

@property (nonatomic,strong) RJLabelModel *model;


@end
