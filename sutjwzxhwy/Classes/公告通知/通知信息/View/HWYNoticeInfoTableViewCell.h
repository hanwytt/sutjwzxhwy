//
//  HWYNoticeInfoTableViewCell.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/30.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWYNoticeInfoData.h"

@interface HWYNoticeInfoTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *TITLE;
@property (strong, nonatomic) UILabel *UNIT_NAME;
@property (strong, nonatomic) UILabel *USER_NAME;
@property (strong, nonatomic) UILabel *PLATE_NAME;
@property (strong, nonatomic) UILabel *AUDIT_TIME;
@property (strong, nonatomic) UILabel *VIEW_COUNT;

- (void)configNoticeInfo:(HWYNoticeInfoData *)noticeInfo;

@end
