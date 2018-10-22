//
//  ViewController.m
//  Property&Keyword
//
//  Created by Jaylan on 2018/10/17.
//  Copyright © 2018年 Jaylan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@property (nonatomic, strong, getter=getModel) NSString *str;
@end

@implementation ViewController
@synthesize finished = _finished;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.finished = YES;
//    NSLog(@"self.finished--%d--%p",self.finished,self.finished);
    NSLog(@"isFinshed--%d--%p",self.isFinished,self.isFinished);
    NSLog(@"finsihed--%d--%p",self.finished,self.finished);
    
    self.str = @"hhh";
    NSLog(@"_str--%@--%@",_str,self.str);
}


@end
