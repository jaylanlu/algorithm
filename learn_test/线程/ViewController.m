//
//  ViewController.m
//  线程
//
//  Created by Jaylan on 2018/11/26.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self func2];
}

//pthread
- (void)func1 {
    pthread_t thread;
    pthread_create(&thread, NULL, start, NULL);
}

void *start(void *data) {
    NSLog(@"%@",[NSThread currentThread]);
    return NULL;
}

//NSThread,面向对象，但生命周期需要手动管理
- (void)func2 {
    //1.先创建，再启动
    //    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    //    [thread start];
    
    //2.创建并自动启动
    //        [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
    
    //3.使用NSObject的方法创建并自动启用
    [self performSelectorInBackground:@selector(run) withObject:nil];
}

- (void)run {
    NSLog(@"%@",[NSThread currentThread]);
}

//GCD,会自动合理地利用更多的CPU内核，能自动管理生命周期（创建线程、调度任务、销毁线程），也是C语言
- (void)func3 {
    dispatch_sync(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
}

@end
