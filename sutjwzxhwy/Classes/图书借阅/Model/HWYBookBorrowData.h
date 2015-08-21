//
//  HWYBookBorrowData.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYBookBorrowData : NSObject

@property (copy, nonatomic) NSString *propNo;
@property (copy, nonatomic) NSString *mTitle;
@property (copy, nonatomic) NSString *mAuthor;
@property (copy, nonatomic) NSString *lendDate;
@property (copy, nonatomic) NSString *normRetDate;

+ (NSArray *)getBookBorrowDataFromDict:(NSDictionary *)dict;
+ (void)saveBookBorrowData:(NSArray *)arr;
+ (NSArray *)getBookBorrowData;

@end
