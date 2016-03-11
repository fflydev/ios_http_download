//
//  RequestDownloadTask.h
//  TestDownload
//
//  Created by Ricky on 16/3/10.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpDownload.h"

#define STATE_STOP 1
#define STATE_RUN 2
#define STATE_PAUSE 3
#define STATE_RUNNING 4

//下载任务载体
@interface RequestDownloadTask : NSObject
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *outFilePath;
@property(nonatomic,assign)NSInteger state;
@property(nonatomic,assign)NSInteger totalSize;
@property(nonatomic,assign)NSInteger curSize;
@property(nonatomic,assign)NSInteger progress;
@property(nonatomic,assign)id<HttpDownloadDelegate> delegate;
@property(nonatomic,strong)HttpDownload *download;
@property(nonatomic,strong)id objTag;
@property(nonatomic,assign)BOOL use;

//创建新任务
+(RequestDownloadTask*)newTaskWithUrl:(NSString*)url
                          outFilePath:(NSString*)outFilePath
                             delegate:(id<HttpDownloadDelegate>)delegate;

-(void)pause;
-(void)start;
-(void)stop;

-(BOOL)isPause;
-(BOOL)isStart;
-(BOOL)isStop;
@end
