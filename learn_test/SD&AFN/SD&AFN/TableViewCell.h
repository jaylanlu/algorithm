//
//  TableViewCell.h
//  SD&AFN
//
//  Created by Jaylan on 2018/9/29.
//  Copyright © 2018年 Jaylan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol perfecthDelegate <NSObject>

- (void)okAction;

@end

@interface TableViewCell : UITableViewCell

@end

NS_ASSUME_NONNULL_END
