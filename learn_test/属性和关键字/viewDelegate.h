//
//  viewDelegate.h
//  NotificationCenter
//
//  Created by Jaylan on 2019/4/14.
//  Copyright © 2019 Jaylan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol viewDelegate <NSObject>
@property (nonatomic, strong) NSString *b;
- (void)delegateFunc;
@end

NS_ASSUME_NONNULL_END
