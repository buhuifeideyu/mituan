//
//  RJFoundLayout.h
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  CGFloat(^itemHeightBlock)(NSIndexPath* index);

@interface RJFoundLayout : UICollectionViewLayout

@property(nonatomic,strong )itemHeightBlock heightBlock ;

-(instancetype)initWithItemsHeightBlock:(itemHeightBlock)block;

@end
