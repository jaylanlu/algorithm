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
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self func24];
//    [self func23];
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
        NSLog(@"%@",[NSThread mainThread]);
        dispatch_sync(dispatch_get_main_queue(), ^{//会顺利执行
            NSLog(@"同步主队列");
        });
    });
    
    
    
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
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
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
    //不能放在主线程上面运用,但是若是DISPATCH_TIME_NOW的时候是可以的，now最先输出
    dispatch_group_wait(group, DISPATCH_TIME_NOW);//DISPATCH_TIME_NOW
    NSLog(@"now");
}


- (void)func5 {
    //concurrentQueue
    //    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //    dispatch_queue_t globalQueue = dispatch_queue_create("com.baidu", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t globalQueue = dispatch_queue_create("com", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(globalQueue, ^{
        sleep(4);
        NSLog(@"0");
    });
    dispatch_async(globalQueue, ^{
        NSLog(@"1");
    });
    dispatch_async(globalQueue, ^{
        NSLog(@"2");
    });
    dispatch_async(globalQueue, ^{
        NSLog(@"3");
    });
    //前面执行完后才执行后面的,必须是dispatch_queue_create生成的concurrentQueue,否则如果是serial queue or one of the global concurrent queues,就会想dispatch_async一样
    dispatch_barrier_async(globalQueue, ^{
        NSLog(@"async_barrier");
    });
    //    dispatch_sync(globalQueue, ^{
    //        NSLog(@"sync_barrier");
    //    });
    dispatch_async(globalQueue, ^{
        NSLog(@"4");
    });
    dispatch_async(globalQueue, ^{
        NSLog(@"5");
    });
    dispatch_async(globalQueue, ^{
        NSLog(@"6");
    });
    
}

- (void)func6 {
    //并不是在指定时间后执行处理，而是在指定时间追加到Queue里面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"dadadsfa");
    });
    
    //dispatch_sync和dispatch_barrier_sync函数都不能添加到主队列上，它们都是等待线程中的处理执行完毕
}

- (void)func7 {
    //也会等待处理执行结束，因此也不能直接添加到主队列中
    dispatch_apply(3, dispatch_get_global_queue(0, 0), ^(size_t idx) {
        if (idx == 0) {
            sleep(3);
        }
        NSLog(@"%zu",idx);
    });
    
    //    //serial队列中是可以的
    //    dispatch_queue_t queue = dispatch_queue_create("comm", NULL);
    //    dispatch_apply(3, queue, ^(size_t idx) {
    //        NSLog(@"%zu",idx);
    //    });
    //    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        //block 执行的顺序取决于queue是串行还是并行队列
    //        dispatch_apply(4, queue, ^(size_t idx) {
    //            if (idx == 0) {
    //                sleep(3);
    //            }
    //            NSLog(@"%zu",idx);
    //        });
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            NSLog(@"done");
    //        });
    //    });
}

- (void)func8 {
    dispatch_queue_t queue = dispatch_queue_create("com.text", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"1miao0");
    });
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"1miao1");;
    });
    [NSThread sleepForTimeInterval:1];
    dispatch_suspend(queue);//暂停队列
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"1miao2");;
    });
    NSLog(@"%@",queue);
    [NSThread sleepForTimeInterval:5];
    dispatch_resume(queue);//重启队列，加在队列里面的任务都会执行
    NSLog(@"%@",queue);
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:1];
        NSLog(@"1miao3");;
    });
}

- (void)func9 {
    //最多允许1个线程执行，所以会顺序执行
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        sleep(3);
        NSLog(@"task 1");
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        sleep(1);
        NSLog(@"task 2");
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        sleep(1);
        NSLog(@"task 3");
        dispatch_semaphore_signal(semaphore);
    });
}

- (void)func10 {
    //在APP生命周期中只执行一次
    static ViewController *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ViewController new];
    });
    
}

/*
 串行队列相当于只有一个队列，不管有多少个线程，只有一个队列FIFO，所以不管是同步执行（sync）还是异步执行（async）都是一个一个的执行
 并行队列相当于有多个对垒，若是同步执行（相当如只有一个线程），会将队列中的数据放到单线程中一个一个的执行；若是异步执行（相当如多个线程），会一起执行没哟严格的先后顺序
 同步执行——单线程
 异步执行——多线程
 */

