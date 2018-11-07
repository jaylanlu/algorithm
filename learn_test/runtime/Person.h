//
//  Person.h
//  runtime
//
//  Created by Jaylan on 2018/11/5.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Biology.h"

typedef NS_ENUM(NSInteger,gender) {
    kMale,
    kFemale
};

NS_ASSUME_NONNULL_BEGIN

@interface Person : Biology
@property (nonatomic,copy) NSString *name;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, assign) gender *gender;
@end

NS_ASSUME_NONNULL_END
