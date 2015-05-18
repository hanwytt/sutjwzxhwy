//
//  HWYBookBorrowData.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYBookBorrowData.h"
#import "HWYAppDefine.h"
#import "FMDB.h"

@implementation HWYBookBorrowData

+ (NSArray *)getBookBorrowDataFromDict:(NSDictionary *)dict {
    NSMutableArray *bookBorrowArr = [NSMutableArray array];
    NSArray *array = dict[@"list"];
    for (NSDictionary *dic in array) {
        HWYBookBorrowData *bookBorrow = [[HWYBookBorrowData alloc] init];
        bookBorrow.propNo = dic[@"propNo"];
        bookBorrow.mTitle = dic[@"mTitle"];
        bookBorrow.mAuthor = dic[@"mAuthor"];
        bookBorrow.lendDate = dic[@"lendDate"];
        bookBorrow.normRetDate = dic[@"normRetDate"];
        [bookBorrowArr addObject:bookBorrow];
    }
    return bookBorrowArr;
}

+ (void)saveBookBorrowData:(NSArray *)arr {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return ;
    }
     NSString *number = [KUserDefaults valueForKey:KDefaultNumber];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM szgd_bookborrow where number = ?", number];
    if ([rs next]) {
        [db executeUpdate:@"delete from szgd_bookborrow where number = ?", number];
    }
    for (HWYBookBorrowData *bookBorrow in arr) {
        rs = [db executeQuery:@"SELECT * FROM szgd_bookborrow where number = ? and propNo = ?", number, bookBorrow.propNo];
        if ([rs next]) {
            [db executeUpdate:@"update szgd_bookborrow set mTitle = ?, mAuthor = ?, lendDate = ?, normRetDate = ? where number = ? and propNo = ?", bookBorrow.mTitle, bookBorrow.mAuthor, bookBorrow.lendDate, bookBorrow.normRetDate, number, bookBorrow.propNo];
        } else {
            [db executeUpdate:@"insert into szgd_bookborrow (number, propNo, mTitle, mAuthor, lendDate, normRetDate) values (?, ?, ?, ?, ?, ?)", number, bookBorrow.propNo, bookBorrow.mTitle, bookBorrow.mAuthor, bookBorrow.lendDate, bookBorrow.normRetDate];
        }
    }
    [db close];
}

+ (NSArray *)getBookBorrowData {
    NSString *dbpath = [KDocumentsDirectory stringByAppendingPathComponent:KDatabase];
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return nil;
    }
    NSString *number = [KUserDefaults valueForKey:KDefaultNumber];
    FMResultSet *rs = [db executeQuery:@"SELECT * FROM szgd_bookborrow where number = ? order by lendDate asc", number];
    NSMutableArray *bookBorrowArr = [NSMutableArray array];
    while ([rs next]) {
        HWYBookBorrowData *bookBorrow = [HWYBookBorrowData new];
        bookBorrow.propNo= [rs stringForColumnIndex:1];
        bookBorrow.mTitle= [rs stringForColumnIndex:2];
        bookBorrow.mAuthor= [rs stringForColumnIndex:3];
        bookBorrow.lendDate= [rs stringForColumnIndex:4];
        bookBorrow.normRetDate= [rs stringForColumnIndex:5];
        [bookBorrowArr addObject:bookBorrow];
    }
    [db close];
    return bookBorrowArr;
}

@end
