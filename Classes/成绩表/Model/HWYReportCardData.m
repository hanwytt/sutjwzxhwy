//
//  HWYReportCardsData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYReportCardData.h"
#import "HWYAnalysisHtml.h"
#import "HWYAppDefine.h"
#import "FMDB.h"

@implementation HWYReportCountData

+ (HWYReportCountData *)getReportCountFromHtml:(id)responseObject; {
    NSArray *reportCountArr = [HWYAnalysisHtml getReportCountArrWithHttp:responseObject];
    HWYReportCountData *reportCount = [HWYReportCountData new];
    reportCount.stuCount = reportCountArr[0];
    reportCount.bxCount = reportCountArr[1];
    reportCount.xxCount = reportCountArr[2];
    reportCount.rxCount = reportCountArr[3];
    return reportCount;
}

+ (void)saveReportCountData:(HWYReportCountData *)reportCount {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    NSString *number = [KUserDefaults valueForKey:KDefaultNumber];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_report_count where number = ?", number];
    if ([rs next]) {
        [db executeUpdate:@"update jwzx_report_count set bxCount = ?, xxCount = ?,rxCount = ?, stuCount = ? where number = ?", reportCount.bxCount, reportCount.xxCount, reportCount.rxCount, reportCount.stuCount, number];
    } else {
        [db executeUpdate:@"insert into jwzx_report_count (number, bxCount, xxCount, rxCount, stuCount) values (?, ?, ?, ?, ?)", number, reportCount.bxCount, reportCount.xxCount, reportCount.rxCount, reportCount.stuCount];
    }
    [db close];
}

+ (HWYReportCountData *)getReportCountData {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    NSString *number = [KUserDefaults valueForKey:KDefaultNumber];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_report_count where number = ?", number];
    HWYReportCountData *reportCount = [HWYReportCountData new];
    if ([rs next]) {
        reportCount.bxCount = [rs stringForColumnIndex:1];
        reportCount.xxCount = [rs stringForColumnIndex:2];
        reportCount.rxCount = [rs stringForColumnIndex:3];
        reportCount.stuCount = [rs stringForColumnIndex:4];
    } else {
        reportCount = nil;
    }
    [db close];
    return reportCount;
}

@end

@implementation HWYReportCardData

+ (NSArray *)getReportCardArrFromHtml:(id)responseObject {
    NSArray *scoreArr = [HWYAnalysisHtml getReportCardArrWithHttp:responseObject];
    NSMutableArray *reportCardArr = [NSMutableArray array];
    for (NSArray *arr in scoreArr) {
        HWYReportCardData *reportCard = [HWYReportCardData new];
        reportCard.ordernum= [arr[0] integerValue];
        reportCard.semester= arr[1];
        reportCard.semesterId = arr[2];
        reportCard.courseId= arr[3];
        reportCard.courseName= arr[4];
        reportCard.period = arr[5];
        reportCard.credit = arr[6];
        reportCard.score = arr[7];
        reportCard.property = arr[8];
        [reportCardArr addObject:reportCard];
    }
    return reportCardArr;
}

+ (void)saveReportCardData:(NSArray *)arr {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    NSString *number = [KUserDefaults valueForKey:KDefaultNumber];
    for (HWYReportCardData *reportCard in arr) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_report_card where number = ? and courseId = ?", number, reportCard.courseId];
        if ([rs next]) {
            [db executeUpdate:@"update jwzx_report_card set courseName = ?, semesterId = ?, semester = ?, period = ?, credit = ?, property = ?, score = ?, ordernum = ? where number = ? and courseId = ?", reportCard.courseName, reportCard.semesterId, reportCard.semester, reportCard.period, reportCard.credit, reportCard.property, reportCard.score, [NSNumber numberWithInteger:reportCard.ordernum], number, reportCard.courseId];
        } else {
            [db executeUpdate:@"insert into jwzx_report_card (number, courseId, courseName, semesterId, semester, period, credit, property, score, ordernum) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", number, reportCard.courseId, reportCard.courseName, reportCard.semesterId, reportCard.semester, reportCard.period, reportCard.credit, reportCard.property, reportCard.score, [NSNumber numberWithInteger:reportCard.ordernum]];
        }
    }
    [db close];
}

+ (NSArray *)getReportCardData {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    NSString *number = [KUserDefaults valueForKey:KDefaultNumber];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_report_card where number = ? order by semesterId desc, ordernum asc", number];
    NSMutableArray *reportCardArr = [NSMutableArray array];
    while ([rs next]) {
        HWYReportCardData *reportCard = [HWYReportCardData new];
        reportCard.courseId= [rs stringForColumnIndex:1];
        reportCard.courseName= [rs stringForColumnIndex:2];
        reportCard.semesterId= [rs stringForColumnIndex:3];
        reportCard.semester = [rs stringForColumnIndex:4];
        reportCard.period = [rs stringForColumnIndex:5];
        reportCard.credit = [rs stringForColumnIndex:6];
        reportCard.property = [rs stringForColumnIndex:7];
        reportCard.score =[rs stringForColumnIndex:8];
        reportCard.ordernum= [rs intForColumnIndex:9];
        [reportCardArr addObject:reportCard];
    }
    [db close];
    return reportCardArr;
}

+ (NSArray *)queryReportCardData:(NSString *)courseName {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    NSString *number = [KUserDefaults valueForKey:KDefaultNumber];
    courseName = [NSString stringWithFormat:@"%%%@%%", courseName];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_report_card where number = ? and courseName like ? order by semesterId desc", number, courseName];
    NSMutableArray *reportCardArr = [NSMutableArray array];
    while ([rs next]) {
        HWYReportCardData *reportCard = [HWYReportCardData new];
        reportCard.courseId= [rs stringForColumnIndex:1];
        reportCard.courseName= [rs stringForColumnIndex:2];
        reportCard.semesterId= [rs stringForColumnIndex:3];
        reportCard.semester = [rs stringForColumnIndex:4];
        reportCard.period = [rs stringForColumnIndex:5];
        reportCard.credit = [rs stringForColumnIndex:6];
        reportCard.property = [rs stringForColumnIndex:7];
        reportCard.score =[rs stringForColumnIndex:8];
        reportCard.ordernum= [rs intForColumnIndex:9];
        [reportCardArr addObject:reportCard];
    }
    [db close];
    return reportCardArr;
}

@end
