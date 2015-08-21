//
//  HWYNewsTableViewCell.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/29.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNewsInfoTableViewCell.h"
#import "HWYAppDefine.h"

@implementation HWYNewsInfoTableViewCell

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
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        
        UIView *selectView = [[UIView alloc] initWithFrame:self.frame];
        selectView.backgroundColor = KCellSelectedColor;
        self.selectedBackgroundView = selectView;
        
        _TITLE = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, 285, 21)];
        _TITLE.font = [UIFont systemFontOfSize:15.0];
        _TITLE.numberOfLines = 0;
        [self.contentView addSubview:_TITLE];
        
        _UNIT_NAME = [[UILabel alloc] initWithFrame:CGRectMake(5, 24, 140, 21)];
        _UNIT_NAME.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_UNIT_NAME];
        
        _PLATE_NAME = [[UILabel alloc] initWithFrame:CGRectMake(150, 24, 140, 21)];
        _PLATE_NAME.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_PLATE_NAME];
        
        _AUDIT_TIME = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, 150, 21)];
        _AUDIT_TIME.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_AUDIT_TIME];

        _VIEW_COUNT = [[UILabel alloc] initWithFrame:CGRectMake(150, 45, 140, 21)];
        _VIEW_COUNT.font = [UIFont systemFontOfSize:13.0];
        _VIEW_COUNT.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_VIEW_COUNT];
        
        CGRect rect = self.frame;
        rect.size.height = 66;
        self.frame = rect;
    }
    return self;
}

- (void)configNewsInfo:(HWYNewsInfoData *)newsInfo {
    _TITLE.text = newsInfo.TITLE;
    [_TITLE sizeToFit];
    
    NSInteger maxY = CGRectGetMaxY(_TITLE.frame) + 5;
    CGRect rect = _UNIT_NAME.frame;
    rect.origin.y = maxY;
    _UNIT_NAME.frame = rect;
    _UNIT_NAME.text = newsInfo.UNIT_NAME;
    [_UNIT_NAME sizeToFit];

    NSInteger maxX = CGRectGetMaxX(_UNIT_NAME.frame) + 10;
    rect = _PLATE_NAME.frame;
    rect.origin.y = maxY;
    rect.origin = CGPointMake(maxX, maxY);
    _PLATE_NAME.frame = rect;
    _PLATE_NAME.text = [NSString stringWithFormat:@"分类:%@", newsInfo.PLATE_NAME];
    [_PLATE_NAME sizeToFit];
    
    maxY = CGRectGetMaxY(_UNIT_NAME.frame);
    rect = _AUDIT_TIME.frame;
    rect.origin.y = maxY;
    _AUDIT_TIME.frame = rect;
    _AUDIT_TIME.text = newsInfo.AUDIT_TIME;

    rect = _VIEW_COUNT.frame;
    rect.origin.y = maxY;
    _VIEW_COUNT.frame = rect;
    _VIEW_COUNT.text = [NSString stringWithFormat:@"访问量:%@", newsInfo.VIEW_COUNT];
    
    maxY = CGRectGetMaxY(_VIEW_COUNT.frame) + 3;
    rect = self.frame;
    rect.size.height = maxY;
    self.frame = rect;
}

@end
