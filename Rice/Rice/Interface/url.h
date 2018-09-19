//
//  url.h
//  DailyLesson
//
//  Created by 李永 on 2018/6/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#ifndef url_h
#define url_h
//测试服务
#define isTestHost YES

#define kBaseUrl isTestHost == YES ? @"http://mituan.test3.ruanjiekeji.com":@"http://mituan.test3.ruanjiekeji.com"

#define kBaseImgUrl isTestHost == YES ? @"":@""


//数据请求
#define kRequestString @"9999f4699214cu6u12f7c2a1d513fe06"

//启动页
#define kStartPage @"START_BANNER"

//引导页
#define kGuidePagee @"GUIDE_BANNER"

//首页轮播
#define kHomePagee @"INDEX_BANNER"



#pragma mark ---------------------------Banner
#define kad [NSString stringWithFormat:@"%@/app/Set/ad",kBaseUrl]

#pragma mark ---------------------------登录注册
#pragma mark ---获取验证码
#define kRegist [NSString stringWithFormat:@"%@/app/Login/phoneCode",kBaseUrl]

#pragma mark ---判断用户是否注册
#define kqueryUser [NSString stringWithFormat:@"%@/app/Login/queryUser",kBaseUrl]

#pragma mark ---登录接口
#define klogin [NSString stringWithFormat:@"%@/app/Login/login",kBaseUrl]

#pragma mark ---退出登录
#define kloginOut [NSString stringWithFormat:@"%@/app/Login/loginOut",kBaseUrl]

#pragma mark ---------------------------用户信息
#pragma mark ---个人信息
#define kUserInfo [NSString stringWithFormat:@"%@/app/User/userInfo",kBaseUrl]

#pragma mark ---修改
#define kUserSet [NSString stringWithFormat:@"%@/app/User/userSet",kBaseUrl]

#pragma mark ---修改头像
#define kUserHeadSet [NSString stringWithFormat:@"%@/app/User/userHeadSet",kBaseUrl]

#pragma mark ---上传头像
#define kImageUpLoad [NSString stringWithFormat:@"%@/app/Upload/imageUpLoad",kBaseUrl]

#pragma mark ---修改密码
#define kchangePwd [NSString stringWithFormat:@"%@/app/User/changePwd",kBaseUrl]

#pragma mark ---第三方绑定登录
#define kloginBind [NSString stringWithFormat:@"%@/app/User/loginBind",kBaseUrl]

#pragma mark ---第三方解绑登录
#define kloginUnBind [NSString stringWithFormat:@"%@/app/User/loginUnBind",kBaseUrl]

#pragma mark ---APP手机绑定
#define kphoneBind [NSString stringWithFormat:@"%@/app/app/User/phoneBind",kBaseUrl]


#pragma mark ---------------------------消息
#pragma mark ---消息列表
#define kMessageList [NSString stringWithFormat:@"%@/app/Message/messageList",kBaseUrl]

#pragma mark ---未读消息
#define kUnReadCount [NSString stringWithFormat:@"%@/app/Message/unReadCount",kBaseUrl]

#pragma mark ---消息读取
#define kMessageRead [NSString stringWithFormat:@"%@/app/Message/messageRead",kBaseUrl]

#pragma mark ---消息删除
#define kMessageDel [NSString stringWithFormat:@"%@/app/Message/messageDel",kBaseUrl]

#pragma mark ---------------------------故事
#pragma mark ---故事首页
#define kstoryIndex [NSString stringWithFormat:@"%@/app/Story/storyIndex",kBaseUrl]

#pragma mark ---专辑列表
#define kalbumList [NSString stringWithFormat:@"%@/app/Story/albumList",kBaseUrl]

#pragma mark ---专辑详情
#define kalbumDetail [NSString stringWithFormat:@"%@/app/Story/albumDetail",kBaseUrl]

#pragma mark ---故事列表
#define kstoryList [NSString stringWithFormat:@"%@/app/Story/storyList",kBaseUrl]

#pragma mark ---故事详情
#define kstoryDetail [NSString stringWithFormat:@"%@/app/Story/storyDetail",kBaseUrl]

#pragma mark ---故事标签列表
#define klabelList [NSString stringWithFormat:@"%@/app/Story/labelList",kBaseUrl]

#pragma mark ---点赞添加
#define klikeAdd [NSString stringWithFormat:@"%@/app/Story/likeAdd",kBaseUrl]

