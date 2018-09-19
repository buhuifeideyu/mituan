//
//  YYImageHelper.h
//  DailyLesson
//
//  Created by 李永 on 2018/6/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+QL.h"
#import "MD5Util.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

typedef void(^ListenerBlock)(int what,id data);
typedef void(^SaveImageResultBlock)(NSString *img,NSError *error);

@protocol YYSaveImageDelegate <NSObject>
@optional

-(void)didSaveImageSuccess:(NSString *)name;
-(void)didSaveImageFailed:(NSString *)name;

@end

@interface YYImageHelper : NSObject

@property (nonatomic,assign) id<YYSaveImageDelegate> delegate;
@property (nonatomic,copy) SaveImageResultBlock saveResultBlock;

+(BOOL)hasAccessForAlbum;

-(void)requestAccessForAlbum:(ListenerBlock)callback;

- (void)saveVideoToAlbum:(NSURL *)videoUrl;

-(void)saveLocalImagesToPhotosAlbum:(NSArray *)paths;

-(void)saveLocalImagesToPhotos:(NSArray *)paths toAlbum:(NSString *)albumName;

-(void)saveImage:(UIImage *)img toPhotosAlbum:(NSString *)albumName;

-(void)reviewImage:(UIImageView *)imgView;

- (void)dismissReview;

// 返回一个地址
+(NSString *)saveImage:(UIImage *)image to:(NSString *)path;

// 清除缓存
+ (BOOL)removeImageInPath:(NSString *)path;


@end

