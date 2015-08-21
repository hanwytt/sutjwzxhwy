//
//  HWYBookBorrowTableViewCell.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/19.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYBookBorrowTableViewCell.h"
#import "HWYAppDefine.h"

@implementation HWYBookBorrowTableViewCell

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
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsZero;
        self.layoutMargins = UIEdgeInsetsZero;
        
        UIView *selectView = [[UIView alloc] initWithFrame:self.frame];
        selectView.backgroundColor = KCellSelectedColor;
        self.selectedBackgroundView = selectView;
        
        _propNoTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 21)];
        _propNoTitle.font = [UIFont systemFontOfSize:15.0];
        _propNoTitle.textAlignment = NSTextAlignmentRight;
        _propNoTitle.text = @"条 形 码:";
        [self.contentView addSubview:_propNoTitle];
        _propNo = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 230, 21)];
        _propNo.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_propNo];
        
        _mTitleTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 21, 75, 21)];
        _mTitleTitle.font = [UIFont systemFontOfSize:15.0];
        _mTitleTitle.textAlignment = NSTextAlignmentRight;
        _mTitleTitle.text = @"书     名:";
        [self.contentView addSubview:_mTitleTitle];
        _mTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 21, 230, 21)];
        _mTitle.font = [UIFont systemFontOfSize:15.0];
        _mTitle.numberOfLines = 0;
        [self.contentView addSubview:_mTitle];
        
        _mAuthorTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 42, 75, 21)];
        _mAuthorTitle.font = [UIFont systemFontOfSize:15.0];
        _mAuthorTitle.textAlignment = NSTextAlignmentRight;
        _mAuthorTitle.text = @"作    者:";
        [self.contentView addSubview:_mAuthorTitle];
        _mAuthor = [[UILabel alloc] initWithFrame:CGRectMake(80, 42, 230, 21)];
        _mAuthor.font = [UIFont systemFontOfSize:15.0];
        _mAuthor.numberOfLines = 0;
        [self.contentView addSubview:_mAuthor];
        
        _lendDateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 63, 75, 21)];
        _lendDateTitle.font = [UIFont systemFontOfSize:15.0];
        _lendDateTitle.textAlignment = NSTextAlignmentRight;
        _lendDateTitle.text = @"借阅日期:";
        [self.contentView addSubview:_lendDateTitle];
        _lendDate = [[UILabel alloc] initWithFrame:CGRectMake(80, 63, 230, 21)];
        _lendDate.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_lendDate];
        
        _normRetDateTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, 75, 21)];
        _normRetDateTitle.font = [UIFont systemFontOfSize:15.0];
        _normRetDateTitle.textAlignment = NSTextAlignmentRight;
        _normRetDateTitle.text = @"应还日期:";
        [self.contentView addSubview:_normRetDateTitle];
        _normRetDate = [[UILabel alloc] initWithFrame:CGRectMake(80, 84, 230, 21)];
        _normRetDate.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:_normRetDate];
        
        CGRect rect = self.frame;
        rect.size.height = 105;
        self.frame = rect;
    }
    return self;
}

- (void)configBookBorrow:(HWYBookBorrowData *)bookBorrow {
    _propNo.text = bookBorrow.propNo;
    
    _mTitle.text = bookBorrow.mTitle;
    [_mTitle sizeToFit];
    
    NSInteger height = CGRectGetMaxY(_mTitle.frame);
    CGRect rect = _mAuthorTitle.frame;
    rect.origin.y = height;
    _mAuthorTitle.frame = rect;
    
    rect = _mAuthor.frame;
    rect.origin.y = height;
    _mAuthor.frame = rect;
    _mAuthor.text = bookBorrow.mAuthor;
    [_mAuthor sizeToFit];
    
    height = CGRectGetMaxY(_mAuthor.frame);
    rect = _lendDateTitle.frame;
    rect.origin.y = height;
    _lendDateTitle.frame = rect;
    
    rect = _lendDate.frame;
    rect.origin.y = height;
    _lendDate.frame = rect;
    _lendDate.text = bookBorrow.lendDate;
    
    height = CGRectGetMaxY(_lendDate.frame);
    rect = _normRetDateTitle.frame;
    rect.origin.y = height;
    _normRetDateTitle.frame = rect;
    
    rect = _normRetDate.frame;
    rect.origin.y = height;
    _normRetDate.frame = rect;
    _normRetDate.text = bookBorrow.normRetDate;
    
    height = CGRectGetMaxY(_normRetDate.frame);
    rect = self.frame;
    rect.size.height = height;
    self.frame = rect;
}

@end
