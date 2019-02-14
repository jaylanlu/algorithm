//
//  ViewController.m
//  NSURLSession
//
//  Created by Jaylan on 2019/2/12.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLSession;/*本身不会进行请求的，而是通过创建task的形式进行网络请求（resume()方法的调用），同一个NSURLSession可以创建多个task，并且这些task之间的cache和cookie是共享的。NSURLSession的使用有如下几步：
        1.创建NSURLSession对象
        2.使用NSURLSession对象创建Task
        3.启动任务
                  */
    
    NSURLSessionConfiguration;
    NSURLSessionTask;//URL session中执行的任务
    NSURLSessionDataTask;//将下载的数据直接返回到内存中
    NSURLSessionUploadTask;//在请求体重将数据上传到网络
    NSURLSessionDownloadTask;//将下载的数据存储到文件中
    
    // Do any additional setup after loading the view, typically from a nib.
    
    [self func2];
}

//get请求
- (void)func1 {
    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSession *session0 = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    
    NSURL *url = [NSURL URLWithString:@"https://appapi.to8to.com/feed/ugc/list"];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"----%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    [task resume];
}

//post 请求
- (void)func2 {
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:@"https://mobileapi.to8to.com/index.php"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"username=myName&pwd=myPsd" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"--%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }];
    [task resume];
}
@end