- (void)func11 {
    __block NSInteger time = 60;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    typeof(self) __weak weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        typeof(weakSelf) __strong strongSelf = weakSelf;
        if (time <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.btn setTitle:@"重新发送" forState:UIControlStateNormal];
                [strongSelf.btn setUserInteractionEnabled:YES];
            });
        }else {
            time --;
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.btn.titleLabel.text = [NSString stringWithFormat:@"%ld秒",(long)time];
                [strongSelf.btn setTitle:[NSString stringWithFormat:@"%ld秒",(long)time] forState:UIControlStateNormal];
                [strongSelf.btn setUserInteractionEnabled:NO];
            });
            
        }
    });
    dispatch_resume(timer);
    
    
}

- (void)func12 {
    dispatch_queue_t serialQueue = dispatch_queue_create("comm", NULL);
    dispatch_queue_t globalBacgroudQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    //将globalBacgroudQueue的优先级应用于serialQueue,由于不知道应用于主队列和全局队列会出现什么问题，所以这两个队列不能指定。
    dispatch_set_target_queue(serialQueue, globalBacgroudQueue);
    
    //    /* 当将某一个Serial Queue应用到可以并行执行的多个Serial Queue上时，可以防止并行处理 */
    //    dispatch_queue_t serial = dispatch_queue_create("serial", NULL);
    //
    //    dispatch_queue_t queue1 = dispatch_queue_create("queue1", NULL);
    //    dispatch_queue_t queue2 = dispatch_queue_create("queue2", NULL);
    //    dispatch_queue_t queue3 = dispatch_queue_create("queue3", NULL);
    //
    //    dispatch_async(queue1, ^{
    //        sleep(3);
    //        NSLog(@"queue1");
    //    });
    //    dispatch_async(queue2, ^{
    //        sleep(2);
    //        NSLog(@"queue2");
    //    });
    //    dispatch_async(queue3, ^{
    //        sleep(1);
    //        NSLog(@"queue3");
    //    });//3-2-1，无序输出
    //
    //    dispatch_set_target_queue(queue1, serial);
    //    dispatch_set_target_queue(queue2, serial);
    //    dispatch_set_target_queue(queue3, serial);
    //
    //    dispatch_async(queue1, ^{
    //        sleep(3);
    //        NSLog(@"queue1");
    //    });
    //    dispatch_async(queue2, ^{
    //        sleep(2);
    //        NSLog(@"queue2");
    //    });
    //    dispatch_async(queue3, ^{
    //        sleep(1);
    //        NSLog(@"queue3");
    //    });//1-2-3顺序输出
    //
    
}

#pragma - mark  NSOperation & NSOPerationQueue
//nsoperation 是一个抽象类，通过两个子类nsinvocationoperation nsblockoperation 封装任务
- (void)func13 {
    //    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(runAction) object:nil];
    //    [operation start];
    
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"this is nsblockOperation");
    }];
    //并行无序
    [operation addExecutionBlock:^{
        sleep(1);
        NSLog(@"sleep 1");
    }];
    [operation addExecutionBlock:^{
        NSLog(@"sleep 2");
    }];
    
    //都是并行队列
    NSOperationQueue *queue = [NSOperationQueue new];
    queue.maxConcurrentOperationCount = 1;//同一时间该并行队列能执行的任务数
    
    [queue addOperation:operation];
    //    queue addOperationWithBlock:^{
    //
    //    }
    
    //    [operation start];
    
    //添加任务依赖,顺序执行
    NSBlockOperation *operation0 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"this is nsblockOperation0");
    }];
    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"this is nsblockOperation1");
    }];
    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"this is nsblockOperation2");
    }];
    [operation1 addDependency:operation0];
    [operation2 addDependency:operation1];
    NSOperationQueue *queue2 = [NSOperationQueue new];
    [queue2 addOperations:@[operation0,operation1,operation2] waitUntilFinished:NO];
    
}

