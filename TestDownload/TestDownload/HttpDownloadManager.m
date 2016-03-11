//
//  HttpDownloadManager.m
//  TestDownload
//
//  Created by Ricky on 16/3/10.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "HttpDownloadManager.h"
#import "HttpDownload.h"

@implementation HttpDownloadManager


-(id)init
{
    if([super init]){
        
        self.taskMap = [NSMutableDictionary dictionary];

//        dispatch_group_t group = dispatch_group_create();
//        dispatch_semaphore_t semaphore = dispatch_semaphore_create(3);
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            
//            while(1){
//                 for (RequestDownloadTask*task in [self.taskMap allValues]) {
//                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//                    dispatch_group_async(group, queue, ^{
//                        if(!task.use && [task isStart]){
//                            task.use = YES;
//                            [HttpDownload downloadFile:task];
//                        }
//                        dispatch_semaphore_signal(semaphore);
//                    });
//                 }
//                usleep(100);
//            }
//        });

        
//        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        //dispatch_release(group);
        //dispatch_release(semaphore);
        
        
    }
    return self;
}

-(void)addTask:(NSString*)taskName
           Obj:(RequestDownloadTask*)objTask
{
    [self.taskMap setValue:objTask forKey:taskName];
}

-(void)delTask:(NSString*)taskName
{
    if([self getTask:taskName]){
        [[self getTask:taskName] stop];
        [self.taskMap removeObjectForKey:taskName];
    }
}

-(void)pauseTask:(NSString*)taskName
{
    if([self getTask:taskName]){
        [[self getTask:taskName] pause];
    }
}

-(void)stopTask:(NSString*)taskName
{
    if([self getTask:taskName]){
        [[self getTask:taskName] stop];
    }
}

-(void)delAllTask
{
    for (RequestDownloadTask*task in [self.taskMap allValues]) {
        [task stop];
    }
    [self.taskMap removeAllObjects];
}

-(void)stopAllTask
{
    for (RequestDownloadTask*task in [self.taskMap allValues]) {
        [task stop];
    }
}

-(void)startAllTask
{
    for (NSString*taskName in [self.taskMap allKeys]) {
        [self startTask:taskName];
    }
}

-(void)startTask:(NSString*)taskName
{
    if([self getTask:taskName]){
        RequestDownloadTask* task = [self getTask:taskName];
        [task start];
        
        if(!task.use && [task isStart]){
            task.use = YES;
            [HttpDownload downloadFile:task];
        }
    }
}

-(RequestDownloadTask*)getTask:(NSString*)taskName
{
    return [self.taskMap objectForKey:taskName];
}

@end
