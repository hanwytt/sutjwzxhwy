//
//  HWYReportCardTableViewCell.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/20.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWYReportCardData.h"

@interface HWYReportCardTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *semesterIdTitle;
@property (strong, nonatomic) UILabel *periodTitle;
@property (strong, nonatomic) UILabel *creditTitle;
@property (strong, nonatomic) UILabel *semesterId;
@property (strong, nonatomic) UILabel *courseName;
@property (strong, nonatomic) UILabel *period;
@property (strong, nonatomic) UILabel *credit;
@property (strong, nonatomic) UILabel *property;
@property (strong, nonatomic) UILabel *score;

- (void)configReportCard:(HWYReportCardData *)reportCard;

@end
