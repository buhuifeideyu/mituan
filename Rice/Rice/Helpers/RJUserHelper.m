//
//  RJUserHelper.m
//  Rice
//
//  Created by 李永 on 2018/9/6.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJUserHelper.h"
#import "QLFMDBHelper.h"

@implementation RJUserHelper

@synthesize currUserInfo = _currUserInfo;
@synthesize token = _token;
@synthesize memberId = _memberId;
@synthesize isLogin = _isLogin;
@synthesize lastLoginUserInfo = _lastLoginUserInfo;
@synthesize autoLoginEnable = _autoLoginEnable;
@synthesize lastLoginType = _lastLoginType;
@synthesize expertModel = _expertModel;
@synthesize expertModelArr = _expertModelArr;

static RJUserHelper *_shareInstance;
#define kLastLoginUserInfo @"kRJLastLoginUserInfo"
#define kAutoLoginEnable @"kRJUserHelper_AutoLoginEnable"
#define kLastLoginType @"kRJUserHelper_LastLoginType"
#define kCurrUserInfo @"kRJCurrUserInfos"
#define kCurrToken @"kRJCurrTokenKey"

+ (instancetype)shareInstance{
    if (_shareInstance) {
        return _shareInstance;
    }
    _shareInstance = [[RJUserHelper alloc] init];
    
    return _shareInstance;
}

- (id)init{
    self = [super init];
    if (self) {
        _expertModelArr = [NSMutableArray array];
        _isLogin = NO;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _autoLoginEnable = [ud boolForKey:kAutoLoginEnable];
        NSString *_lastUserInfoJson = [ud stringForKey:kLastLoginUserInfo];
        if (_lastUserInfoJson) {
            NSDictionary *dic = [_lastUserInfoJson objectFromJSONString];
            _lastLoginUserInfo = [[RJUserModel alloc] init];
            [_lastLoginUserInfo initWithDictionary:dic];
        }
        NSInteger loginType = [ud integerForKey:kLastLoginType];
        switch (loginType) {
            case RJLoginType_PhoneNumber:
                _lastLoginType = RJLoginType_PhoneNumber;
                break;
            case RJLoginType_WeChat:
                _lastLoginType = RJLoginType_WeChat;
                break;
            case RJLoginType_TencentQQ:
                _lastLoginType = RJLoginType_TencentQQ;
                break;
        }
        //        if (_lastLoginType != YYLoginType_PhoneNumber) {
        _token = [ud stringForKey:kCurrToken];
        _isLogin = _autoLoginEnable;
        //        }
    }
    return self;
}

- (void)setToken:(NSString *)token{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (token) {
        _token = [token copy];
        [ud setObject:_token forKey:kCurrToken];
    }else{
        [ud removeObjectForKey:kCurrToken];
    }
    [ud synchronize];
}

- (void)setLastLoginType:(RJLoginType )lastLoginType{
    _lastLoginType = lastLoginType;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:_lastLoginType forKey:kLastLoginType];
    [ud synchronize];
}

- (void)setAutoLoginEnable:(BOOL)autoLoginEnable{
    _autoLoginEnable = autoLoginEnable;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:_autoLoginEnable forKey:kAutoLoginEnable];
    [ud synchronize];
}

- (void)setLastLoginUserInfo:(RJUserModel *)lastLoginUserInfo{
    _lastLoginUserInfo = lastLoginUserInfo;
    if (_lastLoginUserInfo) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *json = [_lastLoginUserInfo toJsonString];
        [ud setObject:json forKey:kLastLoginUserInfo];
        [ud synchronize];
    }
}

- (RJUserModel *)currUserInfo{
    if (_currUserInfo == nil && _isLogin == YES) {
        //处理YYUserModel意外丢失情况
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *json = [ud stringForKey:kCurrUserInfo];
        if (json) {
            NSDictionary *dic = [json objectFromJSONString];
            _currUserInfo = [[RJUserModel alloc] init];
            [_currUserInfo initWithDictionary:dic];
        }
    }
    return _currUserInfo;
}


