//
//  YYEditView.h
//  YYFramework
//
//  Created by YYC on 16/6/29.
//  Copyright © 2016年 YueYun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnTextBlock)(NSString *text);

@interface YYEditView : UIView

@property (copy,nonatomic) ReturnTextBlock returnTextBlock;

- (void)showEditViewWithTitil:(NSString *)title;

- (void)showEditViewWithTitil:(NSString *)title andName:(NSString *)name canBeEmpty:(BOOL)empty;

- (void)showSelectViewWithTitil:(NSString *)title callbBack:(void (^)(UIButton * button))callBack;


@property (assign,nonatomic) BOOL isPhone;// 是不是要进行手机号码判断

@property (assign,nonatomic) BOOL isTel;// 是不是要进行电话号码判断

@property (assign,nonatomic) BOOL isEmail;// 是不是要进行邮箱号码判断

@property (assign,nonatomic) BOOL isUrl;// 是不是要进行网址判断

@end
