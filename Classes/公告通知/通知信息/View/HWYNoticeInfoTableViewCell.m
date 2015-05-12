//
//  HWYNoticeInfoTableViewCell.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/30.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNoticeInfoTableViewCell.h"
#import "HWYGeneralConfig.h"

@implementation HWYNoticeInfoTableViewCell

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
        selectView.backgroundColor = _K_CELL_SELECTED_COLOR;
        self.selectedBackgroundView = selectView;
        
        _TITLE = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, 285, 21)];
        _TITLE.font = [UIFont systemFontOfSize:15.0];
        _TITLE.numberOfLines = 0;
        [self.contentView addSubview:_TITLE];
        
        _UNIT_NAME = [[UILabel alloc] initWithFrame:CGRectMake(5, 24, 140, 21)];
        _UNIT_NAME.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_UNIT_NAME];
        
        _USER_NAME = [[UILabel alloc] initWithFrame:CGRectMake(150, 24, 140, 21)];
        _USER_NAME.font = [UIFont systemFontOfSize:13.0];
        [self.contentView addSubview:_USER_NAME];
        
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

- (void)configNoticeInfo:(HWYNoticeInfoData *)noticeInfo {
    _TITLE.text = noticeInfo.TITLE;
    [_TITLE sizeToFit];
    
    NSInteger maxY = CGRectGetMaxY(_TITLE.frame) + 5;
    CGRect rect = _UNIT_NAME.frame;
    rect.origin.y = maxY;
    _UNIT_NAME.frame = rect;
    _UNIT_NAME.text = noticeInfo.UNIT_NAME;
    [_UNIT_NAME sizeToFit];
    
    NSInteger maxX = CGRectGetMaxX(_UNIT_NAME.frame) + 10;
    rect = _USER_NAME.frame;
    rect.origin.y = maxY;
    rect.origin = CGPointMake(maxX, maxY);
    _USER_NAME.frame = rect;
    _USER_NAME.text = [NSString stringWithFormat:@"发布人:%@", noticeInfo.USER_NAME];
    [_USER_NAME sizeToFit];
    
    maxY = CGRectGetMaxY(_UNIT_NAME.frame);
    rect = _AUDIT_TIME.frame;
    rect.origin.y = maxY;
    _AUDIT_TIME.frame = rect;
    _AUDIT_TIME.text = noticeInfo.AUDIT_TIME;
    
    rect = _VIEW_COUNT.frame;
    rect.origin.y = maxY;
    _VIEW_COUNT.frame = rect;
    _VIEW_COUNT.text = [NSString stringWithFormat:@"访问量:%@", noticeInfo.VIEW_COUNT];
    
    maxY = CGRectGetMaxY(_VIEW_COUNT.frame) + 3;
    rect = self.frame;
    rect.size.height = maxY;
    self.frame = rect;
}

@end
