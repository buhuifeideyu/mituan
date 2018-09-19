//
//  YYUploadImageInfo.h
//  test
//
//  Created by dyj on 2017/3/31.
//  Copyright © 2017年 YueYun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYFileUploader.h"


@interface YYUploadImageInfo : NSObject<YYFileUploadInfo>

+ (instancetype)createWithImageLocalPath:(NSString *)path;

+ (instancetype)createWithImage:(UIImage *)image;

+ (instancetype)createWithVideoUrl:(NSString *)videoUrl;

@end
