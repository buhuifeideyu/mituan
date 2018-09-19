//
//  RJUserHelper.h
//  Rice
//
//  Created by 李永 on 2018/9/6.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRJUserInfoUpdateNotification @"kRJUserInfoUpdateNotification"

typedef void(^UserInfoUpdateBlock)(RJUserModel *userInfo);

typedef enum{
    RJLoginType_PhoneNumber = 0,
    RJLoginType_WeChat = 1,
    RJLoginType_TencentQQ = 2
}RJLoginType;

@interface RJUserHelper : NSObject

@property (nonatomic,assign) BOOL autoLoginEnable;

@property (nonatomic,readonly) RJLoginType lastLoginType;
@property (nonatomic,readonly) RJUserModel *currUserInfo;
@property (nonatomic,readonly) NSString *token;
@property (nonatomic,readonly) NSString *memberId;
@property (nonatomic,readonly) BOOL isLogin;
@property (nonatomic,readonly) RJUserModel *lastLoginUserInfo;
@property (nonatomic,copy) UserInfoUpdateBlock updateBlock;

@property (nonatomic,strong) RJUserModel *expertModel;

@property (nonatomic,strong) NSMutableArray *expertModelArr;

+ (instancetype)shareInstance;

/**
 用户退出登录（清空本地用户基本信息）
 */
- (void)userLogout;


/**
 登录用户
 
 @param result 登录信息
 @param loginType 登录类型
 @return 是否处理成功
 */
- (BOOL)loginWithResultInfo:(NSDictionary *)result loginType:(RJLoginType)loginType;


/**
 更新用户信息（不会更新用户的登录类型）
 
 @param result 登录返回结果
 @return 是否处理成功
 */
- (BOOL)updateUserInfo:(NSDictionary *)result;


/**
 持久化当前用户信息到UserDefault
 */
- (void)synUserInfoToUserDefault;

/**
 从服务器同步数据
 */
- (void)asynUserInfoFromServer;

@end
