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
    
    [self func4];
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
    dispatch_queue_t queue = dispatch_queue_create("text", DISPATCH_QUEUE_CONCURRENT);
    NSLog(@"%@",queue);
    dispatch_async(queue, ^{
        NSLog(@"异步执行");
        NSLog(@"%@",queue);
        dispatch_sync(queue, ^{
            NSLog(@"同步串行");
        });
    });
    
    
//    NSLog(@"%@",[NSThread mainThread]);
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"同步主队列");
//    });
}

- (void)func4 {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t global = dispatch_get_global_queue(0, 0);
    dispatch_group_async(group, global, ^{
        for (int idx = 0; idx < 3; idx ++) {
            sleep(1);
            NSLog(@"group-%d-%@",idx,[NSThread currentThread]);
        }
    });
    dispatch_group_async(group, global, ^{
        for (int idx = 0; idx < 5; idx ++) {
            sleep(2);
            NSLog(@"group-%d-%@",idx,[NSThread currentThread]);
        }
    });
    dispatch_group_async(group, global, ^{
        for (int idx = 0; idx < 8; idx ++) {
            sleep(3);
            NSLog(@"group-%d-%@",idx,[NSThread currentThread]);
        }
    });
//    dispatch_group_notify(group, global, ^{
//        NSLog(@"group-notify");
//    });
    //不能放在主线程上面运用
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);//DISPATCH_TIME_NOW
    NSLog(@"now");
}

@end
