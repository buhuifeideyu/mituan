//
//  QLAFHttpRequestOperationManager.h
//  TianYueMobileOA
//
//  Created by SiuJiYung on 14-1-23.
//  Copyright (c) 2014年 tianyue. All rights reserved.
//

//#import "AFHTTPRequestOperationManager.h"
#import "QLNetworkResponse.h"

enum TYAFCacheType{
    CacheDisable = 2,
    CacheNetworkFirst = 1,
    CacheCacheFirst = 0,
    CacheNormal = 0
};

enum TYHttpModel{
    TYHTTPGetModel = 1,
    TYHTTPPostModel =2
};

//数据请求状态码
typedef enum {
    TYRRC_ERROR_NETWORK =  0,//网络异常
    TYRRC_ERROR_SERVICE = 1,//服务器异常、无响应etc.
    TYRRC_ERROR_CACHE = 2,//本地缓存异常（可能无内存空间）
    TYRRC_ERROR_MAX_LENGHT = 99,//到达内容结尾
    TYRRC_ERROR_UNKNOWN = 4,//未知异常
    TYRRC_SUCCESS_SERVER = 8,//成功获取数据，来自服务器
    TYRRC_SUCCESS_CACHE = 16,//成功获取数据，来自缓存
    TYRRC_ERROR = 0|1|2|4,	
    TYRRC_SUCCESS = 8|16
}TYRequestResultCode;

#define kNotificationNameTokenError @"kNotificationNameTokenError"

typedef void(^TYRequestResultBlock)(TYRequestResultCode statuCode,BOOL isCache,_Nullable id data);

@interface QLAFHttpRequestOperationManager : NSObject


/**
 是否允许使用缓存
 */
@property (nonatomic,assign,readonly) BOOL isCacheEnable;

/**
 缓存策略类型
 */
@property (nonatomic,assign) enum TYAFCacheType cacheType;

/**
 网络请求类型，支持http get ,http post
 */
@property (nonatomic,assign,readonly) enum TYHttpModel httpRequestModel;


/**
 缓存有效期，默认5分钟
 */
@property (nonatomic,assign) NSTimeInterval cacheValiableTime;

/**
 网络超时时长，默认60s
 */
@property (nonatomic,assign) NSTimeInterval timeout;

/**
 是否打印log日志，发布时关闭
 */
@property (nonatomic,assign) BOOL printLog;


/**
 拼接网络连接url

 @param moduleName 相对路径
 @return 请求绝对路径
 */
+ (nullable NSString *)createRequestURLString:( NSString * _Nonnull )moduleName;


/**
 快速创建QLAFHttpRequestOperationManager.

 @return
 */
+ (_Nonnull instancetype)createOperationManager;

/**
 获取AFHttpSessionManager单例，务必使用该方法获取，否则会引起内存泄漏

 @return
 */
- (AFHTTPSessionManager * _Nonnull)shareHttpSessionManager;


/**
 表单提交文件

 @param filePath 本地文件绝对路径
 @param url 远程接口URL
 @param param 请求参数
 @param prograss 上传进度回调
 @param callback
 */
- (void)postFile:(nullable NSString *)filePath
              to:(nullable NSString *)url
           param:(nullable NSDictionary *)param
        prograss:(nullable void(^)(NSProgress * _Nonnull uploadProgress))prograss
        callback:(nullable void(^)(QLNetworkResponse * _Nonnull result))callback;

- (void)postBigFile:(nullable NSString *)filePath
              to:(nullable NSString *)url
           param:(nullable NSDictionary *)param
        prograss:(nullable void(^)(NSProgress * _Nonnull uploadProgress))prograss
        callback:(nullable void(^)(QLNetworkResponse * _Nonnull result))callback;
/**
 创建网络请求
 使用自定义CacheKey进行网络请求

 @param httpModel 网络请求类型
 @param cach_NonnulleType 缓存类型
 @param url 请求URL路径
 @param params 请求参数
 @param cacheKey 缓存key ，用于存取缓存
 @param callback
 */
