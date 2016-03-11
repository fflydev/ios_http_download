//
//  ViewController.m
//  TestDownload
//
//  Created by Ricky on 16/3/10.
//  Copyright © 2016年 Ricky. All rights reserved.
//

#import "ViewController.h"
#import "RequestDownloadTask.h"
#import "HttpDownloadManager.h"

@interface ViewController ()<HttpDownloadDelegate>
{
    HttpDownloadManager * manager;
    RequestDownloadTask *task1;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    manager = [[HttpDownloadManager alloc]init];
    
//    task1 = [[RequestDownloadTask alloc]init];
//    task1.delegate = self;
//    task1.outFilePath=[NSString stringWithFormat:@"%@/Documents/aabbcc.mp3",NSHomeDirectory()];
//    task1.url=@"http://222.186.30.212:8082/demo_store/2016/01/13/82306fdafeb75e8558cbfb41279d04e9.mp3";
//    
//    [task1 start];
//    [HttpDownload downloadFile:task1];
    
    
    NSLog(@"%@",NSHomeDirectory());
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClick:(id)sender {
    RequestDownloadTask *task = [[RequestDownloadTask alloc]init];
    task.delegate = self;
    task.outFilePath=[NSString stringWithFormat:@"%@/Documents/aabbcc1.mov",NSHomeDirectory()];
//    task.url=@"http://222.186.30.212:8082/demo_store/2016/01/13/82306fdafeb75e8558cbfb41279d04e9.mp3";
    task.url=@"http://resource.jimicloud.com/www/20160310.mov";
    [manager addTask:@"test" Obj:task];
    [manager startTask:@"test"];
}

- (IBAction)onStop:(id)sender {
    [manager stopTask:@"test"];
}

//开始下载
-(void)downloadBegin:(RequestDownloadTask*)objTask
{
    NSLog(@"downloadBegin");
}

//进度发生变化
-(void)changeProgress:(NSInteger)progress
                  obj:(RequestDownloadTask*)objTask
{
    self.display.text = [NSString stringWithFormat:@"%ld%",progress];
}

//状态发生变化
-(void)changeState:(RequestDownloadTask*)objTask
{
     NSLog(@"changeState");
}

//下载完成
-(void)downloadDone:(RequestDownloadTask*)objTask
{
    self.display.text =@"下载完成";
}

@end
