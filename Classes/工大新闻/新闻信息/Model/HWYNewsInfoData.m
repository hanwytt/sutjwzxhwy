//
//  HWYSutNewsData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/26.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNewsInfoData.h"
#import "HWYAppDefine.h"
#import "FMDB.h"

@implementation HWYNewsInfoData

+ (NSArray *)getNewsInfoFromDict:(NSDictionary *)dict {
    NSMutableArray *newsInfoArr = [NSMutableArray array];
    NSArray *array = dict[@"list"];
    for (NSDictionary *dic in array) {
        HWYNewsInfoData *newsInfo = [[HWYNewsInfoData alloc] init];
        NSDictionary *AUDIT_TIME = dic[@"AUDIT_TIME"];
        long long seconds = [AUDIT_TIME[@"time"] longLongValue];
        NSDate *nd = [NSDate dateWithTimeIntervalSince1970:seconds/1000.0];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        newsInfo.AUDIT_TIME = [dateFormat stringFromDate:nd];
        NSDictionary *PK = dic[@"PK"];
        newsInfo.RESOURCE_ID = PK[@"RESOURCE_ID"];
        newsInfo.SCOPE_ID = PK[@"SCOPE_ID"];
        newsInfo.UNIT_NAME = dic[@"UNIT_NAME"];
        newsInfo.PLATE_ID = dic[@"PLATE_ID"];
        newsInfo.PLATE_NAME = dic[@"PLATE_NAME"];
        newsInfo.TITLE = dic[@"TITLE"];
        newsInfo.VIEW_COUNT = dic[@"VIEW_COUNT"];
        [newsInfoArr addObject:newsInfo];
    }
    return newsInfoArr;
}

+ (void)saveNewsInfoData:(NSArray *)arr type:(NSInteger)type {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    
    NSString *news_info = @"CREATE TABLE IF NOT EXISTS news_info (RESOURCE_ID VARCHAR PRIMARY KEY NOT NULL, SCOPE_ID VARCHAR, UNIT_NAME VARCHAR, AUDIT_TIME VARCHAR, PLATE_ID VARCHAR, PLATE_NAME VARCHAR, TITLE VARCHAR, VIEW_COUNT VARCHAR, IS_TOP BOOLEAN, IS_IMPORTANT BOOLEAN, NEWS_EDITOR VARCHAR,USER_NAME VARCHAR, NEWS_REPORTER VARCHAR, CONTENT VARCHAR)";
    BOOL result = [db executeUpdate:news_info];
    if (!result) {
        NSLog(@"Could create table.");
        return;
    }
    
    for (HWYNewsInfoData *newsInfo in arr) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM news_info where RESOURCE_ID = ?", newsInfo.RESOURCE_ID];
        if ([rs next]) {
            switch (type) {
                case 0:
                    [db executeUpdate:@"update news_info set SCOPE_ID = ?,UNIT_NAME = ?, AUDIT_TIME = ?, PLATE_ID = ?, PLATE_NAME = ?, TITLE = ?, VIEW_COUNT = ? where  RESOURCE_ID = ?", newsInfo.SCOPE_ID, newsInfo.UNIT_NAME, newsInfo.AUDIT_TIME, newsInfo.PLATE_ID, newsInfo.PLATE_NAME, newsInfo.TITLE, newsInfo.VIEW_COUNT, newsInfo.RESOURCE_ID];
                    break;
                case 1:
                    [db executeUpdate:@"update news_info set SCOPE_ID = ?,UNIT_NAME = ?, AUDIT_TIME = ?, PLATE_ID = ?, PLATE_NAME = ?, TITLE = ?, VIEW_COUNT = ?, IS_IMPORTANT = 1 where  RESOURCE_ID = ?", newsInfo.SCOPE_ID, newsInfo.UNIT_NAME, newsInfo.AUDIT_TIME, newsInfo.PLATE_ID, newsInfo.PLATE_NAME, newsInfo.TITLE, newsInfo.VIEW_COUNT, newsInfo.RESOURCE_ID];
                    break;
                case 2:
                    [db executeUpdate:@"update news_info set SCOPE_ID = ?,UNIT_NAME = ?, AUDIT_TIME = ?, PLATE_ID = ?, PLATE_NAME = ?, TITLE = ?, VIEW_COUNT = ?, IS_TOP = 1 where  RESOURCE_ID = ?", newsInfo.SCOPE_ID, newsInfo.UNIT_NAME, newsInfo.AUDIT_TIME, newsInfo.PLATE_ID, newsInfo.PLATE_NAME, newsInfo.TITLE, newsInfo.VIEW_COUNT, newsInfo.RESOURCE_ID];
                    break;
                default:
                    break;
            }
        } else {
            [db executeUpdate:@"insert into news_info (RESOURCE_ID, SCOPE_ID, UNIT_NAME, AUDIT_TIME, PLATE_ID, PLATE_NAME, TITLE, VIEW_COUNT, IS_TOP, IS_IMPORTANT) values (?, ?, ?, ?, ?, ?, ?, ?, 0, 0)", newsInfo.RESOURCE_ID, newsInfo.SCOPE_ID, newsInfo.UNIT_NAME, newsInfo.AUDIT_TIME, newsInfo.PLATE_ID, newsInfo.PLATE_NAME, newsInfo.TITLE, newsInfo.VIEW_COUNT];
        }
    }
    [db close];
}

+ (NSArray *)getNewsInfoData:(NSString *)plateid type:(NSInteger)type{
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    FMResultSet *rs = nil;
    switch (type) {
        case 0:
            if ([plateid isEqualToString:@""]) {
                rs = [db executeQuery:@"SELECT * FROM news_info ORDER BY AUDIT_TIME DESC"];
            } else {
                rs = [db executeQuery:@"SELECT * FROM news_info where PLATE_ID = ? ORDER BY AUDIT_TIME DESC", plateid];
            }
            break;
        case 1:
            rs = [db executeQuery:@"SELECT * FROM news_info where IS_IMPORTANT = 1 ORDER BY AUDIT_TIME DESC"];
            break;
        case 2:
            rs = [db executeQuery:@"SELECT * FROM news_info where IS_TOP = 1 ORDER BY AUDIT_TIME DESC"];
            break;
        default:
            break;
    }
    NSMutableArray *newsInfoArr = [NSMutableArray array];
    while ([rs next]) {
        HWYNewsInfoData *newsInfo = [[HWYNewsInfoData alloc] init];
        newsInfo.RESOURCE_ID = [rs stringForColumnIndex:0];
        newsInfo.SCOPE_ID = [rs stringForColumnIndex:1];
        newsInfo.UNIT_NAME = [rs stringForColumnIndex:2];
        newsInfo.AUDIT_TIME = [rs stringForColumnIndex:3];
        newsInfo.PLATE_ID = [rs stringForColumnIndex:4];
        newsInfo.PLATE_NAME = [rs stringForColumnIndex:5];
        newsInfo.TITLE = [rs stringForColumnIndex:6];
        newsInfo.VIEW_COUNT = [rs stringForColumnIndex:7];
        newsInfo.IS_TOP = [rs boolForColumnIndex:8];
        newsInfo.IS_IMPORTANT = [rs boolForColumnIndex:9];
        [newsInfoArr addObject:newsInfo];
    }
    [db close];
    return newsInfoArr;
}

@end
