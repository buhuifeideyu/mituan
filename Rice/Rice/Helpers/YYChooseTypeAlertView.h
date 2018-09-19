//
//  YYChooseTypeAlertView.h
//  YYFramework
//
//  Created by 李永 on 2017/5/23.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YYChooseTypeAlertView;
@protocol YYChooseTypeAlertViewDelegate <NSObject>
- (void)chooseTypeAlertView:(YYChooseTypeAlertView *)alertView didSelectedIndex:(NSInteger)index;
@optional
- (void)chooseTypeAlertViewWillDisappear:(YYChooseTypeAlertView *)alertView;
@end
//弹出类型选择框
@interface YYChooseTypeAlertView : UIView
- (instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArr;
- (void)showChooseTypeView;
- (void)hideChooseTypeView;
@property(nonatomic,assign)id<YYChooseTypeAlertViewDelegate>delegate;
@end
