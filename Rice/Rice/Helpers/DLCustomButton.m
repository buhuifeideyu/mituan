//
//  DLCustomButton.m
//  DailyLesson
//
//  Created by 李永 on 2018/6/29.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "DLCustomButton.h"

@interface DLCustomButton ()

/**
 图片距离上下的距离
 */
@property (nonatomic, assign) CGFloat space;

@end

@implementation DLCustomButton

+ (id)buttonWithType:(UIButtonType)buttonType withSpace:(CGFloat)space {
    DLCustomButton *button = [super buttonWithType:buttonType];
    button.space = space;
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //文案的宽度
    CGFloat labelWidth = self.titleLabel.frame.size.width;
    //文案的高度
    CGFloat labelHeight = self.titleLabel.frame.size.height;
    //button的image
    UIImage *image = self.imageView.image;
    
    switch (self.buttonStyle) {
        case DLButtonImageLeft: {
            //设置后的image显示的高度
            CGFloat imageHeight = self.frame.size.height - (2 * self.space);
            //文案和图片居中显示时距离两边的距离
            CGFloat edgeSpace = (self.frame.size.width - imageHeight - labelWidth - self.padding) / 2;
            self.imageEdgeInsets = UIEdgeInsetsMake(self.space, edgeSpace, self.space, edgeSpace + labelWidth + self.padding);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -image.size.width + imageHeight + self.padding, 0, 0);
        }
            break;
        case DLButtonImageRight: {
            //设置后的image显示的高度
            CGFloat imageHeight = self.frame.size.height - (2 * self.space);
            //文案和图片居中显示时距离两边的距离
            CGFloat edgeSpace = (self.frame.size.width - imageHeight - labelWidth - self.padding) / 2;
            self.imageEdgeInsets = UIEdgeInsetsMake(self.space, edgeSpace + labelWidth + self.padding, self.space, edgeSpace);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -image.size.width - self.padding - imageHeight, 0, 0);
        }
            break;
        case DLButtonImageTop: {
            //设置后的image显示的高度
            CGFloat imageHeight = self.frame.size.height - (2 * self.space) - labelHeight - self.padding;
            if (imageHeight > image.size.height) {
                imageHeight = image.size.height;
            }
            self.imageEdgeInsets = UIEdgeInsetsMake(self.space, (self.frame.size.width - imageHeight) / 2, self.space + labelHeight + self.padding, (self.frame.size.width - imageHeight) / 2);
            self.titleEdgeInsets = UIEdgeInsetsMake(self.space + imageHeight + self.padding, -image.size.width, self.space, 0);
        }
            break;
        case DLButtonImageBottom: {
            //设置后的image显示的高度
            CGFloat imageHeight = self.frame.size.height - (2 * self.space) - labelHeight - self.padding;
            if (imageHeight > image.size.height) {
                imageHeight = image.size.height;
            }
            self.imageEdgeInsets = UIEdgeInsetsMake(self.space + labelHeight + self.padding, (self.frame.size.width - imageHeight) / 2, self.space, (self.frame.size.width - imageHeight) / 2);
            self.titleEdgeInsets = UIEdgeInsetsMake(self.space, -image.size.width, self.padding + imageHeight + self.space, 0);
        }
            break;
        default:
            break;
    }
}



@end
