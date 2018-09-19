//
//  QLAFHttpRequestOperationManager.m
//  TianYueMobileOA
//
//  Created by SiuJiYung on 14-1-23.
//  Copyright (c) 2014年 tianyue. All rights reserved.
//

#import "QLAFHttpRequestOperationManager.h"
#import "QLCacheManager.h"
#import "MD5Util.h"
#import <AFNetworking/AFNetworking.h>



@implementation QLAFHttpRequestOperationManager
{
    QLCacheManager *cacheMng;
    NSMutableDictionary<NSString*,NSURLSessionUploadTask*> *uploadTasks;
}


@synthesize isCacheEnable = _isCacheEnable;
@synthesize cacheType = _cacheType;
@synthesize httpRequestModel = _httpRequestModel;
@synthesize cacheValiableTime = _cacheValiableTime;
@synthesize timeout = _timeout;
@synthesize printLog;

//默认缓存有效期（5分钟）
#define  defaultCacheValiableTime 1000*60*5

+ (NSString *)createRequestURLString:(NSString *)moduleName{
    return  [NSString stringWithFormat:@"%@",moduleName];
}

+ (_Nonnull instancetype)createOperationManager{
    QLAFHttpRequestOperationManager *manager = [[QLAFHttpRequestOperationManager alloc] init];
    return manager;
}


static AFHTTPSessionManager *getManager ;
static AFHTTPSessionManager *postManager ;
- (AFHTTPSessionManager * _Nonnull)shareHttpSessionManager:(enum TYHttpModel)model{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        getManager = [AFHTTPSessionManager manager];
        postManager = [AFHTTPSessionManager manager];
    });
    if (model == TYHTTPPostModel) {
        return postManager;
    }
    return getManager;
}

-(id)init{
    self = [super init];
    self.cacheType = CacheNetworkFirst;
    self.cacheValiableTime = defaultCacheValiableTime;
    self.timeout = 35.0f;
    cacheMng = [QLCacheManager shareInstance];
    self.printLog = YES;
    uploadTasks = [NSMutableDictionary dictionary];
    return self;
}

-(void)setCacheType:(enum TYAFCacheType)cacheType{
    _isCacheEnable = cacheType != CacheDisable;
    _cacheType = cacheType;
}


#pragma --
#pragma --默认以get方式请求网络数据
- (void) createRequestWithModel:(enum TYHttpModel)httpModel
                            url:(NSString *)url
                          param:(NSDictionary *)params
                       callback:(void(^)(QLNetworkResponse* result))callback{
    
    [self createRequestWithModel:httpModel cacheType:CacheNetworkFirst url:url param:params callback:callback];
    
}

#pragma --
#pragma --加挂自定义缓存机制

-(void) createRequestWithModel:(enum TYHttpModel)httpModel
                     cacheType:(enum TYAFCacheType)cacheType
                           url:(NSString *)url
                         param:(NSDictionary *)params
        ignoreParamForCacheKey:(NSArray *)ignoreParams
                      callback:(void(^)(QLNetworkResponse* result))callback{
    
    NSString *cacheKey = nil;
    if (params) {
        NSMutableDictionary *_cacheParams = [NSMutableDictionary dictionaryWithDictionary:params];
        NSMutableArray *_ignoreKeys = [NSMutableArray arrayWithObjects:@"sessionId", nil];
        if (ignoreParams) {
            [_ignoreKeys addObjectsFromArray:ignoreParams];
        }
        for (NSString *key in _ignoreKeys) {
            [_cacheParams removeObjectForKey:key];
        }
        cacheKey = [self createCacheKeyWithURL:url andParam:_cacheParams];
    }else{
        cacheKey = [self createCacheKeyWithURL:url andParam:nil];
    }
    
    [self startRequestWithModel:httpModel cacheType:cacheType url:url param:params cacheKey:cacheKey callback:callback];
}

-(void) createRequestWithModel:(enum TYHttpModel)httpModel
                     cacheType:(enum TYAFCacheType)cacheType
                            url:(NSString *)url
                         param:(NSDictionary *)params
                      cacheKey:(NSString *)cacheKey
                      callback:(void(^)(QLNetworkResponse* result))callback{
    
    [self startRequestWithModel:httpModel cacheType:cacheType url:url param:params cacheKey:cacheKey callback:callback];
}

