//
//  HWYSutNewsDetailData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/28.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNewsInfoDetailData.h"
#import "HWYAppDefine.h"
#import "FMDB.h"

@implementation HWYNewsInfoDetailData

+ (HWYNewsInfoDetailData *)getNewsInfoDetailDataFromDict:(NSDictionary *)dict {
    NSArray *arr = dict[@"list"];
    NSDictionary *dic = arr[0];
    HWYNewsInfoDetailData *newsInfoDetail = [[HWYNewsInfoDetailData alloc] init];
    NSDictionary *AUDIT_TIME = dic[@"AUDIT_TIME"];
    long long seconds = [AUDIT_TIME[@"time"] longLongValue];
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970:seconds/1000.0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    newsInfoDetail.AUDIT_TIME = [dateFormat stringFromDate:nd];
    newsInfoDetail.RESOURCE_ID = dic[@"RESOURCE_ID"];
    newsInfoDetail.NEWS_EDITOR = dic[@"NEWS_EDITOR"];
    newsInfoDetail.UNIT_NAME = dic[@"UNIT_NAME"];
    newsInfoDetail.PLATE_NAME = dic[@"PLATE_NAME"];
    newsInfoDetail.CONTENT = dic[@"CONTENT"];
    newsInfoDetail.USER_NAME = dic[@"USER_NAME"];
    newsInfoDetail.NEWS_REPORTER = dic[@"NEWS_REPORTER"];
    newsInfoDetail.TITLE = dic[@"TITLE"];
    newsInfoDetail.VIEW_COUNT = dic[@"VIEW_COUNT"];
    newsInfoDetail.IS_TOP = [dic[@"IS_TOP"] boolValue];
    newsInfoDetail.IS_IMPORTANT = [dic[@"IS_IMPORTANT"] boolValue];
    return newsInfoDetail;
}

+ (void)saveNewsInfoDetailData:(HWYNewsInfoDetailData *)newsInfoDetail {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    
    NSString *news_info = @"CREATE TABLE IF NOT EXISTS news_info (RESOURCE_ID VARCHAR PRIMARY KEY NOT NULL, SCOPE_ID VARCHAR, UNIT_NAME VARCHAR, AUDIT_TIME VARCHAR, PLATE_ID VARCHAR, PLATE_NAME VARCHAR, TITLE VARCHAR, VIEW_COUNT VARCHAR, IS_TOP BOOLEAN, IS_IMPORTANT BOOLEAN, NEWS_EDITOR VARCHAR,USER_NAME VARCHAR, NEWS_REPORTER VARCHAR, CONTENT VARCHAR)";
    BOOL result = [db executeUpdate:news_info];
    if (!result) {
        NSLog(@"Could create table.");
        return;
    }
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM news_info where RESOURCE_ID = ?", newsInfoDetail.RESOURCE_ID];
    if ([rs next]) {
        [db executeUpdate:@"update news_info set NEWS_EDITOR = ?, UNIT_NAME = ?, AUDIT_TIME = ?, PLATE_NAME = ?, CONTENT = ?, USER_NAME = ?, NEWS_REPORTER = ?, TITLE = ?, VIEW_COUNT = ?, IS_TOP = ?, IS_IMPORTANT = ? where RESOURCE_ID = ?", newsInfoDetail.NEWS_EDITOR, newsInfoDetail.UNIT_NAME, newsInfoDetail.AUDIT_TIME, newsInfoDetail.PLATE_NAME, newsInfoDetail.CONTENT, newsInfoDetail.USER_NAME, newsInfoDetail.NEWS_REPORTER, newsInfoDetail.TITLE, newsInfoDetail.VIEW_COUNT,[NSNumber numberWithBool:newsInfoDetail.IS_TOP], [NSNumber numberWithBool:newsInfoDetail.IS_IMPORTANT], newsInfoDetail.RESOURCE_ID];
    } else {
        [db executeUpdate:@"insert into news_info (RESOURCE_ID, NEWS_EDITOR, UNIT_NAME, AUDIT_TIME, PLATE_NAME, CONTENT, USER_NAME, NEWS_REPORTER, TITLE, VIEW_COUNT, IS_TOP, IS_IMPORTANT) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ? , ?, ?)", newsInfoDetail.RESOURCE_ID, newsInfoDetail.NEWS_EDITOR, newsInfoDetail.UNIT_NAME, newsInfoDetail.AUDIT_TIME, newsInfoDetail.PLATE_NAME, newsInfoDetail.CONTENT, newsInfoDetail.USER_NAME, newsInfoDetail.NEWS_REPORTER, newsInfoDetail.TITLE, newsInfoDetail.VIEW_COUNT,[NSNumber numberWithBool:newsInfoDetail.IS_TOP], [NSNumber numberWithBool:newsInfoDetail.IS_IMPORTANT]];
    }
    [db close];
}

+ (HWYNewsInfoDetailData *)getNewsInfoDetailData:(NSString *)resourceid {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM news_info where RESOURCE_ID = ?", resourceid];
    HWYNewsInfoDetailData *newsInfoDetail = [HWYNewsInfoDetailData new];
    if ([rs next]) {
        newsInfoDetail.RESOURCE_ID = [rs stringForColumn:@"RESOURCE_ID"];
        newsInfoDetail.NEWS_EDITOR = [rs stringForColumn:@"NEWS_EDITOR"];
        newsInfoDetail.UNIT_NAME = [rs stringForColumn:@"UNIT_NAME"];
        newsInfoDetail.AUDIT_TIME = [rs stringForColumn:@"AUDIT_TIME"];
        newsInfoDetail.PLATE_NAME = [rs stringForColumn:@"PLATE_NAME"];
        newsInfoDetail.CONTENT = [rs stringForColumn:@"CONTENT"];
        newsInfoDetail.USER_NAME = [rs stringForColumn:@"USER_NAME"];
        newsInfoDetail.NEWS_REPORTER = [rs stringForColumn:@"NEWS_REPORTER"];
        newsInfoDetail.TITLE = [rs stringForColumn:@"TITLE"];
        newsInfoDetail.VIEW_COUNT = [rs stringForColumn:@"VIEW_COUNT"];
        newsInfoDetail.IS_TOP = [rs boolForColumn:@"IS_TOP"];
        newsInfoDetail.IS_IMPORTANT = [rs boolForColumn:@"IS_IMPORTANT"];
    }
    [db close];
    return newsInfoDetail;
}

@end
