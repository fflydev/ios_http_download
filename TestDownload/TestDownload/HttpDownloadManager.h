//
//  HttpDownloadManager.h
//  TestDownload
//
//  Created by Ricky on 16/3/10.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestDownloadTask.h"

@interface HttpDownloadManager : NSObject

@property(atomic) NSMutableDictionary *taskMap;


-(id)init;

//添加下载任务
-(void)addTask:(NSString*)taskName
           Obj:(RequestDownloadTask*)objTask;

//删除下载任务
-(void)delTask:(NSString*)taskName;

//暂停下载任务
-(void)pauseTask:(NSString*)taskName;

//中断下载任务
-(void)stopTask:(NSString*)taskName;

//停止所有任务
-(void)stopAllTask;

//开始所有任务
-(void)startAllTask;

//删除所有任务
-(void)delAllTask;

//开始任务
-(void)startTask:(NSString*)taskName;

//获取某个任务
-(RequestDownloadTask*)getTask:(NSString*)taskName;
@end