-(void) createRequestWithModel:(enum TYHttpModel)httpModel
                     cacheType:(enum TYAFCacheType)cacheType
                           url:(NSString *)url
                         param:(NSDictionary *)params
                      callback:(void(^)(QLNetworkResponse* result))callback{
    [self createRequestWithModel:httpModel cacheType:cacheType url:url param:params ignoreParamForCacheKey:nil callback:callback];
}

-(void)startRequestWithModel:(enum TYHttpModel) httpModel
                   cacheType:(enum TYAFCacheType)cacheType
                         url:(NSString *)url
                       param:(NSDictionary *)params
                    cacheKey:(NSString *)cacheKey
                    callback:(void(^)(QLNetworkResponse *result))callback{

    //已经使用缓存响应回调
    __block BOOL hadCacheRespon = NO;
    //已经使用服务器最新数据响应回调
    __block BOOL hadResponHostData = NO;
    [self setCacheType:cacheType];
    
    void (^__block_requestSuccess)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        [cacheMng stringCacheForKey:cacheKey resultCallback:^(id key, id content) {
            NSString *oldCacheContent = content;
            NSString *oldCacheContentHashCode = [MD5Util md5:oldCacheContent];
            //写入本地缓存
            NSString *json_str = nil;
            if (responseObject && [responseObject isKindOfClass:[NSString class]]) {
                json_str = responseObject;
            }else if(responseObject){
                json_str = [responseObject JSONString];
            }else{
                json_str = @"";
            }
            [cacheMng cacheString:json_str forKey:cacheKey];
            NSString *newContentHashCode = [MD5Util md5:json_str];
            
            BOOL isSameToOldContent = NO;
            if (newContentHashCode != nil && oldCacheContentHashCode != nil && [newContentHashCode isEqualToString:oldCacheContentHashCode]) {
                isSameToOldContent = YES;
            }
            
            if (![self handleTokenError:json_str]) {
                //token不符，另作处理
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNameTokenError object:json_str];
                return ;
            }
            //当内容和缓存内容不一致或者还没使用缓存进行响应，则立刻做出响应。
            if (callback && (isSameToOldContent == NO || hadCacheRespon == NO)) {
                hadResponHostData = YES;
                QLNetworkResponse *response = [[QLNetworkResponse alloc] init];
                response.baseURL = url;//[self.baseURL absoluteString];
                response.responseString = json_str;
                response.responseData = responseObject;
                response.responseObject = responseObject;
                response.statusCode = 200;
                response.isCache = NO;
                response.cacheKey = cacheKey;
                response.cacheCreateTime = 0;
                response.cacheInvalebleTime = [self cacheValiableTime];
                if(self.printLog){
                    NSLog(@"string=%@", response.responseString);
                    NSLog(@"response=%@", response);
                }
                callback(response);
                [self printResponse:response];
            }
        }];
    };
    
    void (^__block_requestFailure)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {

        [cacheMng stringCacheForKey:cacheKey resultCallback:^(id key, id content) {
            QLNetworkResponse *response = nil;
            if ([self isCacheEnable] && callback && hadCacheRespon == NO && hadResponHostData == NO) {
                hadCacheRespon = YES;
                NSString *content_str = nil;
                if (content && [content isKindOfClass:[NSString class]]) {
                    content_str = content;
                }else if(content){
                    content_str = [content JSONString];
                }else{
                    content_str = @"";
                }
                
                response = [[QLNetworkResponse alloc] init];
                response.baseURL = url;
                response.responseString = content_str;
                response.responseData = content;
                response.responseObject = content;
                response.statusCode = 500;
                response.isCache = (content != nil);
                response.cacheKey = cacheKey;
                response.cacheCreateTime = 0;
                response.cacheInvalebleTime = [self cacheValiableTime];
                callback(response);
            }else if(callback != nil){
                callback(nil);
            }
            [self printResponse:response];
        }];
    };
    
    
    //缓存优先模式
    if (self.isCacheEnable && (cacheType == CacheCacheFirst || cacheType == CacheNormal)) {
        [self getCacheContentWithKey:cacheKey cacheResult:^(id key, id content) {
            if (content != nil) {
                if (callback && hadResponHostData == NO && hadCacheRespon == NO) {
                    hadCacheRespon = YES;
                    NSString *content_str = nil;
                    if (content && [content isKindOfClass:[NSString class]]) {
                        content_str = content;
                    }else if(content){
                        content_str = [content JSONString];
                    }else{
                        content_str = @"";
                    }
                    QLNetworkResponse *response = [[QLNetworkResponse alloc] init];
                    response.baseURL = url;//[self.baseURL absoluteString];
                    response.responseString = content_str;
                    response.responseData = content;
                    response.responseObject = content;
                    response.statusCode = 200;
                    response.isCache = (content != nil);
                    response.cacheKey = cacheKey;
                    response.cacheCreateTime = 0;
                    response.cacheInvalebleTime = [self cacheValiableTime];
                    callback(response);
                    [self printResponse:response];
                }
            }
        }];
        [self requestNetworkWithURL:url param:params requestModel:httpModel success:__block_requestSuccess failure:__block_requestFailure];
    }else{
        //网络优先路线
        [self requestNetworkWithURL:url param:params requestModel:httpModel success:__block_requestSuccess failure:__block_requestFailure];
    }
}

