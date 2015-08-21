//
//  HWYNewsTableViewCell.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/29.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWYNewsInfoData.h"

@interface HWYNewsInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *TITLE;
@property (strong, nonatomic) UILabel *UNIT_NAME;
@property (strong, nonatomic) UILabel *PLATE_NAME;
@property (strong, nonatomic) UILabel *AUDIT_TIME;
@property (strong, nonatomic) UILabel *VIEW_COUNT;

- (void)configNewsInfo:(HWYNewsInfoData *)newsInfo;

@end
