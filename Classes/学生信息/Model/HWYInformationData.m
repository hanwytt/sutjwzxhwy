//
//  HWYInformationData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYInformationData.h"
#import "HWYAnalysisHtml.h"
#import "HWYAppDefine.h"
#import "FMDB.h"

@implementation HWYInformationData

+ (HWYInformationData *)getInformationDataFromHtml:(id)responseObject {
    NSArray *infoArr = [HWYAnalysisHtml getInformationArrFromHtml:responseObject];
    HWYInformationData *info = [[HWYInformationData alloc] init];
    info.number = infoArr[5];
    info.name = infoArr[9];
    info.sex = infoArr[13];
    info.nation = infoArr[21];
    info.school = infoArr[1];
    info.department = infoArr[3];
    info.major = infoArr[11];
    info.className = infoArr[15];
    info.grade = infoArr[17];
    info.education = infoArr[7];
    info.idCardNo = infoArr[19];
    info.interval = infoArr[23];
    return info;
}

+ (void)saveInformationData:(HWYInformationData *)info {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_info where number = ?", info.number];
    if ([rs next]) {
        [db executeUpdate:@"update jwzx_info set name = ?, sex = ?,nation = ?, school = ?, department = ?, major = ?, className = ?, grade = ?, education = ?, idCardNo = ?, interval = ? where number = ?", info.name, info.sex, info.nation, info.school, info.department, info.major, info.className, info.grade, info.education, info.idCardNo, info.interval, info.number];
    } else {
        [db executeUpdate:@"insert into jwzx_info (number, name, sex, nation, school, department, major, className, grade, education, idCardNo, interval) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", info.number, info.name, info.sex, info.nation, info.school, info.department, info.major, info.className, info.grade, info.education, info.idCardNo, info.interval];
    }
    [db close];
}

+ (HWYInformationData *)getInformationData:(NSString *)number {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_info where number = ?", number];
    HWYInformationData *info = [HWYInformationData new];
    if ([rs next]) {
        info.number = [rs stringForColumnIndex:0];
        info.name = [rs stringForColumnIndex:1];
        info.sex = [rs stringForColumnIndex:2];
        info.nation = [rs stringForColumnIndex:3];
        info.school = [rs stringForColumnIndex:4];
        info.department = [rs stringForColumnIndex:5];
        info.major = [rs stringForColumnIndex:6];
        info.className = [rs stringForColumnIndex:7];
        info.grade = [rs stringForColumnIndex:8];
        info.education = [rs stringForColumnIndex:9];
        info.idCardNo = [rs stringForColumnIndex:10];
        info.interval = [rs stringForColumnIndex:11];
        info.imageData = [rs dataForColumnIndex:12];
    } else {
        info = nil;
    }
    [db close];
    return info;
}

+ (void)saveInfoImageData:(NSData *)data number:(NSString *)number {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_info where number = ?", number];
    if ([rs next]) {
        [db executeUpdate:@"update jwzx_info set imageData = ? where number = ?", data, number];
    } else {
        [db executeUpdate:@"insert into jwzx_info (number, imageData) values (?, ?)", number, data];
    }
    [db close];

}

+ (NSData *)getInfoImageData:(NSString *)number {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_info where number = ?", number];
    NSData *imageData = [NSData data];
    if ([rs next]) {
        imageData = [rs dataForColumnIndex:12];
    } else {
        imageData = nil;
    }
    [db close];
    return imageData;
}

@end
