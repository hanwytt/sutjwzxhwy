//
//  HWYReportCardTableViewCell.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/20.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYReportCardTableViewCell.h"
#import "HWYGeneralConfig.h"

@implementation HWYReportCardTableViewCell

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
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        
        UIView *selectView = [[UIView alloc] initWithFrame:self.frame];
        selectView.backgroundColor = _K_CELL_SELECTED_COLOR;
        self.selectedBackgroundView = selectView;
        
        _courseName = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, 265, 21)];
        _courseName.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_courseName];
        
        _periodTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 27, 20, 21)];
        _periodTitle.font = [UIFont systemFontOfSize:11.0];
        _periodTitle.text = @"学时:";
        [_periodTitle sizeToFit];
        [self.contentView addSubview:_periodTitle];
        _period = [[UILabel alloc] initWithFrame:CGRectMake(25, 27, 20, 21)];
        _period.font = [UIFont systemFontOfSize:11.0];
        [self.contentView addSubview:_period];
        
        _creditTitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 27, 20, 21)];
        _creditTitle.font = [UIFont systemFontOfSize:11.0];
        _creditTitle.text = @"学分:";
        [_creditTitle sizeToFit];
        [self.contentView addSubview:_creditTitle];
        _credit = [[UILabel alloc] initWithFrame:CGRectMake(65, 27, 20, 21)];
        _credit.font = [UIFont systemFontOfSize:11.0];
        [self.contentView addSubview:_credit];
        
        _semesterIdTitle = [[UILabel alloc] initWithFrame:CGRectMake(85, 27, 20, 21)];
        _semesterIdTitle.font = [UIFont systemFontOfSize:11.0];
        _semesterIdTitle.text = @"学期:";
        [_semesterIdTitle sizeToFit];
        [self.contentView addSubview:_semesterIdTitle];
        _semesterId = [[UILabel alloc] initWithFrame:CGRectMake(105, 27, 20, 21)];
        _semesterId.font = [UIFont systemFontOfSize:11.0];
        [self.contentView addSubview:_semesterId];
        
        _property = [[UILabel alloc] initWithFrame:CGRectMake(125, 27, 20, 21)];
        _property.font = [UIFont systemFontOfSize:11.0];
        [self.contentView addSubview:_property];
        
        _score = [[UILabel alloc] initWithFrame:CGRectMake(270, 13, 45, 21)];
        _score.font = [UIFont systemFontOfSize:17.0];
        _score.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_score];
    }
    return self;
}

- (void)configReportCard:(HWYReportCardData *)reportCard {
    _courseName.text = reportCard.courseName;
    
    NSInteger maxX = CGRectGetMaxX(_periodTitle.frame);
    CGRect rect = _period.frame;
    rect.origin.x = maxX + 3;
    _period.frame = rect;
    _period.text = reportCard.period;
    [_period sizeToFit];
    
    maxX = CGRectGetMaxX(_period.frame);
    rect = _creditTitle.frame;
    rect.origin.x = maxX + 7;
    _creditTitle.frame = rect;
    
    maxX = CGRectGetMaxX(_creditTitle.frame);
    rect = _credit.frame;
    rect.origin.x = maxX + 3;
    _credit.frame = rect;
    _credit.text = reportCard.credit;
    [_credit sizeToFit];
    
    maxX = CGRectGetMaxX(_credit.frame);
    rect = _semesterIdTitle.frame;
    rect.origin.x = maxX + 7;
    _semesterIdTitle.frame = rect;
    
    maxX = CGRectGetMaxX(_semesterIdTitle.frame);
    rect = _semesterId.frame;
    rect.origin.x = maxX + 3;
    _semesterId.frame = rect;
    _semesterId.text = reportCard.semesterId;
    [_semesterId sizeToFit];
    
    maxX = CGRectGetMaxX(_semesterId.frame);
    rect = _property.frame;
    rect.origin.x = maxX + 7;
    _property.frame = rect;
    _property.text = reportCard.property;
    [_property sizeToFit];
    
    _score.text = reportCard.score;
}

@end
