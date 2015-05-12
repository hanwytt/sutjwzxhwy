//
//  HWYLoginOffLineData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/23.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYLoginOffLineData.h"
#import "HWYGeneralConfig.h"
#import "FMDB.h"

@implementation HWYLoginOffLineData

+ (BOOL)getLoginOffLineData:(NSString *)name password:(NSString *)password {
    NSString *dbpath = [DocumentsDirectory stringByAppendingPathComponent:_K_DATABASE];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return NO;
    }
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_szgd_login where number = ? and password_jwzx = ? or password_szgd = ?", name, password, password];
    if ([rs next]) {
        [db close];
        return YES;
    } else {
        [db close];
        return NO;
    }
}

+ (NSString *)getLoginOffLinePassword:(NSString *)name {
    NSString *dbpath = [DocumentsDirectory stringByAppendingPathComponent:_K_DATABASE];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM jwzx_szgd_login where number = ?", name];
    NSString *pwd = [NSString string];
    if ([rs next]) {
        if (kStringExist([rs stringForColumnIndex:1])) {
            pwd = [rs stringForColumnIndex:1];
        } else {
            pwd = [rs stringForColumnIndex:2];
        }
    }
    return pwd;
}

@end
