//
//  HttpDownload.h
//  TestDownload
//
//  Created by Ricky on 16/3/10.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RequestDownloadTask;

//下载协议
@protocol HttpDownloadDelegate

//开始下载
-(void)downloadBegin:(RequestDownloadTask*)objTask;

//进度发生变化
-(void)changeProgress:(NSInteger)progress
                  obj:(RequestDownloadTask*)objTask;

//状态发生变化
-(void)changeState:(RequestDownloadTask*)objTask;

//下载完成
-(void)downloadDone:(RequestDownloadTask*)objTask;

//下载失败
-(void)downloadFail:(RequestDownloadTask*)objTask;

@end


//http 文件下载器
@interface HttpDownload : NSObject

@property(nonatomic,strong)RequestDownloadTask *myTask;

//创建下载器，并开始下载或续传
+(void)downloadFile:(RequestDownloadTask*) task;

//取消下载任务
-(void)cancel;
@end
