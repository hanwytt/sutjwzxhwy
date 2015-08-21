//
//  HWYSzgdNetworking.h
//  sutjwzxhwy
//
//  Created by hanwy on 15/5/15.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWYLoginSzgdData.h"

@interface HWYSzgdNetworking : NSObject

+ (void)getLoginSzgdLt:(void(^)(NSString *lt)) block;

+ (void)getLoginSzgdData:(NSString *)username password:(NSString *)password lt:(NSString *)lt compelet:(void(^)(HWYLoginSzgdData *szgd)) block;

+ (void)getLoginSzgdJump:(NSString *)href success:(void(^)())success failure:(void(^)())failure;

+ (void)getBookBorrowData:(void(^)()) block;

+ (void)getOneCardBalanceData:(void(^)()) block;

+ (void)getOneCardRecordData:(void(^)()) block;

+ (void)logoutSzgdSuccess:(void(^)())success failure:(void(^)())failure;

@end
