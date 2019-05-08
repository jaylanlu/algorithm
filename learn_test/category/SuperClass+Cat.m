//
//  SuperClass+Cat.m
//  category
//
//  Created by Jaylan on 2019/4/24.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import "SuperClass+Cat.h"

@implementation SuperClass (Cat)

+ (void)load {
    NSLog(@"---%@--cat",self);
}
@end
