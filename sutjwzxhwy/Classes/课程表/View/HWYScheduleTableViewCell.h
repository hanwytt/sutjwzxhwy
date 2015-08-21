//
//  HWYScheduleTableViewCell.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/20.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWYScheduleData.h"

@interface HWYScheduleTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *imageCourse;
@property (strong, nonatomic) UILabel *course;
@property (strong, nonatomic) UILabel *teacher;
@property (strong, nonatomic) UILabel *time;
@property (strong, nonatomic) UILabel *desc;
@property (strong, nonatomic) UILabel *room;

- (void)configSchedule:(HWYScheduleData *)schedule;

@end
