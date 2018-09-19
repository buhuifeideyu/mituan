//
//  RJMoreStoriesCollectionReusableView.h
//  Rice
//
//  Created by 李永 on 2018/9/10.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RJBannerInfo.h"

@interface RJMoreStoriesCollectionReusableView : UICollectionReusableView<ZYBannerViewDataSource>

@property (nonatomic,strong,readonly) ZYBannerView *bannerView;

@property (nonatomic,strong) NSArray<RJBannerInfo *> *datas;

@end
