//
//  HWYOneCardData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYOneCardData.h"
#import "HWYAppDefine.h"
#import "FMDB.h"

@implementation HWYOneCardBalanceData

+ (HWYOneCardBalanceData *)getOneCardBalanceDataFromDict:(NSDictionary *)dict {
    NSArray *array = dict[@"list"];
    NSDictionary *dic = array.firstObject;
    HWYOneCardBalanceData *oneCardBalance = [[HWYOneCardBalanceData alloc] init];
    oneCardBalance.XH = dic[@"XH"];
    oneCardBalance.YKT = dic[@"YKT"];
    oneCardBalance.YE = dic[@"YE"];
    oneCardBalance.ZYXF = dic[@"ZYXF"];
    oneCardBalance.JRXF = dic[@"JRXF"];
    oneCardBalance.CARD_ID = dic[@"CARD_ID"];
    return oneCardBalance;
}

+ (void)saveOneCardBalanceData:(HWYOneCardBalanceData *)oneCardBalance {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    
    NSString *szgd_onecard_balance = @"CREATE TABLE IF NOT EXISTS szgd_onecard_balance (XH VARCHAR PRIMARY KEY NOT NULL REFERENCES jwzx_szgd_login (number), YKT VARCHAR, YE VARCHAR, ZYXF VARCHAR, JRXF VARCHAR, CARD_ID VARCHAR)";
    BOOL result = [db executeUpdate:szgd_onecard_balance];
    if (!result) {
        NSLog(@"Could create table.");
        return;
    }
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM szgd_onecard_balance where XH = ?", oneCardBalance.XH];
    if ([rs next]) {
        [db executeUpdate:@"update szgd_onecard_balance set YKT = ?, YE = ?,ZYXF = ?, JRXF = ?, CARD_ID = ? where XH = ?", oneCardBalance.YKT, oneCardBalance.YE, oneCardBalance.ZYXF, oneCardBalance.JRXF, oneCardBalance.CARD_ID, oneCardBalance.XH];
    } else {
        [db executeUpdate:@"insert into szgd_onecard_balance (XH, YKT, YE, ZYXF, JRXF, CARD_ID) values (?, ?, ?, ?, ?, ?)", oneCardBalance.XH, oneCardBalance.YKT, oneCardBalance.YE, oneCardBalance.ZYXF, oneCardBalance.JRXF, oneCardBalance.CARD_ID];
    }
    [db close];
}

+ (HWYOneCardBalanceData *)getOneCardBalanceData {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    
    NSString *number = [KUserDefaults valueForKey:KDefaultNumber];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM szgd_onecard_balance where XH = ?", number];
    HWYOneCardBalanceData *oneCardBalance = [HWYOneCardBalanceData new];
    if ([rs next]) {
        oneCardBalance.XH = [rs stringForColumnIndex:0];
        oneCardBalance.YKT = [rs stringForColumnIndex:1];
        oneCardBalance.YE = [rs stringForColumnIndex:2];
        oneCardBalance.ZYXF = [rs stringForColumnIndex:3];
        oneCardBalance.JRXF = [rs stringForColumnIndex:4];
        oneCardBalance.CARD_ID = [rs stringForColumnIndex:5];
    } else {
        oneCardBalance = nil;
    }
    [db close];
    return oneCardBalance;
}

@end

@implementation HWYOneCardRecordData

+ (NSArray *)getOneCardRecordDataFromDict:(NSDictionary *)dict {
    NSMutableArray *oneCardRecordArr = [NSMutableArray array];
    NSArray *array = dict[@"list"];
    for (NSDictionary *dic in array) {
        HWYOneCardRecordData *oneCardRecord = [[HWYOneCardRecordData alloc] init];
        NSDictionary *RR = dic[@"RR"];
        long long seconds;
        if ([RR[@"time"] isKindOfClass:[NSNumber class]]) {
            NSNumber *number = RR[@"time"];
            seconds = [number longLongValue];
        } else {
            seconds = [RR[@"time"] longLongValue];
        }
        NSDate *nd = [NSDate dateWithTimeIntervalSince1970:seconds/1000.0];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        oneCardRecord.time = [dateFormat stringFromDate:nd];
        oneCardRecord.XH = dic[@"XH"];
        oneCardRecord.YKT = dic[@"YKT"];
        if ([dic[@"JE"] isKindOfClass:[NSNumber class]]) {
            NSNumber *number = dic[@"JE"];
            oneCardRecord.JE = [number stringValue];
        } else {
            oneCardRecord.JE = dic[@"JE"];
        }
        oneCardRecord.ZDMC= dic[@"ZDMC"];
        oneCardRecord.CARD_ID = dic[@"CARD_ID"];
        [oneCardRecordArr addObject:oneCardRecord];
    }
    return oneCardRecordArr;
}


+ (void)saveOneCardRecordData:(NSArray *)arr {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
    
    NSString *szgd_onecard_record = @"CREATE TABLE IF NOT EXISTS szgd_onecard_record (XH VARCHAR NOT NULL REFERENCES jwzx_szgd_login (number), YKT VARCHAR, JE VARCHAR, ZDMC VARCHAR, time VARCHAR, CARD_ID VARCHAR NOT NULL, PRIMARY KEY (XH,CARD_ID))";
    BOOL result = [db executeUpdate:szgd_onecard_record];
    if (!result) {
        NSLog(@"Could create table.");
        return;
    }
    
    NSString *number = [KUserDefaults valueForKey:KDefaultNumber];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM szgd_onecard_record where XH = ?", number];
    if ([rs next]) {
        [db executeUpdate:@"delete from szgd_onecard_record where XH = ?", number];
    }
    for (HWYOneCardRecordData *oneCardRecord in arr) {
        [db executeUpdate:@"insert into szgd_onecard_record (XH, YKT, JE, ZDMC, time, CARD_ID) values (?, ?, ?, ?, ?, ?)", oneCardRecord.XH, oneCardRecord.YKT, oneCardRecord.JE, oneCardRecord.ZDMC, oneCardRecord.time, oneCardRecord.CARD_ID];
    }
    [db close];
}

+ (NSArray *)getOneCardRecordData {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    
    NSString *number = [KUserDefaults valueForKey:KDefaultNumber];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM szgd_onecard_record where XH = ? order by time desc", number];
    NSMutableArray *oneCardRecordArr = [NSMutableArray array];
    while ([rs next]) {
        HWYOneCardRecordData *oneCardRecord = [HWYOneCardRecordData new];
        oneCardRecord.XH = [rs stringForColumnIndex:0];
        oneCardRecord.YKT = [rs stringForColumnIndex:1];
        oneCardRecord.JE = [rs stringForColumnIndex:2];
        oneCardRecord.ZDMC = [rs stringForColumnIndex:3];
        oneCardRecord.time = [rs stringForColumnIndex:4];
        oneCardRecord.CARD_ID = [rs stringForColumnIndex:5];
        [oneCardRecordArr addObject:oneCardRecord];
    }
    [db close];
    return oneCardRecordArr;
}

@end
