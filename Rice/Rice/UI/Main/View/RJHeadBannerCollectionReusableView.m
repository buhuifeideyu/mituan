//
//  RJHeadBannerCollectionReusableView.m
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJHeadBannerCollectionReusableView.h"

@implementation RJHeadBannerCollectionReusableView
{
    UIImage *defaultImage;
    
    UIImageView *_messageImage;
    
    UILabel *_messageLabel;
    
    UILabel *_meAttentionLabel;
}

@synthesize headView = _headView;

@synthesize datas = _datas;

@synthesize bannerView = _bannerView;

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self setupView];
}


- (void)setupView{
    if (!defaultImage) {
        defaultImage = KStartDefaultImage;
    }
    
    if (_bannerView) {
        [_bannerView stopTimer];
        _bannerView = nil;
    }
    
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kHomeBannerHeight)];
    [self addSubview:_headView];
    
    _bannerView = [[ZYBannerView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kHomeBannerHeight)];
    _bannerView.shouldLoop = YES;
    _bannerView.autoScroll = YES;
    _bannerView.scrollInterval = 3.0f;
    _bannerView.dataSource = self;
    [_headView addSubview:_bannerView];
    
    
}

- (void)setDatas:(NSArray<RJBannerInfo *> *)datas{
    _datas = datas;
    [_bannerView reloadData];
}

#pragma --mark
#pragma mark ZYBannerViewDataSource
- (NSInteger)numberOfItemsInBanner:(ZYBannerView *)banner{
    if (_datas) {
        return [_datas count];
    }
    return 0;
}

- (void)bannerDisplayForItemAtIndex:(NSInteger)index {
//    YYBannerAdsInfo *info = [_datas objectAtIndex:index];
//    _titleLabel.text = [NSString stringWithFormat:@"  %@  ", info.descr];
}

- (UIView *)banner:(ZYBannerView *)banner viewForItemAtIndex:(NSInteger)index{
    RJBannerInfo *info = [_datas objectAtIndex:index];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, kHomeBannerHeight)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    if (info.pic) {
        NSString *imgUrlStr = [NSString stringWithFormat:@"%@%@",kBaseUrl,info.pic];
        NSString * urlString = [imgUrlStr stringByRemovingPercentEncoding];
        NSURL *imgUrl = [NSURL URLWithString:urlString];
        [imgView sd_setImageWithURL:imgUrl placeholderImage:defaultImage];
    }else if (info.pic_name) {
        imgView.image = [UIImage imageNamed:info.pic_name];
    }
    return imgView;
}

@end
