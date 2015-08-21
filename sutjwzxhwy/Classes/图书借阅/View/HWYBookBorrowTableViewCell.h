//
//  HWYBookBorrowTableViewCell.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/19.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWYBookBorrowData.h"

@interface HWYBookBorrowTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *propNoTitle;
@property (strong, nonatomic) UILabel *mTitleTitle;
@property (strong, nonatomic) UILabel *mAuthorTitle;
@property (strong, nonatomic) UILabel *lendDateTitle;
@property (strong, nonatomic) UILabel *normRetDateTitle;
@property (strong, nonatomic) UILabel *propNo;
@property (strong, nonatomic) UILabel *mTitle;
@property (strong, nonatomic) UILabel *mAuthor;
@property (strong, nonatomic) UILabel *lendDate;
@property (strong, nonatomic) UILabel *normRetDate;

- (void)configBookBorrow:(HWYBookBorrowData *)bookBorrow;

@end
