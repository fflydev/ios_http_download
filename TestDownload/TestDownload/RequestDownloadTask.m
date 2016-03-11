//
//  RequestDownloadTask.m
//  TestDownload
//
//  Created by Ricky on 16/3/10.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "RequestDownloadTask.h"


@implementation RequestDownloadTask


+(RequestDownloadTask*)newTaskWithUrl:(NSString*)url
                          outFilePath:(NSString*)outFilePath
                             delegate:(id<HttpDownloadDelegate>)delegate
{
    RequestDownloadTask *task = [[RequestDownloadTask alloc]init];
    task.url = url;
    task.outFilePath = outFilePath;
    task.delegate = delegate;
    return task;
}

-(void)pause
{
    self.state = STATE_PAUSE;
    self.use = NO;
    if(self.download){
        [self.download cancel];
    }
}

-(void)start
{
    self.state = STATE_RUN;
}

-(void)stop
{
    self.state = STATE_STOP;
    self.use = NO;
    if(self.download){
        [self.download cancel];
    }
}


-(BOOL)isPause
{
    return self.state == STATE_PAUSE;
}

-(BOOL)isStart
{
    return (self.state == STATE_RUN) || (self.state == STATE_RUNNING);
}

-(BOOL)isStop
{
    return self.state == STATE_STOP;
}

@end
