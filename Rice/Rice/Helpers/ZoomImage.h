//
//  ZoomImage.h
//  DailyLesson
//
//  Created by 李永 on 2018/6/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+QL.h"

@interface ZoomImage : NSObject<UIActionSheetDelegate>


/**
 查看大图
 
 @param avatarImageView
 */
+(void)showImage:(UIImageView*)avatarImageView;

+(void)showAndDownloadImage:(UIImageView *)avatarImageView Target:(id)Target action:(SEL)action index:(NSInteger)index tag:(NSInteger)tag;

+(void)showImage:(UIImageView *)avatarImageView isHold:(BOOL)isHold longTapTarget:(id)Target action:(SEL)action BGV:(UIView *)backgroundView;

+(void)ChangeAndshowImage:(UIImageView *)avatarImageView Target:(id)Target takePhotoAction:(SEL)takePhoto ChoosePhotoAction:(SEL)ChoosePhoto;

@end