- (BOOL)handleTokenError:(NSString *)responseData{
    BOOL token_ok = YES;
    HttpResponData *responData = [[HttpResponData alloc] init];
    NSDictionary *info = [responseData objectFromJSONString];
    [responData initWithDictionary:info];
    NSString *error_str = responData.msg;
    if (error_str == nil) {
        error_str = responData.result;
    }
    if (error_str != nil && [error_str stringByMatching:@"token不符"]) {
        token_ok = YES;
    }
    
    return token_ok;
}

/**
 *使用自定义CacheKey进行同步网络请求
 */
- (QLNetworkResponse *)createSynchronizedRequest:(enum TYHttpModel)model
                                       cacheType:(enum TYAFCacheType)cacheType
                                             url:(NSString *)url
                                           param:(NSDictionary *)param
                                        cacheKey:(NSString *)cacheKey{
    NSCondition *condition = [[NSCondition alloc] init];
    __block QLNetworkResponse *response = nil;
    [self startRequestWithModel:model cacheType:cacheType url:url param:param cacheKey:cacheKey callback:^(QLNetworkResponse *result) {
        response = result;
        [condition lock];
        [condition signal];
        [condition unlock];
    }];
    
    [condition lock];
    [condition wait];
    [condition unlock];
    
    return response;
}

/**
 *创建同步请求，忽略指定的参数，使其不参与CacheKey的生成
 */
- (QLNetworkResponse *)createSynchronizedRequest:(enum TYHttpModel)model
                                       cacheType:(enum TYAFCacheType)cacheType
                                             url:(NSString *)url
                                           param:(NSDictionary *)param
                          ignoreParamForCacheKey:(NSArray *)ignoreParams{
    
    NSString *cacheKey = nil;
    if (param) {
        NSMutableDictionary *_cacheParams = [NSMutableDictionary dictionaryWithDictionary:param];
        NSMutableArray *_ignoreKeys = [NSMutableArray arrayWithObjects:@"sessionId", nil];
        if (ignoreParams) {
            [_ignoreKeys addObjectsFromArray:ignoreParams];
        }
        for (NSString *key in _ignoreKeys) {
            [_cacheParams removeObjectForKey:key];
        }
        cacheKey = [self createCacheKeyWithURL:url andParam:_cacheParams];
    }else{
        cacheKey = [self createCacheKeyWithURL:url andParam:nil];
    }
    
    
    NSCondition *condition = [[NSCondition alloc] init];
    __block QLNetworkResponse *response = nil;
    [self startRequestWithModel:model cacheType:cacheType url:url param:param cacheKey:cacheKey callback:^(QLNetworkResponse *result) {
        response = result;
        [condition lock];
        [condition signal];
        [condition unlock];
    }];
    [condition lock];
    [condition wait];
    [condition unlock];
    return response;
}

