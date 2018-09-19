//
//  YYUploadImageInfo.m
//  test
//
//  Created by dyj on 2017/3/31.
//  Copyright © 2017年 YueYun. All rights reserved.
//

#import "YYUploadImageInfo.h"
#import "YYImageHelper.h"

@implementation YYUploadImageInfo{
    
}
@synthesize taskId;
@synthesize file_id;
@synthesize localPath;
@synthesize fileUrl;
@synthesize thumbnail;
@synthesize uploadStatus;
@synthesize localFileName;


+ (instancetype)createWithImageLocalPath:(NSString *)path{
    YYUploadImageInfo *info = [[YYUploadImageInfo alloc] init];
    info.localPath = path;
    info.uploadStatus = UploadImageStatus_Waiting;
    return info;
}

+ (instancetype)createWithImage:(UIImage *)image{
    NSString *path = [YYImageHelper saveImage:image to:nil];
    YYUploadImageInfo *info = [[YYUploadImageInfo alloc] init];
    info.localPath = path;
    info.uploadStatus = UploadImageStatus_Waiting;
    return info;
}

+ (instancetype)createWithVideoUrl:(NSString *)videoUrl {
    YYUploadImageInfo *info = [[YYUploadImageInfo alloc] init];
    info.localPath = videoUrl;
    info.uploadStatus = UploadImageStatus_Waiting;
    return info;
}

static NSInteger __idIndex = 10;

- (instancetype)init{
    self = [super init];
    if (self) {
        self.taskId = __idIndex++;
    }
    return self;
}

@end