- (void) createRequestWithModel:(enum TYHttpModel)httpModel
                      cacheType:(enum TYAFCacheType)cach_NonnulleType
                            url:(NSString * _Nonnull)url
                          param:(NSDictionary * _Nullable)params
                       cacheKey:(NSString * _Nullable )cacheKey
                       callback:(void(^_Nullable)(QLNetworkResponse* _Nonnull result))callback;


/**
 创建网络请求
 
 忽略指定的参数，使其不参与CacheKey的生成

 @param httpModel 网络请求类型
 @param cacheType 缓存类型
 @param url 请求URL路径
 @param params 请求参数
 @param ignoreParams 忽略指定的参数，使其不参与CacheKey的生成
 @param callback
 */
- (void)createRequestWithModel:(enum TYHttpModel)httpModel
                     cacheType:(enum TYAFCacheType)cacheType
                           url:(NSString * _Nonnull)url
                         param:(NSDictionary * _Nullable)params
        ignoreParamForCacheKey:(NSArray * _Nullable)ignoreParams
                      callback:(void(^_Nullable)(QLNetworkResponse* _Nonnull result))callback;


/**
 创建网络请求
 
 默认：
 全部参数将参与CacheKey的生成
 标准缓存策略
 
 @param httpModel 网络请求类型
 @param url 请求URL路径
 @param params 请求参数
 @param callback
 */
- (void)createRequestWithModel:(enum TYHttpModel)httpModel
                           url:(NSString * _Nonnull)url
                         param:(NSDictionary * _Nullable)params
                      callback:(void(^_Nullable)(QLNetworkResponse* _Nonnull result))callback;


/**
 创建网络请求

 @param httpModel 网络请求类型
 @param cacheType 缓存类型
 @param url 请求URL路径
 @param params 请求参数
 @param callback
 */
- (void)createRequestWithModel:(enum TYHttpModel)httpModel
                     cacheType:(enum TYAFCacheType)cacheType
                           url:(NSString * _Nonnull)url
                         param:(NSDictionary * _Nullable)params
                      callback:(void(^_Nullable)(QLNetworkResponse* _Nonnull result))callback;



/**
 创建缓存存储key

 @param url 请求的url
 @param param 请求参数
 @return
 */
-(NSString * _Nonnull)createCacheKeyWithURL:(NSString * _Nonnull)url andParam:(NSDictionary * _Nullable)param;


///**
// *使用自定义CacheKey进行同步网络请求
// */
//- (QLNetworkResponse * _Nonnull)createSynchronizedRequest:(enum TYHttpModel)model cacheType:(enum TYAFCacheType)cacheType url:(NSString *  _Nonnull)url param:(NSDictionary * _Nullable)param cacheKey:(NSString * _Nullable)cacheKey;
//
///**
// *创建同步请求，忽略指定的参数，使其不参与CacheKey的生成
// */
//- (QLNetworkResponse * _Nonnull)createSynchronizedRequest:(enum TYHttpModel)model cacheType:(enum TYAFCacheType)cacheType url:(NSString * _Nonnull)url param:(NSDictionary * _Nullable)param ignoreParamForCacheKey:(NSArray * _Nullable)ignoreParams;

- (void)postDLFile:(NSString *)filePath to:(NSString *)url param:(NSDictionary *)param prograss:(void(^)(NSProgress * _Nonnull uploadProgress))prograss callback:(void(^)(QLNetworkResponse *result))callback;

- (void)postRJFile:(NSString *)filePath to:(NSString *)url param:(NSDictionary *)param prograss:(void(^)(NSProgress * _Nonnull uploadProgress))prograss callback:(void(^)(QLNetworkResponse *result))callback;

- (void)cancelUpload:(NSString *)url;
@end