- (void)userLogout{
    _currUserInfo = nil;
    [self setToken:nil];
    _memberId = nil;
    _isLogin = NO;
    [self setLastLoginUserInfo:_currUserInfo];
    [self setAutoLoginEnable:NO];

    
    [kUserDefaults setObject:@"" forKey:@"RJuser_id"];
    [kUserDefaults setObject:@"" forKey:@"RJhead"];
    [kUserDefaults setObject:@"" forKey:@"RJnickName"];
    [kUserDefaults setObject:@"" forKey:@"RJtoken"];
    [kUserDefaults setObject:@"" forKey:kLastLoginUserInfo];
    [kUserDefaults removeObjectForKey:kLastLoginUserInfo];
    [kUserDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRJUserInfoUpdateNotification object:nil];
    if (self.updateBlock) {
        self.updateBlock(nil);
    }
}

- (BOOL)loginWithResultInfo:(NSDictionary *)result loginType:(RJLoginType)loginType{
    if (!result) {
        return NO;
    }
    NSDictionary *root = [result objectForKey:@"data"];
    
    if (root && root.count > 0) {
        NSDictionary *userInfo = root;
        _currUserInfo = [[RJUserModel alloc] init];
        [_currUserInfo initWithDictionary:userInfo];
        [self setToken:_currUserInfo.token];
        _memberId = [_currUserInfo.user_id copy];
        _isLogin = YES;
        
        [self setLastLoginType:loginType];
        [self setLastLoginUserInfo:_currUserInfo];
        //        [JPUSHService setAlias:_memberId callbackSelector:nil object:nil];
        
        [kUserDefaults setObject:_currUserInfo.user_id forKey:@"RJuser_id"];
        [kUserDefaults setObject:_currUserInfo.head forKey:@"RJhead"];
        [kUserDefaults setObject:_currUserInfo.nickname forKey:@"RJnickname"];
        [kUserDefaults setObject:_currUserInfo.phone forKey:@"RJphone"];
        [kUserDefaults setObject:@"" forKey:@"RJpassword"];
        [kUserDefaults setObject:_currUserInfo.token forKey:@"RJtoken"];
        [kUserDefaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kRJUserInfoUpdateNotification object:nil];
        if (self.updateBlock) {
            self.updateBlock(_currUserInfo);
        }
        return YES;
    }
    return NO;
}

- (BOOL)updateUserInfo:(NSDictionary *)result{
    if (!result) {
        return NO;
    }
    NSDictionary *root = [result objectForKey:@"data"];
    
    
    if (root && root.count > 0) {
        NSDictionary *userInfo = root;
        _currUserInfo = [[RJUserModel alloc] init];
        [_currUserInfo initWithDictionary:userInfo];
        if (_currUserInfo.token) {
            [self setToken:_currUserInfo.token];
        }
        _memberId = [_currUserInfo.user_id copy];
        _isLogin = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kRJUserInfoUpdateNotification object:nil];
        if (self.updateBlock) {
            self.updateBlock(_currUserInfo);
        }
        return YES;
    }
    return NO;
}

- (void)synUserInfoToUserDefault{
    if (_currUserInfo) {
        [self setLastLoginUserInfo:_currUserInfo];
        NSString *json = [_currUserInfo toJsonString];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:json forKey:kCurrUserInfo];
        [ud synchronize];
    }
}

- (void)asynUserInfoFromServer{
    [RJHttpRequest postUserInfoCallback:^(NSDictionary *result) {
        if (result && result[@"success"]) {
            NSDictionary *temp = [result objectForKey:@"data"];
            if (temp && temp.count > 0) {
                RJUserModel *model = [[RJUserModel alloc] init];
                [model initWithDictionary:temp];
                [[RJUserHelper shareInstance] updateUserInfo:result];
                [kUserDefaults setObject:model.head forKey:@"RJhead"];
                [kUserDefaults synchronize];
                [self synUserInfoToUserDefault];
                [[NSNotificationCenter defaultCenter] postNotificationName:kRJUserInfoUpdateNotification object:nil];
            }
        }
    }];
}

@end
