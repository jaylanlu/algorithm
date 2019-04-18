//
//  Person.m
//  源码探索
//
//  Created by Jaylan on 2019/4/14.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.lastName = @"";
    }
    return self;
}

- (void)setLastName:(NSString *)lastName {
    NSLog(@"🔴类名与方法名：%s（在第%d行），描述：%@", __PRETTY_FUNCTION__, __LINE__, @"根本不会调用这个方法");
    _lastName = @"炎黄";
}
@end
