//
//  ViewController.m
//  Block
//
//  Created by Jaylan on 2018/11/27.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import "ViewController.h"
typedef void(^BasicBlock)(void);
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //无返回值，无参数
    void(^block0)(void) = ^ {
        NSLog(@"this block no return value and no parameter");
    };
    block0();
    
    //无返回值，有参数
    void(^block1)(NSInteger idx) = ^(NSInteger idx) {
        NSLog(@"this block has parameter idx - %ld",(long)idx);
    };
    block1(2);
    
    //有返回值，有参数
    NSString*(^block2)(NSInteger idx) = ^(NSInteger idx) {
        NSNumber *num = [[NSNumber alloc] initWithInteger:idx];
        return num.description;
    };
    
    block2(3);
    //有返回值，无参数
    NSInteger(^block3)(void) = ^ {
        return (NSInteger)3;
    };
    block3();
}


@end
