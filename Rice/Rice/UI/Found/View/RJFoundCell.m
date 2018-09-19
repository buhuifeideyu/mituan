//
//  RJFoundCell.m
//  Rice
//
//  Created by 李永 on 2018/9/11.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJFoundCell.h"

@implementation RJFoundCell

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.contentView.backgroundColor=[self randomColor];
//    }
//    return self;
//}
-(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleName.layer.masksToBounds = YES;
    
    self.titleName.backgroundColor=[self randomColor];
}

@end
