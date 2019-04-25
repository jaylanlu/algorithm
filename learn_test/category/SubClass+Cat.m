//
//  SubClass+Cat.m
//  category
//
//  Created by Jaylan on 2019/4/24.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "SubClass+Cat.h"

@implementation SubClass (Cat)

+ (void)load {
    NSLog(@"---%@--cat",self);
}
@end
