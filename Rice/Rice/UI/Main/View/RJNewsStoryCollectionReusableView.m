//
//  RJNewsStoryCollectionReusableView.m
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJNewsStoryCollectionReusableView.h"

@implementation RJNewsStoryCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.newsStoryLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
}

@end
