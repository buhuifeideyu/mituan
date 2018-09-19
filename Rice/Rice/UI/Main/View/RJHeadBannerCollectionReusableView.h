//
//  RJHeadBannerCollectionReusableView.h
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYBannerView.h"
#import "RJBannerInfo.h"

@interface RJHeadBannerCollectionReusableView : UICollectionReusableView<ZYBannerViewDataSource>

@property (nonatomic,strong,readonly) UIView *headView;

@property (nonatomic,strong,readonly) ZYBannerView *bannerView;

@property (nonatomic,strong) NSArray<RJBannerInfo *> *datas;

@end
