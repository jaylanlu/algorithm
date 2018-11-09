//
//  Biology.h
//  runtime
//
//  Created by Jaylan on 2018/11/7.
//  Copyright © 2018 Jaylan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Biology : NSObject
@property (nonatomic, copy) NSString *key;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
