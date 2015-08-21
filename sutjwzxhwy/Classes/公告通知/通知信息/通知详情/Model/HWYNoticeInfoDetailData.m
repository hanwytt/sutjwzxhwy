//
//  HWYNoticeInfoDetailData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/30.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNoticeInfoDetailData.h"
#import "HWYAppDefine.h"
#import "FMDB.h"

@implementation HWYNoticeInfoDetailData

+ (HWYNoticeInfoDetailData *)getNoticeInfoDetailDataFromDict:(NSDictionary *)dict {
    NSArray *arr = dict[@"list"];
    NSDictionary *dic = arr[0];
    HWYNoticeInfoDetailData *noticeInfoDetail = [[HWYNoticeInfoDetailData alloc] init];
    NSDictionary *AUDIT_TIME = dic[@"AUDIT_TIME"];
    long long seconds = [AUDIT_TIME[@"time"] longLongValue];
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:seconds/1000.0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    noticeInfoDetail.AUDIT_TIME = [dateFormat stringFromDate:nd];
    noticeInfoDetail.RESOURCE_ID = dic[@"RESOURCE_ID"];
    noticeInfoDetail.NEWS_EDITOR = dic[@"NEWS_EDITOR"];
    noticeInfoDetail.UNIT_NAME = dic[@"UNIT_NAME"];
    noticeInfoDetail.PLATE_NAME = dic[@"PLATE_NAME"];
    noticeInfoDetail.CONTENT = dic[@"CONTENT"];
    noticeInfoDetail.USER_NAME = dic[@"USER_NAME"];
    noticeInfoDetail.NEWS_REPORTER = dic[@"NEWS_REPORTER"];
    noticeInfoDetail.TITLE = dic[@"TITLE"];
    noticeInfoDetail.VIEW_COUNT = dic[@"VIEW_COUNT"];
    return noticeInfoDetail;
}

+ (void)saveNoticeInfoDetailData:(HWYNoticeInfoDetailData *)noticeInfoDetail {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    
    NSString *notice_info = @"CREATE TABLE IF NOT EXISTS notice_info (RESOURCE_ID VARCHAR PRIMARY KEY NOT NULL, SCOPE_ID VARCHAR, UNIT_NAME VARCHAR, AUDIT_TIME VARCHAR, PLATE_ID VARCHAR, PLATE_NAME VARCHAR, TITLE VARCHAR, VIEW_COUNT VARCHAR, NEWS_EDITOR VARCHAR,USER_NAME VARCHAR, NEWS_REPORTER VARCHAR, CONTENT VARCHAR)";
    BOOL result = [db executeUpdate:notice_info];
    if (!result) {
        NSLog(@"Could create table.");
        return;
    }
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM notice_info where RESOURCE_ID = ?", noticeInfoDetail.RESOURCE_ID];
    if ([rs next]) {
        [db executeUpdate:@"update notice_info set NEWS_EDITOR = ?, UNIT_NAME = ?, AUDIT_TIME = ?, PLATE_NAME = ?, CONTENT = ?, USER_NAME = ?, NEWS_REPORTER = ?, TITLE = ?, VIEW_COUNT = ? where RESOURCE_ID = ?", noticeInfoDetail.NEWS_EDITOR, noticeInfoDetail.UNIT_NAME, noticeInfoDetail.AUDIT_TIME, noticeInfoDetail.PLATE_NAME, noticeInfoDetail.CONTENT, noticeInfoDetail.USER_NAME, noticeInfoDetail.NEWS_REPORTER, noticeInfoDetail.TITLE, noticeInfoDetail.VIEW_COUNT, noticeInfoDetail.RESOURCE_ID];
    } else {
        [db executeUpdate:@"insert into notice_info (RESOURCE_ID, NEWS_EDITOR, UNIT_NAME, AUDIT_TIME, PLATE_NAME, CONTENT, USER_NAME, NEWS_REPORTER, TITLE, VIEW_COUNT) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ? , ?, ?)", noticeInfoDetail.RESOURCE_ID, noticeInfoDetail.NEWS_EDITOR, noticeInfoDetail.UNIT_NAME, noticeInfoDetail.AUDIT_TIME, noticeInfoDetail.PLATE_NAME, noticeInfoDetail.CONTENT, noticeInfoDetail.USER_NAME, noticeInfoDetail.NEWS_REPORTER, noticeInfoDetail.TITLE, noticeInfoDetail.VIEW_COUNT];
    }
    [db close];
}

+ (HWYNoticeInfoDetailData *)getNoticeInfoDetailData:(NSString *)resourceid {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM notice_info where RESOURCE_ID = ?", resourceid];
    HWYNoticeInfoDetailData *noticeInfoDetail = [HWYNoticeInfoDetailData new];
    if ([rs next]) {
        noticeInfoDetail.RESOURCE_ID = [rs stringForColumn:@"RESOURCE_ID"];
        noticeInfoDetail.NEWS_EDITOR = [rs stringForColumn:@"NEWS_EDITOR"];
        noticeInfoDetail.UNIT_NAME = [rs stringForColumn:@"UNIT_NAME"];
        noticeInfoDetail.AUDIT_TIME = [rs stringForColumn:@"AUDIT_TIME"];
        noticeInfoDetail.PLATE_NAME = [rs stringForColumn:@"PLATE_NAME"];
        noticeInfoDetail.CONTENT = [rs stringForColumn:@"CONTENT"];
        noticeInfoDetail.USER_NAME = [rs stringForColumn:@"USER_NAME"];
        noticeInfoDetail.NEWS_REPORTER = [rs stringForColumn:@"NEWS_REPORTER"];
        noticeInfoDetail.TITLE = [rs stringForColumn:@"TITLE"];
        noticeInfoDetail.VIEW_COUNT = [rs stringForColumn:@"VIEW_COUNT"];
    }
    [db close];
    return noticeInfoDetail;
}

@end
