//
//  RJUserModel.h
//  Rice
//
//  Created by 李永 on 2018/9/6.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RJUserModel : NSObject

@property (nonatomic,copy) NSString *user_id;//用户ID

@property (nonatomic,copy) NSString *token;

@property (nonatomic,copy) NSString *id;//用户id

@property (nonatomic,copy) NSString *user_name;//账号

@property (nonatomic,copy) NSString *company_code;//公司代码

@property (nonatomic,copy) NSString *phone;//手机号

@property (nonatomic,copy) NSString *head;//头像

@property (nonatomic,copy) NSString *nickname;//昵称

@property (nonatomic,assign) NSInteger sex;//性别 0未知1男2女

@property (nonatomic,copy) NSString *money;//余额

@property (nonatomic,copy) NSString *score;//积分

@property (nonatomic,copy) NSString *auth;//认证(0:未认证,1: 已认证,2:申请中)

@property (nonatomic,copy) NSString *birthday;//生日(年-月-日)

@property (nonatomic,copy) NSString *add_time;//注册时间

@property (nonatomic,copy) NSString *sign;//签名

@property (nonatomic,copy) NSString *job;//工作

@property (nonatomic,copy) NSString *info;//个人介绍

@property (nonatomic,copy) NSString *province;//省ID

@property (nonatomic,copy) NSString *city;//市ID

@property (nonatomic,copy) NSString *district;//区ID

@property (nonatomic,copy) NSString *now_city;//所在市ID

@property (nonatomic,copy) NSString *province_name;//省

@property (nonatomic,copy) NSString *city_name;//市

@property (nonatomic,copy) NSString *district_name;//区

@property (nonatomic,copy) NSString *now_city_name;//所在市

@property (nonatomic,copy) NSString *pay_password_exist;//是否存在支付密码(0:否,1:是)

@property (nonatomic,copy) NSString *is_bind_phone;//是否绑定手机(0:否,1:是)

@property (nonatomic,copy) NSString *is_bind_wechat;//是否绑定微信(0:否,1:是)

@property (nonatomic,copy) NSString *is_bind_qq;//是否绑定QQ(0:否,1:是)

@property (nonatomic,copy) NSString *is_bind_weibo;//是否绑定微博(0:否,1:是)

@property (nonatomic,copy) NSString *vip_end_time;//VIP结束时间

@property (nonatomic,copy) NSString *is_vip;//是否VIP(0:否,1:是)

@end
