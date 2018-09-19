//
//  RJHttpRequest.m
//  Rice
//
//  Created by 李永 on 2018/9/4.
//  Copyright © 2018年 RJ. All rights reserved.
//

#import "RJHttpRequest.h"
#import "url.h"
#import "QLAFHttpRequestOperationManager.h"
#import "QLCacheManager.h"
#import "MD5Util.h"
#import "QLNetworkResponse.h"
#import "JSONKit.h"
#import "YYImageHelper.h"

@implementation RJHttpRequest : NSObject

+(NSDictionary*)signDic:(NSDictionary*)dic {
    NSString *jsonStr = nil;
    if (dic) {
        jsonStr = [self dictionaryToJson:dic];
    }else{
        jsonStr = @"";
    }
    NSString *signStr = [MD5Util MD5:[NSString stringWithFormat:@"%@%@",kRequestString,jsonStr]];
    return @{@"data":jsonStr,@"apisign":signStr};
}

//字典NSDictionary转成Json字符串
+ (NSString *)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = [NSError new];
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString * jsonstr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonstr;
}

#pragma mark ---------------------------Banner
+ (void)postAdWithPosition:(NSString *)position callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:position forKey:@"position"];//START_BANNER:启动页,GUIDE_BANNER:引导页
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kad param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---------------------------登录注册
#pragma mark ---获取验证码
+ (void)postPhoneCode:(NSString *)phone type:(NSInteger )type callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setInterge:type forKey:@"type"];
    [param ql_setObject:phone forKey:@"phone"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kRegist param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---查询是否注册
+ (void)postQueryUser:(NSString *)phone callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:phone forKey:@"phone"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kqueryUser param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

+ (void)postLogin:(NSString *)action_type phone:(NSString *)phone code:(NSString *)code password:(NSString *)password type:(NSInteger )type openid:(NSString *)openid access_token:(NSString *)access_token uid:(NSString *)uid callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:action_type forKey:@"action_type"];
    [param ql_setObject:phone forKey:@"phone"];
    [param ql_setObject:code forKey:@"code"];
    [param ql_setObject:password forKey:@"password"];
    [param ql_setInterge:type forKey:@"type"];
    [param ql_setObject:openid forKey:@"openid"];
    [param ql_setObject:access_token forKey:@"access_token"];
    [param ql_setObject:uid forKey:@"uid"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:klogin param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---退出登录
+ (void)postLoginOutCallback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kloginOut param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---------------------------用户信息
#pragma mark ---个人信息
+ (void)postUserInfoCallback:(void(^)(NSDictionary *result))callback {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kUserInfo param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---修改
+ (void)postUserSetWithEmain:(NSString *)email  nickname:(NSString *)nickname sex:(NSInteger )sex birthday:(NSString *)birthday sign:(NSString *)sign  job:(NSString *)job  info:(NSString *)info  province:(NSString *)province city:(NSString *)city now_city:(NSString *)now_city callback:(void(^)(NSDictionary *result))callback {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setObject:email forKey:@"email"];
    [param ql_setObject:nickname forKey:@"nickname"];
    [param ql_setInterge:sex forKey:@"sex"];
    [param ql_setObject:birthday forKey:@"birthday"];
    [param ql_setObject:job forKey:@"job"];
    [param ql_setObject:info forKey:@"info"];
    [param ql_setObject:province forKey:@"province"];
    [param ql_setObject:city forKey:@"city"];
    [param ql_setObject:now_city forKey:@"now_city"];
    
    NSDictionary *paramDic = [self signDic:param];
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kUserSet param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---用户头像
+ (void)postUserHeadSetWithHead:(NSString *)head  callback:(void(^)(NSDictionary *result))callback {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setObject:head forKey:@"head"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kUserHeadSet param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---------------------------消息
#pragma mark ---消息列表
+ (void)postMessageListWithPage:(NSInteger )page type:(NSInteger )type callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:page forKey:@"page"];
//    [param ql_setInterge:type forKey:@"type"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kMessageList param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---未读消息
+ (void)postUnReadCountCallback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kUnReadCount param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---消息读取
+ (void)postMessageReadWithMessgeId:(NSInteger )messageId callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:messageId forKey:@"id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kMessageRead param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---消息删除

+ (void)postMessageDelWithMessgeId:(NSInteger )messageId callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:messageId forKey:@"id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kMessageDel param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---------------------------故事
#pragma mark ---故事首页
+ (void)postStoryIndexWithPage:(NSInteger )page callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:page forKey:@"page"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kstoryIndex param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---专辑列表
+ (void)postAlbumListWithPage:(NSInteger )page keyword:(NSString *)keyword callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:page forKey:@"page"];
    [param ql_setObject:keyword forKey:@"keyword"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kalbumList param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}



#pragma mark ---专辑详情
+ (void)postAlbumDetailWithAlbumId:(NSInteger )albumId callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:albumId forKey:@"id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kalbumDetail param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---故事列表
+ (void)postStoryListWithPage:(NSInteger )page recommend:(NSInteger )recommend album_id:(NSInteger )album_id story_type:(NSInteger )story_type label:(NSInteger )label keyword:(NSString *)keyword callback:(void(^)(NSDictionary *result))callback  {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:page forKey:@"page"];
    [param ql_setInterge:recommend forKey:@"recommend"];
    [param ql_setInterge:album_id forKey:@"album_id"];
    [param ql_setInterge:story_type forKey:@"story_type"];
    [param ql_setInterge:label forKey:@"label"];
    [param ql_setObject:keyword forKey:@"keyword"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kstoryList param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---故事详情
+ (void)postStoryDetailWithStoryId:(NSInteger )storyId callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:storyId forKey:@"id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kstoryDetail param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---故事标签列表
+ (void)postLabelListWithPage:(NSInteger )page callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:page forKey:@"page"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:klabelList param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---点赞添加
+ (void)postLikeAddWithStory_id:(NSInteger )story_id callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:story_id forKey:@"story_id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:klikeAdd param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---点赞删除
+ (void)postLikeDelWithStory_id:(NSInteger )story_id callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:story_id forKey:@"story_id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:klikeDel param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---收藏添加
+ (void)postCollectAddWithAlbum_id:(NSString *)album_id callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setObject:album_id forKey:@"album_id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kcollectAdd param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---收藏删除
+ (void)postCollectDelWithAlbum_id:(NSString *)album_id callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setObject:album_id forKey:@"album_id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kcollectDel param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---热门搜索
+ (void)postHotSearchCallback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:khotSearch param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---用户收听历史记录
+ (void)postUserListenRecordWithPage:(NSInteger )page child_id:(NSInteger )child_id time_type:(NSInteger )time_type callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:page forKey:@"page"];
    [param ql_setInterge:child_id forKey:@"child_id"];
    [param ql_setInterge:time_type forKey:@"time_type"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kuserListenRecord param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---------------------------家庭
#pragma mark ---家庭列表
+ (void)postFamilyListCallback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kfamilyList param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---家庭添加
+ (void)postFamilyAddWithMember_relation:(NSString *)member_relation child_sex:(NSInteger )child_sex child_birth:(NSString *)child_birth callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setObject:member_relation forKey:@"member_relation"];
    [param ql_setInterge:child_sex forKey:@"child_sex"];
    [param ql_setObject:child_birth forKey:@"child_birth"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kfamilyAdd param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---家庭修改
+ (void)postFamilyEditWithFamily_id:(NSInteger )family_id family_name:(NSString *)family_name callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:family_id forKey:@"id"];
    [param ql_setObject:family_name forKey:@"family_name"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kfamilyEdit param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---家庭删除
#define kfamilyDel [NSString stringWithFormat:@"%@/app/Family/familyDel",kBaseUrl]
+ (void)postFamilyDelWithFamily_id:(NSInteger )family_id callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:family_id forKey:@"id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kfamilyDel param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---小孩列表
+ (void)postChildListWithFamily_id:(NSInteger )family_id callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:family_id forKey:@"family_id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kchildList param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---小孩添加
+ (void)postChildAddWithFamily_id:(NSInteger )family_id sex:(NSInteger )sex birth:(NSString *)birth callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:family_id forKey:@"family_id"];
    [param ql_setInterge:sex forKey:@"sex"];
    [param ql_setObject:birth forKey:@"birth"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kchildAdd param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---小孩修改
+ (void)postChildEditWithChild_id:(NSInteger )child_id sex:(NSInteger )sex birth:(NSString *)birth child_name:(NSString *)child_name device:(NSString *)device  callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:child_id forKey:@"id"];
    [param ql_setInterge:sex forKey:@"sex"];
    [param ql_setObject:birth forKey:@"birth"];
    [param ql_setObject:child_name forKey:@"child_name"];
    [param ql_setObject:device forKey:@"device"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kchildEdit param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---小孩头像
+ (void)postChildHeadEditWithChild_id:(NSInteger )child_id head:(NSString *)head  callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:child_id forKey:@"id"];
    [param ql_setObject:head forKey:@"head"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kchildHeadEdit param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---小孩绑定硬件
+ (void)postChildHardEditWithChild_id:(NSInteger )child_id device:(NSString *)device  callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:child_id forKey:@"id"];
    [param ql_setObject:device forKey:@"device"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kchildHardEdit param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---小孩删除
+ (void)postChildDelWithChild_id:(NSInteger )child_id callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:child_id forKey:@"id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kchildDel param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---家庭成员列表
+ (void)postFamilyMemberListWithFamily_id:(NSInteger )family_id callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:family_id forKey:@"family_id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kfamilyMemberList param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---家庭成员列表修改
+ (void)postFamilyMemberEditWithMember_id:(NSInteger )member_id nickname:(NSString *)nickname relation:(NSString *)relation sex:(NSInteger )sex  callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:member_id forKey:@"id"];
    [param ql_setObject:nickname forKey:@"nickname"];
    [param ql_setObject:relation forKey:@"relation"];
    [param ql_setInterge:sex forKey:@"sex"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kfamilyMemberEdit param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---家庭成员头像
#define kfamilyMemberHeadEdit [NSString stringWithFormat:@"%@/app/Family/familyMemberHeadEdit",kBaseUrl]
+ (void)postFamilyMemberHeadEditWithMember_id:(NSInteger )member_id head:(NSString *)head callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:member_id forKey:@"id"];
    [param ql_setObject:head forKey:@"head"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kfamilyMemberHeadEdit param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---家庭成员退出
+ (void)postFamilyMemberQuitWithFamily_id:(NSInteger )family_id callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:family_id forKey:@"family_id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kfamilyMemberQuit param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---家庭成员删除(管理员)
+ (void)postFamilyMemberDelWithMember_id:(NSInteger )member_id callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:member_id forKey:@"id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kfamilyMemberDel param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---宝宝关系
+ (void)postRelationListCallback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:krelationList param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---------------------------配置信息
#pragma mark ---配置信息
+ (void)postAppConfigCallback:(void(^)(NSDictionary *result))callback {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kappConfig param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---用户添加反馈
+ (void)postFeedbackAddWithContent:(NSString *)content contact:(NSString *)contact image:(NSString *)image callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setObject:content forKey:@"content"];
    [param ql_setObject:contact forKey:@"contact"];
    [param ql_setObject:image forKey:@"image"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kfeedbackAdd param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---------------------------评论
#pragma mark ---评论列表
+ (void)postCommentListWithPage:(NSInteger )page story_id:(NSInteger )story_id callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:page forKey:@"page"];
    [param ql_setInterge:story_id forKey:@"story_id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kcommentList param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---评论添加
+ (void)postCommentAddWithStory_id:(NSInteger )story_id content:(NSString *)content callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:story_id forKey:@"story_id"];
    [param ql_setObject:content forKey:@"content"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kcommentAdd param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

#pragma mark ---评论删除
+ (void)postCommentDelWithComment_id:(NSInteger )comment_id callback:(void(^)(NSDictionary *result))callback {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:kUserID forKey:@"user_id"];
    [param ql_setObject:kToken forKey:@"token"];
    [param ql_setInterge:comment_id forKey:@"id"];
    
    NSDictionary *paramDic = [self signDic:param];
    
    QLAFHttpRequestOperationManager *requestMng = [[QLAFHttpRequestOperationManager alloc]init];
    [requestMng createRequestWithModel:TYHTTPPostModel url:kcommentDel param:paramDic callback:^(QLNetworkResponse *result) {
        if (callback) {
            id json_dic = nil;
            if (result.responseString != nil) {
                json_dic = [result.responseString objectFromJSONString];
            }
            callback(json_dic);
        }
    }];
}

@end
