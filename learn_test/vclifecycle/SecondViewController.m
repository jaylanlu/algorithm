//
//  SecondViewController.m
//  vclifecycle
//
//  Created by Jaylan on 2019/3/4.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"init-2");
    }
    return self;
}

- (void)loadView {
    [super loadView];
    NSLog(@"loadView-2");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad-2");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear-2");
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews-2");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews-2");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear-2");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear-2");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear-2");
}


@end
