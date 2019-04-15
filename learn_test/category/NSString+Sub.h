//
//  NSString+Sub.h
//  category
//
//  Created by Jaylan on 2019/3/17.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Sub)
@property (nonatomic, assign) BOOL isFood;
- (NSString *)substringFromIndex:(NSUInteger)from;
@end

NS_ASSUME_NONNULL_END