#pragma mark ---点赞删除
#define klikeDel [NSString stringWithFormat:@"%@/app/Story/likeDel",kBaseUrl]

#pragma mark ---收藏添加
#define kcollectAdd [NSString stringWithFormat:@"%@/app/Story/collectAdd",kBaseUrl]

#pragma mark ---收藏删除
#define kcollectDel [NSString stringWithFormat:@"%@/app/Story/collectDel",kBaseUrl]

#pragma mark ---热门搜索
#define khotSearch [NSString stringWithFormat:@"%@/app/Story/hotSearch",kBaseUrl]

#pragma mark ---用户收听历史记录
#define kuserListenRecord [NSString stringWithFormat:@"%@/app/Story/userListenRecord",kBaseUrl]


#pragma mark ---------------------------家庭
#pragma mark ---家庭列表
#define kfamilyList [NSString stringWithFormat:@"%@/app/Family/familyList",kBaseUrl]

#pragma mark ---家庭添加
#define kfamilyAdd [NSString stringWithFormat:@"%@/app/Family/familyAdd",kBaseUrl]

#pragma mark ---家庭修改
#define kfamilyEdit [NSString stringWithFormat:@"%@/app/Family/familyEdit",kBaseUrl]

#pragma mark ---家庭删除
#define kfamilyDel [NSString stringWithFormat:@"%@/app/Family/familyDel",kBaseUrl]

#pragma mark ---小孩列表
#define kchildList [NSString stringWithFormat:@"%@/app/Family/childList",kBaseUrl]

#pragma mark ---小孩添加
#define kchildAdd [NSString stringWithFormat:@"%@/app/Family/childAdd",kBaseUrl]

#pragma mark ---小孩修改
#define kchildEdit [NSString stringWithFormat:@"%@/app/Family/childEdit",kBaseUrl]

#pragma mark ---小孩头像
#define kchildHeadEdit [NSString stringWithFormat:@"%@/app/Family/childHeadEdit",kBaseUrl]

#pragma mark ---小孩绑定硬件
#define kchildHardEdit [NSString stringWithFormat:@"%@/app/Family/childHardEdit",kBaseUrl]

#pragma mark ---小孩删除
#define kchildDel [NSString stringWithFormat:@"%@/app/Family/childDel",kBaseUrl]

#pragma mark ---家庭成员列表
#define kfamilyMemberList [NSString stringWithFormat:@"%@/app/Family/familyMemberList",kBaseUrl]

#pragma mark ---家庭成员修改
#define kfamilyMemberEdit [NSString stringWithFormat:@"%@/app/Family/familyMemberEdit",kBaseUrl]

#pragma mark ---家庭成员头像
#define kfamilyMemberHeadEdit [NSString stringWithFormat:@"%@/app/Family/familyMemberHeadEdit",kBaseUrl]

#pragma mark ---家庭成员退出
#define kfamilyMemberQuit [NSString stringWithFormat:@"%@/app/Family/familyMemberQuit",kBaseUrl]

#pragma mark ---家庭成员删除(管理员)
#define kfamilyMemberDel [NSString stringWithFormat:@"%@/app/Family/familyMemberDel",kBaseUrl]

#pragma mark ---宝宝关系
#define krelationList [NSString stringWithFormat:@"%@/app/Family/relationList",kBaseUrl]

#pragma mark ---------------------------配置信息
#pragma mark ---配置信息
#define kappConfig [NSString stringWithFormat:@"%@/app/Set/appConfig",kBaseUrl]

#pragma mark ---用户添加反馈
#define kfeedbackAdd [NSString stringWithFormat:@"%@/app/Set/feedbackAdd",kBaseUrl]

#pragma mark ---------------------------评论
#pragma mark ---评论列表
#define kcommentList [NSString stringWithFormat:@"%@/app/Comment/commentList",kBaseUrl]

#pragma mark ---评论添加
#define kcommentAdd [NSString stringWithFormat:@"%@/app/Comment/commentAdd",kBaseUrl]

#pragma mark ---评论删除
#define kcommentDel [NSString stringWithFormat:@"%@/app/Comment/commentDel",kBaseUrl]


#pragma mark ---------------------------分享
#pragma mark ---分享
#define kshareInfo [NSString stringWithFormat:@"%@/app/Share/shareInfo",kBaseUrl]

#pragma mark ---------------------------VIP
#pragma mark ---vip购买
#define krecharge [NSString stringWithFormat:@"%@/app/Vip/recharge",kBaseUrl]


#endif /* url_h */
