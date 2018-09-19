//
//  RJAddChildBtnCell.h
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RJAddChildBtnCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, copy) void (^didSelect)(UIButton * sender);


@end
