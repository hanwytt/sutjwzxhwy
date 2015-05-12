//
//  HWYNetworking.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWYNewsListData.h"
#import "HWYNewsInfoData.h"
#import "HWYNewsInfoDetailData.h"
#import "HWYNoticeListData.h"
#import "HWYNoticeInfoData.h"
#import "HWYNoticeInfoDetailData.h"
#import "HWYLoginJwzxData.h"
#import "HWYLoginSzgdData.h"
#import "HWYInformationData.h"
#import "HWYScheduleData.h"
#import "HWYReportCardData.h"
#import "HWYOneCardData.h"
#import "HWYBookBorrowData.h"

@interface HWYNetworking : NSObject

+ (void)getLoginJwzxData:(NSString *)name password:(NSString *)password agnomen:(NSString *)agnomen compelet:(void(^)(BOOL success, HWYLoginJwzxData *jwzx, NSError *error)) block;

+ (void)getInformationData:(void(^)(NSError *error)) block;

+ (void)getScheduleData:(NSString *)semester compelet:(void(^)(NSError *error)) block;

+ (void)getReportCardData:(void(^)(NSError *error)) block;

+ (void)getLogoutJwzx:(void(^)(BOOL jwzx, NSError *error)) block;

+ (void)getLoginSzgdLt:(void(^)(BOOL success, NSString *lt, NSError *error)) block;

+ (void)getLoginSzgdData:(NSString *)username password:(NSString *)password lt:(NSString *)lt compelet:(void(^)(BOOL success, HWYLoginSzgdData *szgd, NSError *error)) block;

+ (void)getLoginSzgdJump:(NSString *)href compelet:(void(^)(BOOL success,NSError *error)) block;

+ (void)getBookBorrowData:(void(^)(NSError *error)) block;

+ (void)getOneCardBalanceData:(void(^)(NSError *error)) block;

+ (void)getOneCardRecordData:(void(^)(NSError *error)) block;

+ (void)getLogoutSzgd:(void(^)(BOOL szgd, NSError *error)) block;

+ (void)getNewsListData:(void(^)(NSError *error)) block;

+ (void)getNewsInfoData:(NSString *)plateid type:(NSInteger)type compelet:(void(^)(NSError *error)) block;

+ (void)getNewsInfoDetailData:(NSString *)resourceid compelet:(void(^)(NSError *error)) block;

+ (void)getNoticeListData:(void(^)(NSError *error)) block;

+ (void)getNoticeInfoData:(NSString *)plateid compelet:(void(^)(NSError *error)) block;

+ (void)getNoticeInfoDetailData:(NSString *)resourceid compelet:(void(^)(NSError *error)) block;
@end
