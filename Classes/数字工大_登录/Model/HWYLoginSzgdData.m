//
//  HWYLoginSzgdData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/19.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYLoginSzgdData.h"
#import "HWYAnalysisHtml.h"
#import "HWYAppDefine.h"
#import "FMDB.h"

@implementation HWYLoginSzgdData

+ (NSString *)getLoginSzgdLtFromHtml:(id)responseObject {
    return [HWYAnalysisHtml getLoginSzgdLtWithHttp:responseObject];
}

+ (HWYLoginSzgdData *)getLoginSzgdDataFromHtml:(id)responseObject {
    return [HWYAnalysisHtml getLoginSzgdDataWithHttp:responseObject];
}

+ (void)saveLoginSzgdData:(NSString *)name password:(NSString *)password {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    
    NSString *jwzx_szgd_login = @"CREATE TABLE IF NOT EXISTS jwzx_szgd_login (number VARCHAR PRIMARY KEY NOT NULL, password_jwzx VARCHAR, password_szgd VARCHAR)";
    BOOL result = [db executeUpdate:jwzx_szgd_login];
    if (!result) {
        NSLog(@"Could create table.");
        return;
    }
    
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_szgd_login where number = ?", name];
    if ([rs next]) {
        [db executeUpdate:@"update jwzx_szgd_login set password_szgd = ? where number = ?", password, name];
    } else {
        [db executeUpdate:@"insert into jwzx_szgd_login (number, password_szgd) values (?, ?)", name, password];
    }
    [db close];
}

+ (NSString *)getLoginSzgdPassword:(NSString *)name {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_szgd_login where number = ?", name];
    NSString *pwd = [NSString string];
    if ([rs next]) {
        pwd = [rs stringForColumnIndex:2];
    }
    return pwd;
}

@end
