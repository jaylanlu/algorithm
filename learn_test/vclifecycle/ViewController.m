//
//  ViewController.m
//  vclifecycle
//
//  Created by Jaylan on 2019/3/4.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"init-1");
    }
    return self;
}

- (void)loadView {
    [super loadView];
    NSLog(@"loadView-1");
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40, 40, 50, 30)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnTap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnTap {
    SecondViewController *second = [SecondViewController new];
    [self presentViewController:second animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad-1");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear-1");
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews-1");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews-1");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear-1");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear-1");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear-1");
}


@end
