//
//  HWYScheduleData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYScheduleData.h"
#import "HWYAnalysisHtml.h"
#import "HWYAppDefine.h"
#import "FMDB.h"

@implementation HWYScheduleData

+ (NSArray *)getScheduleArrFromHtml:(id)responseObject withSemester:(NSString *)semester {
    NSArray *array = [HWYAnalysisHtml getScheduleArrWithHttp:responseObject];
    NSMutableArray *scheduleArr = [NSMutableArray array];
    for (NSArray *arr in array) {
        HWYScheduleData *schedule = [HWYScheduleData new];
        schedule.semester = semester;
        NSString *temp = arr[0];
        NSString *section = [temp substringWithRange:NSMakeRange(5, 1)];
        NSString *week = [temp substringFromIndex:7];
        schedule.week = [week intValue];
        schedule.section = [section intValue];
        schedule.courseId = arr[1];
        schedule.course= arr[2];
        schedule.teacher = arr[3];
        schedule.schooltime = arr[4];
        schedule.timedesc = arr[5];
        schedule.room = arr[6];
        [scheduleArr addObject:schedule];
    }
    return scheduleArr;
}

+ (void)saveScheduleData:(NSArray *)arr {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    NSString *number = [KUserDefaults valueForKey:KDefaultNumber];
    for (HWYScheduleData *schedule in arr) {
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_schedule where number = ? and semester = ? and week = ? and section = ?", number, schedule.semester, [NSNumber numberWithInteger:schedule.week], [NSNumber numberWithInteger:schedule.section]];
        if ([rs next]) {
            [db executeUpdate:@"update jwzx_schedule set courseId = ?, course = ?, teacher = ?, schooltime = ?, timedesc = ?, room = ? where number = ? and semester = ? and week = ? and section = ?", schedule.courseId, schedule.course, schedule.teacher, schedule.schooltime, schedule.timedesc, schedule.room, number, schedule.semester, [NSNumber numberWithInteger:schedule.week], [NSNumber numberWithInteger:schedule.section]];
        } else {
            [db executeUpdate:@"insert into jwzx_schedule (number, semester, week, section, courseId, course, teacher, schooltime, timedesc, room) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", number, schedule.semester, [NSNumber numberWithInteger:schedule.week], [NSNumber numberWithInteger:schedule.section], schedule.courseId, schedule.course, schedule.teacher, schedule.schooltime, schedule.timedesc, schedule.room];
        }
    }
    [db close];
}

+ (NSArray *)getScheduleData:(NSString *)semester {
    NSMutableArray *scheduleArr = [NSMutableArray array];
    for (int i = 0; i < 7; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int j = 0; j < 5; j++) {
            HWYScheduleData *schedule = [HWYScheduleData new];
            [arr addObject:schedule];
        }
        [scheduleArr addObject:arr];
    }
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    NSString *number = [KUserDefaults valueForKey:KDefaultNumber];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_schedule where number = ? and semester = ?", number, semester];
    while ([rs next]) {
        HWYScheduleData *schedule = [HWYScheduleData new];
        schedule.semester = [rs stringForColumnIndex:1];
        schedule.week = [rs intForColumnIndex:2];
        schedule.section = [rs intForColumnIndex:3];
        schedule.courseId = [rs stringForColumnIndex:4];
        schedule.course = [rs stringForColumnIndex:5];
        schedule.teacher = [rs stringForColumnIndex:6];
        schedule.schooltime = [rs stringForColumnIndex:7];
        schedule.timedesc = [rs stringForColumnIndex:8];
        schedule.room = [rs stringForColumnIndex:9];
        scheduleArr[schedule.week-1][schedule.section-1] = schedule;
    }
    [db close];
    return scheduleArr;
}

@end
