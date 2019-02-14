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
    [self executeNSCondition];
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


#pragma mark - 条件锁

/*NSCodition的对象实际上作为一个锁和一个线程检查器：锁主要是为了检测条件时保护数据，执行条件引发的任务；线程检查器主要是根据条件决定是否继续运行线程，即线程是否被阻塞。
 
 NSCondition同样实现了NSLocking协议，所以它和NSLock一样，也有NSLocking协议的lock和unlock方法，可以a当做NSLock来使用解决线程同步问题，用法完全一样
 
 */

- (void)getImageName:(NSMutableArray *)imageNames {
    NSCondition *lock = [[NSCondition alloc] init];
    NSString *imageName;
    [lock lock];
    if (imageNames.count > 0) {
        imageName = [imageNames lastObject];
        [imageNames removeObject:imageName];
    }
    [lock unlock];
}

- (void)executeNSCondition {
    NSCondition* lock = [[NSCondition alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSUInteger i=0; i<3; i++) {
            sleep(2);
            if (i == 2) {
                [lock lock];
                [lock broadcast];//发出条件信号，唤醒所有等待它的线程。
                NSLog(@"broadcast");
                //[lock signal];//发出信号，唤醒一个等待它的线程
                [lock unlock];
            }
            
        }
    });
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        [self threadMethodOfNSCodition:lock];
    });
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        [self threadMethodOfNSCodition:lock];
    });
    
    
}

-(void)threadMethodOfNSCodition:(NSCondition*)lock{
    [lock lock];
    [lock wait];//让当前线程处于等待状态
    NSLog(@"wait");
    [lock unlock];
    
}

/*NSCoditionLock
 lock——不分条件，若没有申请锁，直接执行代码
 unlock——不会清空条件，之后满足条件的锁还会执行
 unlockWithCodition——设置解锁条件（同一时刻只有一个条件，若已经设置，则修改条件）
 lockWhenCondition——满足特定条件，执行相应代码
 NSConditionLock实现了NSLocking协议
 */

- (void)executeNSConditionLock {
    NSConditionLock* lock = [[NSConditionLock alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSUInteger i=0; i<3; i++) {
            sleep(2);
            if (i == 2) {
                [lock lock];
                [lock unlockWithCondition:i];
            }
            
        }
    });
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        [self threadMethodOfNSCoditionLock:lock];
    });
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(1);
        [self threadMethodOfNSCoditionLock:lock];
    });
    
    
}

-(void)threadMethodOfNSCoditionLock:(NSConditionLock*)lock{
    [lock lockWhenCondition:2];
    [lock unlock];
    
}

/*POSIX Conditions
 POSIX条件锁需要互斥锁和条件两项来实现，虽然看起来没什么关系，但运行中，互斥锁将会与条件结合起来。线程将会被一个互斥和条件结合的信号唤醒。
 首先初始化条件和互斥锁，当ready_to_go为flase的时候，进入循环，然后线程将会被挂起，直到另一个线程将read_to_go设置为true的时候，并且发送信号的时候，该线程才会被唤醒。
 */

pthread_mutex_t mutex;
pthread_cond_t condition;
Boolean     ready_to_go = true;
void MyCondInitFunction()
{
    pthread_mutex_init(&mutex, NULL);
    pthread_cond_init(&condition, NULL);
}
void MyWaitOnConditionFunction()
{
    // Lock the mutex.
    pthread_mutex_lock(&mutex);
    // If the predicate is already set, then the while loop is bypassed;
    // otherwise, the thread sleeps until the predicate is set.
    while(ready_to_go == false)
    {
        pthread_cond_wait(&condition, &mutex);
    }
    // Do work. (The mutex should stay locked.)
    // Reset the predicate and release the mutex.
    ready_to_go = false;
    pthread_mutex_unlock(&mutex);
}
void SignalThreadUsingCondition()
{
    // At this point, there should be work for the other thread to do.
    pthread_mutex_lock(&mutex);
    ready_to_go = true;
    // Signal the other thread to begin work.
    pthread_cond_signal(&condition);
    pthread_mutex_unlock(&mutex);
}


/*
 分布式锁——分布式锁是控制分布式系统之间同步访问共享资源的一种方式。在分布式系统中，常常需要协调他们的动作。如果不同的系统或是同一个系统的不同主机之间共享一个或一组资源，那么访问这些资源的时候，往往需要互斥来防止彼此干扰来保证一致性，在这种情况下，便需要使用分布式锁
 */

/*
 NSDisTributedLock
 处理多个进程或多个程序之间互斥问题。
 一个获取锁的进程或程序在是否锁之前挂掉，锁不会被释放，可以通过breakLock方式解锁。
 */

/*读写锁
 读写锁实际是一种特殊的自旋锁，它把对共享资源的访问者划分成读者和写者，读者只对共享资源进行读访问，写者则需要对共享资源进行写操作。这种锁相对于自旋锁而言，能提高并发性，因为在多处理器系统中，它允许同时有多个读者来访问共享资源，最大可能的读者数为实际的逻辑CPU数。写者是排他性的，一个读写锁同时只能有一个写者或多个读者（与CPU数相关），但不能同时既有读者又有写者。
 
 */
@end
