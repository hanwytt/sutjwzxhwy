//
//  HWYNewsListData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/29.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNewsListData.h"
#import "HWYAppDefine.h"
#import "FMDB.h"

@implementation HWYNewsListData

+ (NSArray *)getNewsListDataFromDict:(NSDictionary *)dict{
    NSMutableArray *newsListArr = [NSMutableArray array];
    NSArray *array = dict[@"list"];
    for (NSDictionary *dic in array) {
        HWYNewsListData *newsList = [[HWYNewsListData alloc] init];
        newsList.PLATE_ID = dic[@"RESOURCE_ID"];
        newsList.SCOPE_ID = @"1";
        newsList.PLATE_NAME = dic[@"PLATE_NAME"];
        [newsListArr addObject:newsList];
    }
    return newsListArr;
}

+ (void)saveNewsListData:(NSArray *)arr {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    
    NSString *news_list = @"CREATE TABLE IF NOT EXISTS news_list (PLATE_ID VARCHAR PRIMARY KEY NOT NULL, SCOPE_ID VARCHAR, PLATE_NAME VARCHAR)";
    BOOL result = [db executeUpdate:news_list];
    if (!result) {
        NSLog(@"Could create table.");
        return;
    }
    
    for (HWYNewsListData *newList in arr) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM news_list where PLATE_ID = ?", newList.PLATE_ID];
        if ([rs next]) {
            [db executeUpdate:@"update news_list set SCOPE_ID = ?, PLATE_NAME = ? where PLATE_ID = ?", newList.SCOPE_ID, newList.PLATE_NAME, newList.PLATE_ID];
        } else {
            [db executeUpdate:@"insert into news_list (PLATE_ID, SCOPE_ID, PLATE_NAME) values (?, ?, ?)", newList.PLATE_ID, newList.SCOPE_ID, newList.PLATE_NAME];
        }
    }
    [db close];
}

+ (NSArray *)getNewsListData {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM news_list"];
    NSMutableArray *newsListArr = [NSMutableArray array];
    while ([rs next]) {
        HWYNewsListData *newsList = [[HWYNewsListData alloc] init];
        newsList.PLATE_ID = [rs stringForColumnIndex:0];
        newsList.SCOPE_ID = [rs stringForColumnIndex:1];
        newsList.PLATE_NAME = [rs stringForColumnIndex:2];
        [newsListArr addObject:newsList];
    }
    [db close];
    return newsListArr;
}

@end
