//
//  HWYOneCardTableViewCell.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/19.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYOneCardTableViewCell.h"
#import "HWYAppDefine.h"

@implementation HWYOneCardTableViewCell

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
        selectView.backgroundColor = KCellSelectedColor;
        self.selectedBackgroundView = selectView;
        
        UILabel *ZDMCTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 75, 21)];
        ZDMCTitle.font = [UIFont systemFontOfSize:15.0];
        ZDMCTitle.textAlignment = NSTextAlignmentRight;
        ZDMCTitle.text = @"终端名称:";
        [self.contentView addSubview:ZDMCTitle];
        _ZDMC = [[UILabel alloc] initWithFrame:CGRectMake(80, 3, 100, 21)];
        _ZDMC.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_ZDMC];
        
        UILabel *timeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 75, 21)];
        timeTitle.font = [UIFont systemFontOfSize:15.0];
        timeTitle.textAlignment = NSTextAlignmentRight;
        timeTitle.text = @"交易日期:";
        [self.contentView addSubview:timeTitle];
        _time = [[UILabel alloc] initWithFrame:CGRectMake(80, 24, 100, 21)];
        _time.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_time];
        
        UILabel *JYTitle = [[UILabel alloc] initWithFrame:CGRectMake(185, 13, 75, 21)];
        JYTitle.font = [UIFont systemFontOfSize:15.0];
        JYTitle.textAlignment = NSTextAlignmentRight;
        JYTitle.text = @"交易金额:";
        [self.contentView addSubview:JYTitle];
        _JE = [[UILabel alloc] initWithFrame:CGRectMake(260, 13, 55, 21)];
        _JE.font = [UIFont systemFontOfSize:17.0];
        _JE.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_JE];
    }
    return self;
}

- (void)configOneCardRecord:(HWYOneCardRecordData *)oneCardRecord {
    _ZDMC.text = oneCardRecord.ZDMC;
    _time.text = oneCardRecord.time;
    _JE.text = oneCardRecord.JE;
}

@end
