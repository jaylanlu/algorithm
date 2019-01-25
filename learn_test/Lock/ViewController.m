//
//  ViewController.m
//  Lock
//
//  Created by Jaylan on 2018/12/27.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>

@interface ViewController ()
//copy修饰，被赋值的时候会复制一份不可变
@property (nonatomic, copy) NSString *str;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self func5];
}

//iOS中，锁分为互斥所、递归锁、信号量、条件锁、自旋锁、读写锁（一种特定的自旋锁）、分布式锁

#pragma mark - 互斥所 - 在编程中，引入对象互斥锁的概念，来保证共享数据操作的完整性。对每个对象都对应于一个可称为“互斥锁”的标记，这个标记用来保证在任一时刻，只有一个线程访问对象

//synchronized 防止多线程访问属性上比较多
- (void)setStr:(NSString *)str {
    @synchronized (self) {
        _str = str;
    }
}

//NSLock
- (void)func0 {
    typedef void(^MMBlock)(void);
    NSLock *lock = [[NSLock alloc] init];
    MMBlock block = ^{
        [lock lock];
        NSLog(@"执行操作");
        [NSThread sleepForTimeInterval:10];
        [lock unlock];
    };
    
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
            block();
    });
    dispatch_async(globalQueue, ^{
        block();
    });
}
/* 相隔10秒
 2019-01-14 11:10:40.979737+0800 Lock[2184:272962] 执行操作
 2019-01-14 11:10:50.981351+0800 Lock[2184:272963] 执行操作
 */

//pthread
- (void)func1 {
    __block pthread_mutex_t lock;
    pthread_mutex_init(&lock, false);
    
    typedef void(^MMBlock)(void);
    
    MMBlock block0 = ^{
        NSLog(@"线程0，加锁");
        pthread_mutex_lock(&lock);
        NSLog(@"线程0，睡1秒");
        pthread_mutex_unlock(&lock);
        NSLog(@"线程0,解锁");
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block0();
    });
    
    MMBlock block1 = ^{
        NSLog(@"线程1，加锁");
        pthread_mutex_lock(&lock);
        NSLog(@"线程1，睡2秒");
        pthread_mutex_unlock(&lock);
        NSLog(@"线程1,解锁");
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block1();
    });
    
    MMBlock block2 = ^{
        NSLog(@"线程2，加锁");
        pthread_mutex_lock(&lock);
        NSLog(@"线程2，睡3秒");
        pthread_mutex_unlock(&lock);
        NSLog(@"线程2,解锁");
    };
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        block2();
    });
}
/*
 睡的秒数和解锁是成对出现的
 */


#pragma mark - 递归锁 - 同一个线程可以多次加锁，不会造成死锁

//NSRecursiveLock
- (void)func2 {
    NSLock *lock = [NSLock new];//死锁
    //NSRecursiveLock *lock = [NSRecursiveLock new];//不会死锁
    /*
     2019-01-14 14:54:47.609689+0800 Lock[4582:557869] 加锁value = 3
     2019-01-14 14:54:49.613023+0800 Lock[4582:557869] 加锁value = 2
     2019-01-14 14:54:51.616887+0800 Lock[4582:557869] 加锁value = 1
     */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void(^RecursiveMethod)(int);
        
        RecursiveMethod = ^(int value) {
            [lock lock];
            if (value > 0) {
                NSLog(@"value = %d", value);
                sleep(2);
                RecursiveMethod(value - 1);//递归调用，死锁
            }
            [lock unlock];
        };
        RecursiveMethod(5);
    });
}

//pthread
- (void)func3 {

    __block pthread_mutex_t lock;
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);//递归锁
    pthread_mutex_init(&lock, &attr);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void(^RecursiveMethod)(int);
        pthread_mutex_lock(&lock);
        RecursiveMethod = ^(int value) {
            
            if (value > 0) {
                NSLog(@"加锁value = %d", value);
                sleep(2);
                RecursiveMethod(value - 1);//递归调用，死锁
            }
            pthread_mutex_unlock(&lock);
        };
        RecursiveMethod(3);
    });
}

#pragma mark - 信号量

//dispatch_semaphore_create
- (void)func4 {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"0");
        sleep(2);
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"1");
        sleep(2);
        dispatch_semaphore_signal(semaphore);
    });
}

//pthread
- (void)func5 {
   __block pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
   __block pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        pthread_mutex_lock(&mutex);
        pthread_cond_wait(&cond, &mutex);//阻塞线程
        NSLog(@"线程0：wait");
        pthread_mutex_unlock(&mutex);
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        pthread_mutex_lock(&mutex);
        NSLog(@"线程1：signal");
        pthread_cond_signal(&cond);//唤醒线程
        pthread_mutex_unlock(&mutex);
    });
    

}
/*间隔3秒
 2019-01-14 16:16:15.672672+0800 Lock[5463:813532] 线程1：signal
 2019-01-14 16:16:18.678024+0800 Lock[5463:813534] 线程0：wait
 */


@end
