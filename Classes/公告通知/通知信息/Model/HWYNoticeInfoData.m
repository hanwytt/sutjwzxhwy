//
//  HWYNoticeInfoData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/30.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNoticeInfoData.h"
#import "HWYAppDefine.h"
#import "FMDB.h"

@implementation HWYNoticeInfoData

+ (NSArray *)getNoticeInfoFromDict:(NSDictionary *)dict {
    NSMutableArray *noticeInfoArr = [NSMutableArray array];
    NSArray *array = dict[@"list"];
    for (NSDictionary *dic in array) {
        HWYNoticeInfoData *noticeInfo = [[HWYNoticeInfoData alloc] init];
        NSDictionary *AUDIT_TIME = dic[@"AUDIT_TIME"];
        long long seconds = [AUDIT_TIME[@"time"] longLongValue];
        NSDate *nd = [NSDate dateWithTimeIntervalSince1970:seconds/1000.0];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        noticeInfo.AUDIT_TIME = [dateFormat stringFromDate:nd];
        NSDictionary *PK = dic[@"PK"];
        noticeInfo.RESOURCE_ID = PK[@"RESOURCE_ID"];
        noticeInfo.SCOPE_ID = PK[@"SCOPE_ID"];
        noticeInfo.UNIT_NAME = dic[@"UNIT_NAME"];
        noticeInfo.PLATE_ID = dic[@"PLATE_ID"];
        noticeInfo.PLATE_NAME = dic[@"PLATE_NAME"];
        noticeInfo.TITLE = dic[@"TITLE"];
        noticeInfo.VIEW_COUNT = dic[@"VIEW_COUNT"];
        noticeInfo.USER_NAME = dic[@"USER_NAME"];
        [noticeInfoArr addObject:noticeInfo];
    }
    return noticeInfoArr;
}

+ (void)saveNoticeInfoData:(NSArray *)arr {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    for (HWYNoticeInfoData *noticeInfo in arr) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM notice_info where RESOURCE_ID = ?", noticeInfo.RESOURCE_ID];
        if ([rs next]) {
            [db executeUpdate:@"update notice_info set SCOPE_ID = ?,UNIT_NAME = ?, AUDIT_TIME = ?, PLATE_ID = ?, PLATE_NAME = ?, TITLE = ?, VIEW_COUNT = ?, USER_NAME = ?  where  RESOURCE_ID = ?", noticeInfo.SCOPE_ID, noticeInfo.UNIT_NAME, noticeInfo.AUDIT_TIME, noticeInfo.PLATE_ID, noticeInfo.PLATE_NAME, noticeInfo.TITLE, noticeInfo.VIEW_COUNT, noticeInfo.USER_NAME, noticeInfo.RESOURCE_ID];
        } else {
            [db executeUpdate:@"insert into notice_info (RESOURCE_ID, SCOPE_ID, UNIT_NAME, AUDIT_TIME, PLATE_ID, PLATE_NAME, TITLE, VIEW_COUNT, USER_NAME) values (?, ?, ?, ?, ?, ?, ?, ?, ?)", noticeInfo.RESOURCE_ID, noticeInfo.SCOPE_ID, noticeInfo.UNIT_NAME, noticeInfo.AUDIT_TIME, noticeInfo.PLATE_ID, noticeInfo.PLATE_NAME, noticeInfo.TITLE, noticeInfo.VIEW_COUNT, noticeInfo.USER_NAME];
        }
    }
    [db close];
}

+ (NSArray *)getNoticeInfoData:(NSString *)plateid {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    
    FMResultSet *rs = nil;
    if ([plateid isEqualToString:@""]) {
        rs = [db executeQuery:@"SELECT * FROM notice_info ORDER BY AUDIT_TIME DESC"];
    } else {
        rs = [db executeQuery:@"SELECT * FROM notice_info where PLATE_ID = ? ORDER BY AUDIT_TIME DESC", plateid];
    }
    NSMutableArray *noticeInfoArr = [NSMutableArray array];
    while ([rs next]) {
        HWYNoticeInfoData *noticeInfo = [[HWYNoticeInfoData alloc] init];
        noticeInfo.RESOURCE_ID = [rs stringForColumnIndex:0];
        noticeInfo.SCOPE_ID = [rs stringForColumnIndex:1];
        noticeInfo.UNIT_NAME = [rs stringForColumnIndex:2];
        noticeInfo.AUDIT_TIME = [rs stringForColumnIndex:3];
        noticeInfo.PLATE_ID = [rs stringForColumnIndex:4];
        noticeInfo.PLATE_NAME = [rs stringForColumnIndex:5];
        noticeInfo.TITLE = [rs stringForColumnIndex:6];
        noticeInfo.VIEW_COUNT = [rs stringForColumnIndex:7];
        noticeInfo.USER_NAME = [rs stringForColumnIndex:9];
        [noticeInfoArr addObject:noticeInfo];
    }
    [db close];
    return noticeInfoArr;
}

@end
