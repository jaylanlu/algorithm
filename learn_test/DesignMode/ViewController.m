//
//  ViewController.m
//  DesignMode
//
//  Created by Jaylan on 2019/4/25.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import "Factory.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSObject<Shape> *obj = [Factory getShape:[Circle class]];
    [obj draw];
}



@end
