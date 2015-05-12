//
//  HWYScheduleTableViewCell.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/20.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYScheduleTableViewCell.h"

@implementation HWYScheduleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        
        _imageCourse = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 69)];
        [self.contentView addSubview:_imageCourse];
        
        _course = [[UILabel alloc] initWithFrame:CGRectMake(50, 3, 265, 21)];
        _course.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_course];
        
        _teacher = [[UILabel alloc] initWithFrame:CGRectMake(50, 24, 50, 21)];
        _teacher.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_teacher];
        
        _room = [[UILabel alloc] initWithFrame:CGRectMake(100, 24, 50, 21)];
        _room.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_room];
        
        _time = [[UILabel alloc] initWithFrame:CGRectMake(50, 45, 50, 21)];
        _time.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_time];
        
        _desc = [[UILabel alloc] initWithFrame:CGRectMake(100, 45, 50, 21)];
        _desc.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_desc];
    }
    return self;
}

- (void)configSchedule:(HWYScheduleData *)schedule {
    _course.text = schedule.course;
    
    _teacher.text = schedule.teacher;
    
    NSInteger maxX = CGRectGetMaxX(_teacher.frame);
    CGRect rect = _room.frame;
    rect.origin.x = maxX + 10;
    _room.frame = rect;
    _room.text = schedule.room;
    [_room sizeToFit];
    
    _time.text = schedule.schooltime;
    [_time sizeToFit];
    
    maxX = CGRectGetMaxX(_time.frame);
    rect = _desc.frame;
    rect.origin.x = maxX + 10;
    _desc.frame = rect;
    _desc.text = schedule.timedesc;
    [_desc sizeToFit];
}

@end
