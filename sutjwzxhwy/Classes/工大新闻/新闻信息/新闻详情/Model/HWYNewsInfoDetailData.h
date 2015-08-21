//
//  HWYSutNewsDetailData.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/28.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYNewsInfoDetailData : NSObject

@property (copy, nonatomic) NSString *RESOURCE_ID;
@property (copy, nonatomic) NSString *NEWS_EDITOR;
@property (copy, nonatomic) NSString *UNIT_NAME;
@property (copy, nonatomic) NSString *AUDIT_TIME;
@property (copy, nonatomic) NSString *PLATE_NAME;
@property (copy, nonatomic) NSString *CONTENT;
@property (copy, nonatomic) NSString *USER_NAME;
@property (copy, nonatomic) NSString *NEWS_REPORTER;
@property (copy, nonatomic) NSString *TITLE;
@property (copy, nonatomic) NSString *VIEW_COUNT;
@property (assign, nonatomic) Boolean IS_TOP;
@property (assign, nonatomic) Boolean IS_IMPORTANT;

+ (HWYNewsInfoDetailData *)getNewsInfoDetailDataFromDict:(NSDictionary *)dict;
+ (void)saveNewsInfoDetailData:(HWYNewsInfoDetailData *)newsInfoDetail;
+ (HWYNewsInfoDetailData *)getNewsInfoDetailData:(NSString *)resourceid;

@end
