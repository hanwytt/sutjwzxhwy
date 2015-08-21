//
//  HWYNoticeInfoDetailData.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/30.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYNoticeInfoDetailData : NSObject

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

+ (HWYNoticeInfoDetailData *)getNoticeInfoDetailDataFromDict:(NSDictionary *)dict;
+ (void)saveNoticeInfoDetailData:(HWYNoticeInfoDetailData *)noticeInfoDetail;
+ (HWYNoticeInfoDetailData *)getNoticeInfoDetailData:(NSString *)resourceid;

@end
