//
//  HWYLoginSzgdData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/19.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYLoginSzgdData.h"
#import "HWYAnalysisHtml.h"
#import "HWYGeneralConfig.h"
#import "FMDB.h"

@implementation HWYLoginSzgdData

+ (NSString *)getLoginSzgdLtFromHtml:(id)responseObject {
    return [HWYAnalysisHtml getLoginSzgdLtWithHttp:responseObject];
}

+ (HWYLoginSzgdData *)getLoginSzgdDataFromHtml:(id)responseObject {
    return [HWYAnalysisHtml getLoginSzgdDataWithHttp:responseObject];
}

+ (void)saveLoginSzgdData:(NSString *)name password:(NSString *)password {
    NSString *dbpath = [DocumentsDirectory stringByAppendingPathComponent:_K_DATABASE];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
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
    NSString *dbpath = [DocumentsDirectory stringByAppendingPathComponent:_K_DATABASE];
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
