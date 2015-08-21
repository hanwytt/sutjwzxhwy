//
//  HWYOneCardTableViewCell.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/19.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWYOneCardData.h"

@interface HWYOneCardTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *ZDMC;
@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) UILabel *JE;

- (void)configOneCardRecord:(HWYOneCardRecordData *)oneCardRecord;

@end
