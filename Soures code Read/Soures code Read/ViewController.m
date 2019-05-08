//
//  ViewController.m
//  Soures code Read
//
//  Created by Jaylan on 2019/4/25.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "ViewController.h"

typedef void(^Task)(BOOL);
typedef void(^Blk)(void);
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Task task = [self delay:10 task:^{
        NSLog(@"sfas");
    }];
    task(false);
}

- (Task)delay:(NSTimeInterval)time task:(Blk)task {
    __block Task result;
    __block Blk closure = task;
    Task delayBlock = ^(BOOL cancel){
        if (closure) {
            Blk internalBlock = closure;
            if (!cancel) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    internalBlock();
                });
            }
            closure = nil;
        }
        result = nil;
    };
    result = delayBlock;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (result) {
            result(false);
        }
    });
    return result;
    
}


@end
