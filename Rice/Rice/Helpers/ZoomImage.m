//
//  ZoomImage.m
//  DailyLesson
//
//  Created by 李永 on 2018/6/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "ZoomImage.h"
#import "YYUIButton.h"



@implementation ZoomImage

static CGRect oldframe;

+(void)showImage:(UIImageView *)avatarImageView{
    
    UIImage *image=avatarImageView.image;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    
    backgroundView.backgroundColor = [UIColor blackColor];
    
    backgroundView.alpha = 0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.5f animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
    
}

+(void)showAndDownloadImage:(UIImageView *)avatarImageView Target:(id)Target action:(SEL)action index:(NSInteger)index tag:(NSInteger)tag{
    
    UIImage *image=avatarImageView.image;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    
    backgroundView.backgroundColor = [UIColor blackColor];
    
    backgroundView.alpha = 0;
    
    YYUIButton *downLoadBtn = [YYUIButton buttonWithType:UIButtonTypeCustom];
    downLoadBtn.frame = CGRectMake(KScreenWidth-140, 20, 120, 44);
    downLoadBtn.layer.masksToBounds = YES;
    downLoadBtn.layer.borderWidth = 1;
    downLoadBtn.layer.borderColor = [[UIColor whiteColor]CGColor];
    downLoadBtn.layer.cornerRadius = 5;
    downLoadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    downLoadBtn.titleLabel.textColor = [UIColor whiteColor];
    [downLoadBtn setTitle:@"点击下载图片" forState:UIControlStateNormal];
    downLoadBtn.handler = index;
    downLoadBtn.tag = tag;
    [downLoadBtn addTarget:Target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    [backgroundView addSubview:downLoadBtn];
    
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.5f animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
    
}

+(void)showImage:(UIImageView *)avatarImageView isHold:(BOOL)isHold longTapTarget:(id)Target action:(SEL)action BGV:(UIView *)backgroundView{
    
    UIImage *image=avatarImageView.image;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    
    backgroundView.backgroundColor = [UIColor blackColor];
    
    backgroundView.alpha = 0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    if (isHold) {
        UILongPressGestureRecognizer *lognTap = [[UILongPressGestureRecognizer alloc]initWithTarget:Target action:action];
        lognTap.minimumPressDuration = 1.0f;
        [backgroundView addGestureRecognizer:lognTap];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
    
}

+(void)ChangeAndshowImage:(UIImageView *)avatarImageView Target:(id)Target takePhotoAction:(SEL)takePhoto ChoosePhotoAction:(SEL)ChoosePhoto{
    
    UIImage *image=avatarImageView.image;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    
    backgroundView.backgroundColor = [UIColor blackColor];
    
    backgroundView.alpha = 0;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    
    UIButton *downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downLoadBtn.frame = CGRectMake(0, KScreenWidth-50, KScreenWidth-20, 50);
    downLoadBtn.centerX = KScreenWidth*0.5f;
    downLoadBtn.layer.masksToBounds = YES;
    downLoadBtn.layer.borderWidth = 1;
    downLoadBtn.layer.borderColor = [[UIColor whiteColor]CGColor];
    downLoadBtn.layer.cornerRadius = 5;
    downLoadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    downLoadBtn.titleLabel.textColor = [UIColor whiteColor];
    [downLoadBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [downLoadBtn addTarget:Target action:takePhoto forControlEvents:UIControlEventTouchUpInside];
    
    [backgroundView addSubview:downLoadBtn];
    
    UIButton *PhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    PhotoBtn.frame = CGRectMake(0, KScreenHeight-105, KScreenWidth-20, 50);
    PhotoBtn.centerX = KScreenWidth*0.5f;
    PhotoBtn.layer.masksToBounds = YES;
    PhotoBtn.layer.borderWidth = 1;
    PhotoBtn.layer.borderColor = [[UIColor whiteColor]CGColor];
    PhotoBtn.layer.cornerRadius = 5;
    PhotoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    PhotoBtn.titleLabel.textColor = [UIColor whiteColor];
    [PhotoBtn setTitle:@"相册" forState:UIControlStateNormal];
    [PhotoBtn addTarget:Target action:ChoosePhoto forControlEvents:UIControlEventTouchUpInside];
    
    [backgroundView addSubview:PhotoBtn];
    
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.5f animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
    
}

//单击返回
+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

@end