-(void)requestNetworkWithURL:(NSString *)url
                       param:(NSDictionary *)params
                requestModel:(enum TYHttpModel)httpModel
                     success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                     failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    
    AFHTTPSessionManager *requestManager = [self shareHttpSessionManager:httpModel];
    [self printReuest:url params:params];
    if (httpModel == TYHTTPGetModel) {
        requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        [requestManager GET:url parameters:params progress:nil success:success failure:failure];
    }else{
        requestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        NSSet <NSString *> *contentType = requestManager.responseSerializer.acceptableContentTypes;
        NSMutableSet *newContentType = [NSMutableSet set];
        [newContentType addObject:@"multipart/form-data"];
        [newContentType addObject:@"text/html"];
        for (NSString *set in contentType) {
            [newContentType addObject:set];
        }
        requestManager.responseSerializer.acceptableContentTypes = newContentType;
//        [requestManager POST:url parameters:params progress:nil success:success failure:failure];
        [requestManager POST:url parameters:params constructingBodyWithBlock:nil progress:nil success:success failure:failure];
    }
    
}

- (void)postFile:(NSString *)filePath
              to:(NSString *)url
           param:(NSDictionary *)param
        prograss:(void(^)(NSProgress * _Nonnull uploadProgress))prograss
        callback:(void(^)(QLNetworkResponse *result))callback{
    
    __block BOOL hadCacheRespon = NO;
    void (^__block_requestSuccess)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        if (callback) {
            QLNetworkResponse *response = [[QLNetworkResponse alloc] init];
            response.baseURL = url;//[self.baseURL absoluteString];
            response.responseString = responseObject;
            response.responseData = responseObject;
            response.responseObject = responseObject;
            response.statusCode = 200;
            response.isCache = NO;
            response.cacheKey = nil;
            response.cacheCreateTime = 0;
            response.cacheInvalebleTime = [self cacheValiableTime];
            if (self.printLog) {
                NSLog(@"string=%@", response.responseString);
                NSLog(@"response=%@", response);
            }
            callback(response);
            [self printResponse:response];
        }
    };
    
    void (^__block_requestFailure)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
            QLNetworkResponse *response = nil;
            hadCacheRespon = YES;
            response = [[QLNetworkResponse alloc] init];
            response.baseURL = url;
            response.responseString = nil;
            response.responseData = nil;
            response.responseObject = nil;
            response.statusCode = 500;
            response.isCache = NO;
            response.cacheKey = nil;
            response.cacheCreateTime = 0;
            response.cacheInvalebleTime = [self cacheValiableTime];
            callback(response);
            [self printResponse:response];
    };
    
    AFHTTPSessionManager *manager = [self shareHttpSessionManager:_httpRequestModel];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"content-type"];
    NSSet <NSString *> *contentType = manager.responseSerializer.acceptableContentTypes;
    NSMutableSet *newContentType = [NSMutableSet set];
    [newContentType addObject:@"multipart/form-data"];
    [newContentType addObject:@"text/html"];
    for (NSString *set in contentType) {
        [newContentType addObject:set];
    }
    manager.responseSerializer.acceptableContentTypes = newContentType;

    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        NSString *fileName = [fileURL.path lastPathComponent];
        NSString *name = [fileName stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSError *error;
        [formData appendPartWithFileURL:fileURL name:name error:&error];
    } progress:prograss success:__block_requestSuccess failure:__block_requestFailure];
 
}

