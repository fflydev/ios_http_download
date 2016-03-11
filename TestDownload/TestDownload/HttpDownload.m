//
//  HttpDownload.m
//  TestDownload
//
//  Created by Ricky on 16/3/10.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "HttpDownload.h"
#import "RequestDownloadTask.h"

@interface HttpDownload ()<NSURLConnectionDataDelegate>
{
    long long contentLength;
    long long receiveLength;
    NSString *fileName;
    NSURLConnection *theConnection;
    NSMutableURLRequest *theRequest;
    
    FILE *outFp;
}

@end

@implementation HttpDownload


//开启一个下载
+(void)downloadFile:(RequestDownloadTask*) task
{
    HttpDownload*d = [[HttpDownload alloc] init];
    d.myTask = task;
    task.download = d;
    [d start];
}


//开始下载任务
-(void)start
{
    long offset = 0;
    
    //检测文件夹是否被创建
    NSString *filePath = self.myTask.outFilePath;
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO){
        NSLog(@"file not exist,create it...");
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }else {
        NSLog(@"file exist!!!");
    }
    
    //打开文件
    outFp = fopen(self.myTask.outFilePath.UTF8String, "ab+");
    NSURL *url=[NSURL URLWithString:self.myTask.url];
    theRequest = [NSMutableURLRequest requestWithURL:url];
    
    //计算续传位置
    if(outFp != NULL){
        fseek(outFp, 0, SEEK_END);
        offset = ftell(outFp);
    }
    if(offset != 0){
        [theRequest setValue:[NSString stringWithFormat:@"bytes=%ld-",offset] forHTTPHeaderField:@"Range"];
    }
    
    contentLength = 0;
    receiveLength = offset;
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

//取消下载任务
-(void)cancel
{
    if(theConnection){
        [theConnection cancel];
        [self releaseObjs];
    }
    
    if(self.myTask && self.myTask.delegate){
        __weak RequestDownloadTask* __mytask = self.myTask;
        dispatch_async(dispatch_get_main_queue(), ^{
            [__mytask.delegate changeState:self.myTask];
        });
    }
}


//接收到http响应
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    contentLength = [response expectedContentLength]+receiveLength;
    fileName = [response suggestedFilename];
    NSLog(@"data length is %lli", contentLength);
    
    //call back
    if(self.myTask && self.myTask.delegate){
        self.myTask.totalSize = contentLength;
        
        
        __weak RequestDownloadTask* __mytask = self.myTask;
        dispatch_async(dispatch_get_main_queue(), ^{
            [__mytask.delegate downloadBegin:self.myTask];
        });
    }
}

//传输数据
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //只有下载状态下，才保存服务器传输过来的数据
    if([self.myTask isStart]){
        receiveLength += data.length;
        [self writeToFile:data];
        NSLog(@"data recvive is %lli", receiveLength);
        
        //call back
        if(self.myTask && self.myTask.delegate){
            self.myTask.curSize = receiveLength;
            
            NSInteger curProgress = 100 * receiveLength / contentLength;
            
            if(curProgress > self.myTask.progress){
                self.myTask.progress = curProgress;
                __weak RequestDownloadTask* __mytask = self.myTask;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [__mytask.delegate changeProgress:__mytask.progress obj:self.myTask];
                });
            }
        }
    }
}

//错误
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self releaseObjs];
    NSLog(@"%@",error.description);
    
    //call back
    if(self.myTask && self.myTask.delegate){
        
        __weak RequestDownloadTask* __mytask = self.myTask;
        dispatch_async(dispatch_get_main_queue(), ^{
            [__mytask.delegate downloadFail:self.myTask];
        });
        
    }
}

//成功下载完毕
- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    [self releaseObjs];
    
    //call back
    if(self.myTask && self.myTask.delegate){
        
        __weak RequestDownloadTask* __mytask = self.myTask;
        dispatch_async(dispatch_get_main_queue(), ^{
            [__mytask.delegate downloadDone:self.myTask];
        });
    }
}


//写数据到文件
-(void)writeToFile:(NSData *)data
{
    int readSize = [data length];
    fwrite((const void *)[data bytes], readSize, 1, outFp);
}

- (void) releaseObjs{
    
    if(outFp){
        fclose(outFp);
        outFp = NULL;
    }
    
    if(self.myTask){
        self.myTask.download = nil;
    }

    fileName = nil;
    theRequest = nil;
    theConnection = nil;
}

@end