- (void)runAction {
    NSLog(@"this is nsInvocationOperation");
}

- (void)func14 {
    NSLog(@"1"); // 任务1
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSLog(@"2"); // 任务2
        dispatch_sync(dispatch_get_main_queue(), ^{
            [NSThread sleepForTimeInterval:3];
            NSLog(@"3"); // 任务3
        });
        NSLog(@"4"); // 任务4
    });
    
    NSLog(@"5"); // 任务5
    

}

//醒脑
- (void)func22 {
    NSLog(@"22-0");
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            sleep(2);
            NSLog(@"22-1"   );
        });
        sleep(3);
        NSLog(@"22-2");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"22-3");
        });
    });
    sleep(5);
    NSLog(@"4");
    
    
}

- (void)func23 {
    dispatch_queue_t global = dispatch_get_global_queue(0, 0);
    NSLog(@"23-0");
    dispatch_async(global, ^{
        dispatch_async(global, ^{
            sleep(2);
            NSLog(@"23-1");
        });
        sleep(5);
        NSLog(@"23-2");
        dispatch_async(global, ^{
            sleep(1);
            NSLog(@"23-3");
        });
        sleep(0);
        NSLog(@"23-4");
    });
    sleep(1);
    
    
}

- (void)func24 {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("并行", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    //dispatch_sync 等concurrentQueue执行完之后，再在提交的线程里面执行block， 阻塞提交的线程
    dispatch_sync(concurrentQueue, ^{
        sleep(1);
        NSLog(@"---1--%@",[NSThread currentThread]);
        //---1--<NSThread: 0x600003fad400>{number = 1, name = main}
    });
    NSLog(@"1");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_sync(concurrentQueue, ^{
            NSLog(@"---2--%@",[NSThread currentThread]);
            //---2--<NSThread: 0x600003fad400>{number = 1, name = main}
        });
    });
    
    dispatch_async(globalQueue, ^{
        NSLog(@"---5--%@",[NSThread currentThread]);
        //---5--<NSThread: 0x600003ffd800>{number = 3, name = (null)}
        dispatch_sync(concurrentQueue, ^{
            sleep(5);
            NSLog(@"---3--%@",[NSThread currentThread]);
            //---3--<NSThread: 0x600003ffd800>{number = 3, name = (null)}
        });
        NSLog(@"3");
    });
    //dispatch_sync 等concurrentQueue执行完之后，再在提交的线程里面执行block
    
    dispatch_async(concurrentQueue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"---4--%@",[NSThread currentThread]);
            //---4--<NSThread: 0x600003fad400>{number = 1, name = main}
        });
    });
    //当dispatch_sync 往主队列里面提交的时候，block在主队列里面执行
    

    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"---6--%@",[NSThread currentThread]);
        //---6--<NSThread: 0x600001392880>{number = 1, name = main}
    });
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"---7--%@",[NSThread currentThread]);
        //---7--<NSThread: 0x6000013c3f40>{number = 3, name = (null)}
    });
    
    dispatch_async(globalQueue, ^{
        NSLog(@"---8--%@",[NSThread currentThread]);
        //---8--<NSThread: 0x6000013f6580>{number = 4, name = (null)}
        dispatch_async(concurrentQueue, ^{
            NSLog(@"---9--%@",[NSThread currentThread]);
            //---9--<NSThread: 0x6000013f6580>{number = 4, name = (null)}
        });
    });
    //dispatch_async 往主队列里面提交时在主队列里面执行，否则在分队列里面执行
}

- (void)func25 {
    dispatch_queue_t queue = dispatch_queue_create("并行", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
        NSLog(@"---任务0--%@",[NSThread currentThread]);
        dispatch_async(queue, ^{
            sleep(3);
            NSLog(@"任务二");
        });
        dispatch_async(queue, ^{
            sleep(2);
            NSLog(@"任务三");
        });
        //睡眠2秒
        [NSThread sleepForTimeInterval:0];
        NSLog(@"任务一");
    });
    NSLog(@"任务四");
    NSLog(@"---任务1--%@",[NSThread currentThread]);
}


@end
