//
//  ViewController.m
//  learn_test
//
//  Created by Jaylan on 2018/10/17.
//  Copyright © 2018年 Jaylan. All rights reserved.
//

#import "ViewController.h"

static NSString *const global_notification = @"global_notification";
static NSString *const main_notification = @"main_notification";
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNoti];
    [self postNoti];
    
    
}

- (void)addNoti {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(globalNotiAction:) name:global_notification object:self];
    [[NSNotificationCenter defaultCenter] addObserverForName:global_notification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"收到了通知，当前线程为--%@",[NSThread currentThread]);
    }];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainNotiAction:) name:main_notification object:self];
}

- (void)postNoti {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"发送通知，当前线程为--%@",[NSThread currentThread]);
        [[NSNotificationCenter defaultCenter] postNotificationName:global_notification object:self];
    });
    
//    NSLog(@"发送通知，当前线程为--%@",[NSThread currentThread]);
//    [[NSNotificationCenter defaultCenter] postNotificationName:main_notification object:self];
}

- (void)globalNotiAction:(NSNotification *)notification {
    NSLog(@"收到了通知，当前线程为--%@",[NSThread currentThread]);
}
//
//- (void)mainNotiAction:(NSNotification *)notification {
//    NSLog(@"收到了通知，当前线程为--%@",[NSThread currentThread]);
//}





@end
