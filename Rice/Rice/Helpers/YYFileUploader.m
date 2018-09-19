//
//  YYFileUploader.m
//  DailyLesson
//
//  Created by 李永 on 2018/6/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import "YYFileUploader.h"

#import "QLAFHttpRequestOperationManager.h"

@implementation YYFileUploader{
    NSMutableArray<YYFileUploadInfo> *taskList;
    NSMutableArray<YYFileUploadInfo> *successList;
    NSMutableArray<YYFileUploadInfo> *failList;
    id<YYFileUploadInfo> currTask;
    __weak YYFileUploader *__self;
    BOOL isUploading;
    BOOL isStop;
}

+ (instancetype)createUploader{
    return [[YYFileUploader alloc] init];
}

- (id)init{
    self = [super init];
    if (self) {
        __self = self;
        isUploading = NO;
        isStop = YES;
        taskList = [NSMutableArray<YYFileUploadInfo> array];
        successList = [NSMutableArray<YYFileUploadInfo> array];
        failList = [NSMutableArray<YYFileUploadInfo> array];
    }
    return self;
}

- (void)addTask:(id<YYFileUploadInfo>)task{
    if (task) {
        [taskList addObject:task];
    }
}

- (void)addTaskList:(NSArray<YYFileUploadInfo> *)tasks{
    if (tasks && [tasks count] > 0) {
        [taskList addObjectsFromArray:tasks];
    }
}

- (id<YYFileUploadInfo>)taskByID:(NSInteger)taskId{
    NSArray<YYFileUploadInfo> *_allTaskList = [self allTaskList];
    for (id<YYFileUploadInfo> _info in _allTaskList) {
        if (_info.taskId == taskId) {
            return _info;
        }
    }
    return nil;
}

- (void)removeTaskByTaskID:(NSInteger)taskId{
    
}

- (void)removeTasks:(NSArray<YYFileUploadInfo> *)tasks{
    
}

- (void)cleanTasks{
    [taskList removeAllObjects];
    [successList removeAllObjects];
    [failList removeAllObjects];
}

- (void)startUpload{
    isStop = NO;
    if ([failList count] > 0) {
        //把失败的任务重新加入上传列表
        [taskList addObjectsFromArray:failList];
    }
    [self doNextUpload];
}

- (void)stopUpload{
    isStop = YES;
    isUploading = NO;
}

- (NSArray<YYFileUploadInfo> *)allTaskList{
    NSMutableArray<YYFileUploadInfo> *tmpList = [NSMutableArray<YYFileUploadInfo> array];
    [tmpList addObjectsFromArray:taskList];
    [tmpList addObjectsFromArray:successList];
    [tmpList addObjectsFromArray:failList];
    
    return tmpList;
}

- (NSArray<YYFileUploadInfo> *)successfulList{
    return successList;
}

- (NSArray<YYFileUploadInfo> *)failList{
    return failList;
}

- (NSArray<YYFileUploadInfo> *)waitingList{
    return taskList;
}

- (id<YYFileUploadInfo>)nextTask{
    if ([taskList count] < 1) {
        return nil;
    }
    id<YYFileUploadInfo> task = [taskList firstObject];
    [taskList removeObjectAtIndex:0];
    return task;
}

- (void)doResult:(id<YYFileUploadInfo>)task{
    if (task.file_id) {
        [successList addObject:task];
        if (_delegate && [_delegate respondsToSelector:@selector(didUploadSuccess:uploader:)]) {
            [_delegate didUploadSuccess:task uploader:__self];
        }
    }else{
        [failList addObject:task];
        if (_delegate && [_delegate respondsToSelector:@selector(didUploadFail:uploader:)]) {
            [_delegate didUploadFail:task uploader:__self];
        }
    }
    
}

- (void)doNextUpload{
    if (isStop) {
        if (_delegate && [_delegate respondsToSelector:@selector(didAllTaskUploadFinish:)]) {
            [_delegate didAllTaskUploadFinish:__self];
        }
        isUploading = NO;
        return;
    }
    if (isUploading) {
        return;
    }
    isUploading = YES;
    currTask = [__self nextTask];
    if (currTask) {
        [self doUpload:currTask];
    }else{
        isStop = YES;
        //完成任务
        if (_delegate && [_delegate respondsToSelector:@selector(didAllTaskUploadFinish:)]) {
            [_delegate didAllTaskUploadFinish:__self];
        }
        isUploading = NO;
    }
}

- (void)doUpload:(id<YYFileUploadInfo>)task{
    if (task.localPath == nil) {
        isUploading = NO;
        [__self doNextUpload];
        return;
    }
    QLAFHttpRequestOperationManager *operation = [[QLAFHttpRequestOperationManager alloc] init];
    NSString *filePath = [self base64EncodeImageWithName:task.localPath];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param ql_setObject:filePath forKey:@"upload"];
    
    NSDictionary *paramDic = [RJHttpRequest signDic:param];
    [operation postRJFile:filePath to:kImageUpLoad param:paramDic prograss:^(NSProgress * _Nonnull uploadProgress) {
        if (__self.delegate &&
            [__self.delegate respondsToSelector:@selector(didProgress:progress:uploader:)])
        {
            [__self.delegate didProgress:currTask progress:uploadProgress.fractionCompleted uploader:__self];
        }
    } callback:^(QLNetworkResponse * _Nonnull result) {
        NSString *file_id = nil;
        NSString *file_path = nil;
        if (result.statusCode == 200 && result.responseData && [result.responseData isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responDic = (NSDictionary *)result.responseData;
            if ([responDic ql_boolForKey:@"status"] && [responDic objectForKey:@"data"]) {
                NSDictionary *root = [responDic objectForKey:@"data"];
                if (root && [root count] > 0) {
//                    NSDictionary *dic = [root firstObject];
                    file_id = [root ql_stringForKey:@"key"];
                    file_path = [root ql_stringForKey:@"url"];
                }
            }
        }
//        currTask.file_id = file_id;
        currTask.fileUrl = file_path;
        [__self doResult:currTask];
        isUploading = NO;
        [__self doNextUpload];
    }];
}

- (NSString *)base64EncodeImageWithName:(NSString *)name{
    UIImage *image = [UIImage imageNamed:name];
    NSData *data = UIImagePNGRepresentation(image);
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    NSString *baseString = [[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
    
    return baseString;
}


@end
