//
//  HWYLoginJwzxData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/18.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYLoginJwzxData.h"
#import "HWYAnalysisHtml.h"
#import "HWYGeneralConfig.h"
#import "FMDB.h"

@implementation HWYLoginJwzxData

+ (HWYLoginJwzxData *)getLoginJwzxDataFromHtml:(NSString *)responseString and:(id)responseObject {
    return [HWYAnalysisHtml getLoginJwzxDataFromHtml:responseString and:responseObject];
}

+ (void)saveLoginJwzxData:(NSString *)name password:(NSString *)password {
    NSString *dbpath = [DocumentsDirectory stringByAppendingPathComponent:_K_DATABASE];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_szgd_login where number = ?", name];
    if ([rs next]) {
        [db executeUpdate:@"update jwzx_szgd_login set password_jwzx = ? where number = ?", password, name];
    } else {
        [db executeUpdate:@"insert into jwzx_szgd_login (number, password_jwzx) values (?, ?)", name, password];
    }
    [db close];
}

+ (NSString *)getLoginJwzxPassword:(NSString *)name {
    NSString *dbpath = [DocumentsDirectory stringByAppendingPathComponent:_K_DATABASE];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_szgd_login where number = ?", name];
    NSString *pwd = [NSString string];
    if ([rs next]) {
        pwd = [rs stringForColumnIndex:1];
    }
    return pwd;
}
@end
