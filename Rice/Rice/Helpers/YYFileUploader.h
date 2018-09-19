//
//  YYFileUploader.h
//  DailyLesson
//
//  Created by 李永 on 2018/6/27.
//  Copyright © 2018年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYFileUploader;

typedef enum{
    UploadImageStatus_Waiting = 0,
    UploadImageStatus_Uploading = 1,
    UploadImageStatus_Success = 2,
    UploadImageStatus_Failed = 3
}UploadImageStatus;

@protocol YYFileUploadInfo <NSObject>

@property (nonatomic,assign) NSInteger taskId;
@property (nonatomic,copy) NSString *file_id;//文件id
@property (nonatomic,copy) NSString *localFileName;//本地文件名
@property (nonatomic,copy) NSString *localPath;//本地路径
@property (nonatomic,copy) NSString *fileUrl;//下载路径
@property (nonatomic,copy) NSString *thumbnail;//封面
@property (nonatomic,assign) UploadImageStatus uploadStatus;//上传状态

@end

@protocol YYFileUploadDelegate <NSObject>

@optional
- (void)didProgress:(id<YYFileUploadInfo>)task progress:(float)progress uploader:(YYFileUploader *)uploader;
- (void)didUploadSuccess:(id<YYFileUploadInfo>)task uploader:(YYFileUploader *)uploader;
- (void)didUploadFail:(id<YYFileUploadInfo>)task uploader:(YYFileUploader *)uploader;
- (void)didAllTaskUploadFinish:(YYFileUploader *)uploader;

@end


@interface YYFileUploader : NSObject

@property (nonatomic,assign) id<YYFileUploadDelegate> delegate;

+ (instancetype)createUploader;

- (void)addTask:(id<YYFileUploadInfo>)task;

- (void)addTaskList:(NSArray<YYFileUploadInfo> *)tasks;

- (void)removeTaskByTaskID:(NSInteger)taskId;

- (void)removeTasks:(NSArray<YYFileUploadInfo> *)tasks;

- (void)cleanTasks;

- (void)startUpload;

- (void)stopUpload;

- (id<YYFileUploadInfo>)taskByID:(NSInteger)taskId;

- (NSArray<YYFileUploadInfo> *)allTaskList;

- (NSArray<YYFileUploadInfo> *)successfulList;

- (NSArray<YYFileUploadInfo> *)failList;

- (NSArray<YYFileUploadInfo> *)waitingList;


@end
