//
//  YYImageHelper.m
//  DailyLesson
//
//  Created by 李永 on 2018/6/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "YYImageHelper.h"
#import "PathHelper.h"
#import "ZoomImage.h"

@implementation YYImageHelper{
    NSInteger taskCount;
    NSInteger successCount;
    ALAssetsLibrary *assLibrary;
    CGRect zoomTargeImageViewFrame;//缩放image的frame
    UIImageView *scanImageView;
    UIView *scanContentView;
    BOOL showingScanImageView;
}

-(id)init{
    self = [super init];
    if (self) {
        assLibrary = [[ALAssetsLibrary alloc] init];
        showingScanImageView = NO;
    }
    return self;
}

+(BOOL)hasAccessForAlbum{
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    return  author == ALAuthorizationStatusAuthorized;
}

-(void)requestAccessForAlbum:(ListenerBlock)callback{
    [assLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (callback) {
            callback(*stop?1:-1,nil);
        }
    } failureBlock:^(NSError *error) {
        if (callback) {
            callback(-1,nil);
        }
    }];
}

-(void)saveLocalImagesToPhotosAlbum:(NSArray *)paths{
    taskCount = [paths count];
    successCount = 0;
    UIImage *tmpImage = nil;
    for (NSString *path in paths) {
        tmpImage = [UIImage imageWithContentsOfFile:path];
        if (tmpImage) {
            
            UIImageWriteToSavedPhotosAlbum(tmpImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }
}

-(void)saveLocalImagesToPhotos:(NSArray *)paths toAlbum:(NSString *)albumName{
    UIImage *tmpImage = nil;
    for (NSString *path in paths) {
        tmpImage = [UIImage imageWithContentsOfFile:path];
        if (tmpImage) {
            [assLibrary saveImage:tmpImage toAlbum:albumName withCompletionBlock:^(NSError *error) {
                [self image:tmpImage didFinishSavingWithError:error contextInfo:NULL];
            }];
        }
    }
}

-(void)saveTYPhotos2Album:(NSArray *)photoList{
    taskCount = [photoList count];
    successCount = 0;
}

-(void)saveImage:(UIImage *)img toPhotosAlbum:(NSString *)albumName{
    [assLibrary saveImage:img toAlbum:albumName withCompletionBlock:^(NSError *error) {
        [self image:img didFinishSavingWithError:error contextInfo:NULL];
    }];
}

- (void)saveVideoToAlbum:(NSURL *)videoUrl{
    [assLibrary writeVideoAtPathToSavedPhotosAlbum:videoUrl completionBlock:^(NSURL *assetURL, NSError *error) {
        if (_saveResultBlock) {
            _saveResultBlock(nil,error);
        }
    }];
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error != NULL) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSaveImageFailed:)]) {
            [self.delegate didSaveImageFailed:nil];
        }
        if(self.saveResultBlock){
            self.saveResultBlock(nil,error);
        }
    }else{
        successCount ++;
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSaveImageSuccess:)]) {
            [self.delegate didSaveImageSuccess:nil];
        }
        if(self.saveResultBlock){
            self.saveResultBlock(nil,error);
        }
    }
}

-(void)reviewImage:(UIImageView *)imgView{
    if (!imgView) {
        return;
    }
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    zoomTargeImageViewFrame = [imgView convertRect:imgView.frame toView:win];
    if (!scanContentView) {
        scanContentView = [[UIView alloc] initWithFrame:win.bounds];
        scanContentView.backgroundColor = [UIColor ql_colorWithHex:@"000000" alpha:0.5f];
        
        scanImageView = [[UIImageView alloc] initWithFrame:win.bounds];
        scanImageView.contentMode = UIViewContentModeScaleAspectFit;
        scanImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
        [tapGesture addTarget:self action:@selector(tapReviewImage:)];
        [scanImageView addGestureRecognizer:tapGesture];
    }
    scanContentView.alpha = 1;
    scanImageView.alpha = 0;
    scanImageView.frame = zoomTargeImageViewFrame;
    scanImageView.image = imgView.image;
    [win addSubview:scanContentView];
    [scanContentView addSubview:scanImageView];
    [UIView animateWithDuration:0.4f animations:^{
        scanImageView.frame = win.bounds;
        scanImageView.alpha = 1;
    } completion:^(BOOL finished) {
        showingScanImageView = YES;
    }];
}

- (void)tapReviewImage:(UIGestureRecognizer *)gesture{
    [self dismissReview];
}

- (void)dismissReview{
    if (scanContentView && showingScanImageView) {
        [UIView animateWithDuration:0.4f animations:^{
            scanImageView.frame = zoomTargeImageViewFrame;
            scanImageView.alpha = 0;
            scanContentView.alpha = 0;
        } completion:^(BOOL finished) {
            [scanImageView removeFromSuperview];
            [scanContentView removeFromSuperview];
            showingScanImageView = NO;
        }];
        
    }
}


+(NSString *)saveImage:(UIImage *)image to:(NSString *)path{
    NSString *md5code = nil;
    UIImage *_compressimg = nil;
    NSString *_fullpath = nil;
    
    NSString *defaultPath = [NSString stringWithFormat:@"%@/tmp/",
                             [PathHelper getDocumentDirPath]];
    
    if (path == nil) {
        path = defaultPath;
    }
    @autoreleasepool {
        UIImage *_imagesrc =image;
        //        UIImage *_smallimg = [image scaleToSize:CGSizeMake(800.0f, 600.0f)];
        //最大压缩比率
        NSData *_tmpdt = UIImageJPEGRepresentation(_imagesrc, 0.9);
        _compressimg = [UIImage imageWithData:_tmpdt];
        _imagesrc = nil;
        //        _smallimg = nil;
        _tmpdt = nil;
        
        if (_compressimg != nil) {
            NSData *imageData = UIImageJPEGRepresentation(_compressimg, 1);
            md5code = [MD5Util md5WithData:imageData];
            
            NSFileManager *filemng = [NSFileManager defaultManager];
            [filemng createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            _fullpath = [NSString stringWithFormat:@"%@/%@.jpg",path,md5code];
            BOOL result = [imageData writeToFile:_fullpath atomically:YES];
            if (!result) {
                NSLog(@"try to write file <%@.jpg> to path \"%@\" failed.",md5code,_fullpath);
                _fullpath = nil;
            }
            image = nil;
            imageData = nil;
        }
    }
    return _fullpath;
}


+ (BOOL)removeImageInPath:(NSString *)path{
    BOOL result = YES;
    NSFileManager *filemng = [NSFileManager defaultManager];
    if([filemng fileExistsAtPath:path]){
        NSError *error;
        result = [filemng removeItemAtPath:path error:&error];
        if (!result && error) {
            NSLog(@"%@",error.description);
        }
    }
    return result;
}

@end
