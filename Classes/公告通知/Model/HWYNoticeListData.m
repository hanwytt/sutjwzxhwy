//
//  HWYSutNoticeData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/26.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNoticeListData.h"
#import "HWYAppDefine.h"
#import "FMDB.h"

@implementation HWYNoticeListData

+ (NSArray *)getNoticeListDataFromDict:(NSDictionary *)dict {
    NSMutableArray *noticeListArr = [NSMutableArray array];
    NSArray *array = dict[@"list"];
    for (NSDictionary *dic in array) {
        HWYNoticeListData *noticeList = [[HWYNoticeListData alloc] init];
        noticeList.PLATE_ID = dic[@"RESOURCE_ID"];
        noticeList.SCOPE_ID = @"1";
        noticeList.NAME = dic[@"NAME"];
        [noticeListArr addObject:noticeList];
    }
    return noticeListArr;
}

+ (void)saveNoticeListData:(NSArray *)arr {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    for (HWYNoticeListData *noticeList in arr) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM notice_list where PLATE_ID = ?", noticeList.PLATE_ID];
        if ([rs next]) {
            [db executeUpdate:@"update notice_list set SCOPE_ID = ?, NAME = ? where PLATE_ID = ?", noticeList.SCOPE_ID, noticeList.NAME, noticeList.PLATE_ID];
        } else {
            [db executeUpdate:@"insert into notice_list (PLATE_ID, SCOPE_ID, NAME) values (?, ?, ?)", noticeList.PLATE_ID, noticeList.SCOPE_ID, noticeList.NAME];
        }
    }
    [db close];
}

+ (NSArray *)getNoticeListData {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM notice_list"];
    NSMutableArray *noticeListArr = [NSMutableArray array];
    while ([rs next]) {
        HWYNoticeListData *noticeList = [[HWYNoticeListData alloc] init];
        noticeList.PLATE_ID = [rs stringForColumnIndex:0];
        noticeList.SCOPE_ID = [rs stringForColumnIndex:1];
        noticeList.NAME = [rs stringForColumnIndex:2];
        [noticeListArr addObject:noticeList];
    }
    [db close];
    return noticeListArr;
}

@end
