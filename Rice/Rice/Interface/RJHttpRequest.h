//
//  RJHttpRequest.h
//  Rice
//
//  Created by 李永 on 2018/9/4.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RJHttpRequest : NSObject

+ (NSDictionary*)signDic:(NSDictionary*)dic;

+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

#pragma mark ---------------------------Banner
+ (void)postAdWithPosition:(NSString *)position callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---------------------------登录注册
#pragma mark ---获取验证码
+ (void)postPhoneCode:(NSString *)phone type:(NSInteger )type callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---查询是否注册
+ (void)postQueryUser:(NSString *)phone callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---登录接口
+ (void)postLogin:(NSString *)action_type phone:(NSString *)phone code:(NSString *)code password:(NSString *)password type:(NSInteger )type openid:(NSString *)openid access_token:(NSString *)access_token uid:(NSString *)uid callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---退出登录
+ (void)postLoginOutCallback:(void(^)(NSDictionary *result))callback;

#pragma mark ---------------------------用户信息
#pragma mark ---个人信息
+ (void)postUserInfoCallback:(void(^)(NSDictionary *result))callback;

#pragma mark ---修改
+ (void)postUserSetWithEmain:(NSString *)email  nickname:(NSString *)nickname sex:(NSInteger )sex birthday:(NSString *)birthday sign:(NSString *)sign  job:(NSString *)job  info:(NSString *)info  province:(NSString *)province city:(NSString *)city now_city:(NSString *)now_city callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---用户头像
+ (void)postUserHeadSetWithHead:(NSString *)head  callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---------------------------消息
#pragma mark ---消息列表
+ (void)postMessageListWithPage:(NSInteger )page type:(NSInteger )type callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---未读消息
+ (void)postUnReadCountCallback:(void(^)(NSDictionary *result))callback;

#pragma mark ---消息读取
+ (void)postMessageReadWithMessgeId:(NSInteger )messageId callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---消息删除
+ (void)postMessageDelWithMessgeId:(NSInteger )messageId callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---------------------------故事
#pragma mark ---故事首页
+ (void)postStoryIndexWithPage:(NSInteger )page callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---专辑列表
+ (void)postAlbumListWithPage:(NSInteger )page keyword:(NSString *)keyword callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---专辑详情
+ (void)postAlbumDetailWithAlbumId:(NSInteger )albumId callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---故事列表
+ (void)postStoryListWithPage:(NSInteger )page recommend:(NSInteger )recommend album_id:(NSInteger )album_id story_type:(NSInteger )story_type label:(NSInteger )label keyword:(NSString *)keyword callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---故事详情
+ (void)postStoryDetailWithStoryId:(NSInteger )storyId callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---故事标签列表
+ (void)postLabelListWithPage:(NSInteger )page callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---点赞添加
+ (void)postLikeAddWithStory_id:(NSInteger )story_id callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---点赞删除
+ (void)postLikeDelWithStory_id:(NSInteger )story_id callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---收藏添加
+ (void)postCollectAddWithAlbum_id:(NSString *)album_id callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---收藏删除
+ (void)postCollectDelWithAlbum_id:(NSString *)album_id callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---热门搜索
+ (void)postHotSearchCallback:(void(^)(NSDictionary *result))callback;

#pragma mark ---用户收听历史记录
+ (void)postUserListenRecordWithPage:(NSInteger )page child_id:(NSInteger )child_id time_type:(NSInteger )time_type callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---------------------------家庭
#pragma mark ---家庭列表
+ (void)postFamilyListCallback:(void(^)(NSDictionary *result))callback;

#pragma mark ---家庭添加
+ (void)postFamilyAddWithMember_relation:(NSString *)member_relation child_sex:(NSInteger )child_sex child_birth:(NSString *)child_birth callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---家庭修改
+ (void)postFamilyEditWithFamily_id:(NSInteger )family_id family_name:(NSString *)family_name callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---家庭删除
+ (void)postFamilyDelWithFamily_id:(NSInteger )family_id callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---小孩列表
+ (void)postChildListWithFamily_id:(NSInteger )family_id callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---小孩添加
+ (void)postChildAddWithFamily_id:(NSInteger )family_id sex:(NSInteger )sex birth:(NSString *)birth callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---小孩修改
+ (void)postChildEditWithChild_id:(NSInteger )child_id sex:(NSInteger )sex birth:(NSString *)birth child_name:(NSString *)child_name device:(NSString *)device  callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---小孩头像
+ (void)postChildHeadEditWithChild_id:(NSInteger )child_id head:(NSString *)head  callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---小孩绑定硬件
+ (void)postChildHardEditWithChild_id:(NSInteger )child_id device:(NSString *)device  callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---小孩删除
+ (void)postChildDelWithChild_id:(NSInteger )child_id callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---家庭成员列表
+ (void)postFamilyMemberListWithFamily_id:(NSInteger )family_id callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---家庭成员修改
+ (void)postFamilyMemberEditWithMember_id:(NSInteger )member_id nickname:(NSString *)nickname relation:(NSString *)relation sex:(NSInteger )sex  callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---家庭成员头像
+ (void)postFamilyMemberHeadEditWithMember_id:(NSInteger )member_id head:(NSString *)head callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---家庭成员退出
+ (void)postFamilyMemberQuitWithFamily_id:(NSInteger )family_id callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---家庭成员删除(管理员)
+ (void)postFamilyMemberDelWithMember_id:(NSInteger )member_id callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---宝宝关系
+ (void)postRelationListCallback:(void(^)(NSDictionary *result))callback;

#pragma mark ---------------------------配置信息
#pragma mark ---配置信息
+ (void)postAppConfigCallback:(void(^)(NSDictionary *result))callback;

#pragma mark ---用户添加反馈
+ (void)postFeedbackAddWithContent:(NSString *)content contact:(NSString *)contact image:(NSString *)image callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---------------------------评论
#pragma mark ---评论列表
+ (void)postCommentListWithPage:(NSInteger )page story_id:(NSInteger )story_id callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---评论添加
+ (void)postCommentAddWithStory_id:(NSInteger )story_id content:(NSString *)content callback:(void(^)(NSDictionary *result))callback;

#pragma mark ---评论删除
+ (void)postCommentDelWithComment_id:(NSInteger )comment_id callback:(void(^)(NSDictionary *result))callback;

@end
