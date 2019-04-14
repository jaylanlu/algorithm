//
//  ViewController.m
//  源码探索
//
//  Created by Jaylan on 2019/4/14.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
@interface ViewController ()
@property (nonatomic, strong) NSString *ss;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Person *person = [[Person alloc] init];
    person.lastName = @"adfas";
}

- (void)setSs:(NSString *)ss {
    @synchronized (self) {
        _ss = @"safdsadf";
    }
}


@end