- (void)postDLFile:(NSString *)filePath to:(NSString *)url param:(NSDictionary *)param prograss:(void(^)(NSProgress * _Nonnull uploadProgress))prograss callback:(void(^)(QLNetworkResponse *result))callback{
    
    __block BOOL hadCacheRespon = NO;
    void (^__block_requestSuccess)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        if (callback) {
            QLNetworkResponse *response = [[QLNetworkResponse alloc] init];
            response.baseURL = url;//[self.baseURL absoluteString];
            response.responseString = responseObject;
            response.responseData = responseObject;
            response.responseObject = responseObject;
            response.statusCode = 200;
            response.isCache = NO;
            response.cacheKey = nil;
            response.cacheCreateTime = 0;
            response.cacheInvalebleTime = [self cacheValiableTime];
            if (self.printLog) {
                NSLog(@"string=%@", response.responseString);
                NSLog(@"response=%@", response);
            }
            callback(response);
            [self printResponse:response];
        }
    };
    
    void (^__block_requestFailure)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        QLNetworkResponse *response = nil;
        hadCacheRespon = YES;
        response = [[QLNetworkResponse alloc] init];
        response.baseURL = url;
        response.responseString = nil;
        response.responseData = nil;
        response.responseObject = nil;
        response.statusCode = 500;
        response.isCache = NO;
        response.cacheKey = nil;
        response.cacheCreateTime = 0;
        response.cacheInvalebleTime = [self cacheValiableTime];
        callback(response);
        [self printResponse:response];
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"content-type"];
    NSSet <NSString *> *contentType = manager.responseSerializer.acceptableContentTypes;
    NSMutableSet *newContentType = [NSMutableSet set];
    [newContentType addObject:@"multipart/form-data"];
    [newContentType addObject:@"text/html"];
    for (NSString *set in contentType) {
        [newContentType addObject:set];
    }
    manager.responseSerializer.acceptableContentTypes = newContentType;
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        NSString *name = @"file";
        NSError *error;
        [formData appendPartWithFileURL:fileURL name:name error:&error];
    } progress:prograss success:__block_requestSuccess failure:__block_requestFailure];
    
}

- (void)postRJFile:(NSString *)filePath to:(NSString *)url param:(NSDictionary *)param prograss:(void(^)(NSProgress * _Nonnull uploadProgress))prograss callback:(void(^)(QLNetworkResponse *result))callback{
    
    __block BOOL hadCacheRespon = NO;
    void (^__block_requestSuccess)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        if (callback) {
            QLNetworkResponse *response = [[QLNetworkResponse alloc] init];
            response.baseURL = url;//[self.baseURL absoluteString];
            response.responseString = responseObject;
            response.responseData = responseObject;
            response.responseObject = responseObject;
            response.statusCode = 200;
            response.isCache = NO;
            response.cacheKey = nil;
            response.cacheCreateTime = 0;
            response.cacheInvalebleTime = [self cacheValiableTime];
            if (self.printLog) {
                NSLog(@"string=%@", response.responseString);
                NSLog(@"response=%@", response);
            }
            callback(response);
            [self printResponse:response];
        }
    };
    
    void (^__block_requestFailure)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        QLNetworkResponse *response = nil;
        hadCacheRespon = YES;
        response = [[QLNetworkResponse alloc] init];
        response.baseURL = url;
        response.responseString = nil;
        response.responseData = nil;
        response.responseObject = nil;
        response.statusCode = 500;
        response.isCache = NO;
        response.cacheKey = nil;
        response.cacheCreateTime = 0;
        response.cacheInvalebleTime = [self cacheValiableTime];
        callback(response);
        [self printResponse:response];
    };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"content-type"];
    NSSet <NSString *> *contentType = manager.responseSerializer.acceptableContentTypes;
    NSMutableSet *newContentType = [NSMutableSet set];
    [newContentType addObject:@"multipart/form-data"];
    [newContentType addObject:@"text/html"];
    for (NSString *set in contentType) {
        [newContentType addObject:set];
    }
    manager.responseSerializer.acceptableContentTypes = newContentType;
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
//        NSString *name = @"file";
//        NSError *error;
//        [formData appendPartWithFileURL:fileURL name:name error:&error];
    } progress:prograss success:__block_requestSuccess failure:__block_requestFailure];
    
}


- (void)postBigFile:(NSString *)filePath
              to:(NSString *)url
           param:(NSDictionary *)param
        prograss:(void(^)(NSProgress * _Nonnull uploadProgress))prograss
        callback:(void(^)(QLNetworkResponse *result))callback{
    
    __block BOOL hadCacheRespon = NO;
    void (^__block_requestSuccess)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        if (callback) {
            QLNetworkResponse *response = [[QLNetworkResponse alloc] init];
            response.baseURL = url;//[self.baseURL absoluteString];
            response.responseString = responseObject;
            response.responseData = responseObject;
            response.responseObject = responseObject;
            response.statusCode = 200;
            response.isCache = NO;
            response.cacheKey = nil;
            response.cacheCreateTime = 0;
            response.cacheInvalebleTime = [self cacheValiableTime];
            if (self.printLog) {
                NSLog(@"string=%@", response.responseString);
                NSLog(@"response=%@", response);
            }
            callback(response);
            [self printResponse:response];
        }
    };
    
    void (^__block_requestFailure)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject) {
        
        QLNetworkResponse *response = nil;
        hadCacheRespon = YES;
        response = [[QLNetworkResponse alloc] init];
        response.baseURL = url;
        response.responseString = nil;
        response.responseData = nil;
        response.responseObject = nil;
        response.statusCode = 500;
        response.isCache = NO;
        response.cacheKey = nil;
        response.cacheCreateTime = 0;
        response.cacheInvalebleTime = [self cacheValiableTime];
        callback(response);
        [self printResponse:response];
    };
    
    AFHTTPSessionManager *manager = [self shareHttpSessionManager:_httpRequestModel];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"content-type"];
    NSSet <NSString *> *contentType = manager.responseSerializer.acceptableContentTypes;
    NSMutableSet *newContentType = [NSMutableSet set];
    [newContentType addObject:@"multipart/form-data"];
    [newContentType addObject:@"text/html"];
    for (NSString *set in contentType) {
        [newContentType addObject:set];
    }
    manager.responseSerializer.acceptableContentTypes = newContentType;
    
    NSURLSessionUploadTask *task = [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
//        NSString *fileName = [fileURL.path lastPathComponent];
//        NSString *name = [fileName stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSError *error;
        [formData appendPartWithFileURL:fileURL name:@"file" error:&error];
    } progress:prograss success:__block_requestSuccess failure:__block_requestFailure];
    [uploadTasks setObject:task forKey:url];
}


//创建CacheKey
-(NSString *)createCacheKeyWithURL:(NSString *)url andParam:(NSDictionary *)param{
    NSMutableString *tmpMutableString = [NSMutableString stringWithString:url];
    if (param) {
        NSEnumerator *keys = [param keyEnumerator];
        NSArray *keyArray = [keys allObjects];
        NSString *value = nil;
        BOOL _first_append = YES;
        for (NSString *key in keyArray) {
            value = [param objectForKey:key];
            [tmpMutableString appendFormat:@"%@%@=%@",_first_append?@"?":@"&",key,value];
            _first_append = NO;
        }
    }
    NSString *md5str = [MD5Util md5:tmpMutableString];
    return  md5str;
}

- (void)cancelUpload:(NSString *)url {
    NSURLSessionUploadTask *task =  [uploadTasks objectForKey:url];
    if (task) {
        [task cancel];
        [uploadTasks removeObjectForKey:url];
    }
//    AFHTTPSessionManager *manager = [self shareHttpSessionManager:_httpRequestModel];
//    [postManager.operationQueue cancelAllOperations];
}

//获取缓存
-(void)getCacheContentWithKey:(NSString *)cacheKey cacheResult:(QLCacheResultBlock)callback{
    [cacheMng stringCacheForKey:cacheKey resultCallback:callback];
}

-(void)printResponse:(QLNetworkResponse *)response{
#if TY_APP_STATUS_ISTESING == YES
    if (self.printLog == NO) {
        return;
    }
    if (response) {
        NSLog(@"request : %@ response :%@ ,isCache:%@",response.baseURL,response.responseString,response.isCache?@"YES":@"NO");
    }else{
        NSLog(@"no response.");
    }
#endif
}

-(void)printReuest:(NSString *)url params:(NSDictionary *)param {
#if TY_APP_STATUS_ISTESING == YES
    if (self.printLog == NO) {
        return;
    }
    NSMutableString *printstr = [NSMutableString stringWithFormat:@"%@",url];
    if (param) {
        NSEnumerator *keys = [param keyEnumerator];
        BOOL _first_flag = YES;
        for (NSString *key in keys) {
            id value = [param objectForKey:key];
            [printstr appendFormat:@"%@%@=%@",_first_flag?@"?":@"&",key,value];
            _first_flag = NO;
        }
    }
    NSLog(@"request : %@",printstr);
#endif
}

@end
