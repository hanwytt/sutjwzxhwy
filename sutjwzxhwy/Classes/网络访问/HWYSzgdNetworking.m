//
//  HWYSzgdNetworking.m
//  sutjwzxhwy
//
//  Created by hanwy on 15/5/15.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import "HWYSzgdNetworking.h"
#import "HWYNetworkingHtml.h"
#import "HWYNetworkingJson.h"
#import "HWYBookBorrowData.h"
#import "HWYOneCardData.h"

@implementation HWYSzgdNetworking

+ (void)getLoginSzgdLt:(void(^)(NSString *lt))block {
    NSDictionary *parameters = @{@"service": @"http://portal.sut.edu.cn/dcp/index.jsp"};
    [HWYNetworkingHtml GET:SZGD_LOGIN_URL paramters:parameters success:^(id responseObject) {
        block([HWYLoginSzgdData getLoginSzgdLtFromHtml:responseObject]);
    } failure:^(NSError *error) {
        block(nil);
    }];
}

+ (void)getLoginSzgdData:(NSString *)username password:(NSString *)password lt:(NSString *)lt compelet:(void(^)(HWYLoginSzgdData *szgd))block {
    if (lt == nil) {
        lt = @"";
    }
    NSDictionary *parameters = @{
                                 @"encodedService": @"http%3a%2f%2fportal.sut.edu.cn%2fdcp%2findex.jsp",
                                 @"service": @"http://portal.sut.edu.cn/dcp/index.jsp",
                                 @"serviceName": @"null",
                                 @"username": username,
                                 @"password": password,
                                 @"lt": lt,
                                 @"autoLogin": @"true"
                                 };
    [HWYNetworkingHtml POST:SZGD_LOGIN_URL paramters:parameters success:^(id responseObject) {
        block([HWYLoginSzgdData getLoginSzgdDataFromHtml:responseObject]);
    } failure:^(NSError *error) {
        block([HWYLoginSzgdData new]);
    }];
}

+ (void)getLoginSzgdJump:(NSString *)href success:(void(^)())success failure:(void(^)())failure {
    [HWYNetworkingHtml GET:href paramters:nil success:^(id responseObject) {
        success();
    } failure:^(NSError *error) {
        failure();
    }];
}

+ (void)getBookBorrowData:(void(^)())block {
    NSDictionary *parameters = @{
                                 @"map": @{
                                         @"method": @"getUnBackBookInfo",
                                         @"params": [NSNull null]
                                         },
                                 @"javaClass": @"java.util.HashMap"
                                 };
    [HWYNetworkingJson POST:JWZX_BOOKBORROW_URL paramters:parameters success:^(id responseObject) {
        NSArray *bookBorrowArr = [HWYBookBorrowData getBookBorrowDataFromDict:responseObject];
        [HWYBookBorrowData saveBookBorrowData:bookBorrowArr];
        block();
    } failure:^(NSError *error) {
        block();
    }];
}

+ (void)getOneCardBalanceData:(void(^)())block {
    NSDictionary *parameters = @{
                                 @"map": @{
                                         @"method": @"getCardStatusInfo",
                                         @"params": [NSNull null]
                                         },
                                 @"javaClass": @"java.util.HashMap"
                                 };
    [HWYNetworkingJson POST:SZGD_ONECARD_URL paramters:parameters success:^(id responseObject) {
        HWYOneCardBalanceData *oneCardBalance = [HWYOneCardBalanceData getOneCardBalanceDataFromDict:responseObject];
        [HWYOneCardBalanceData saveOneCardBalanceData:oneCardBalance];
        block();
    } failure:^(NSError *error) {
        block();
    }];
}

+ (void)getOneCardRecordData:(void(^)())block {
    NSDictionary *parameters = @{
                                 @"map": @{
                                         @"method": @"getCardInfoByDay",
                                         @"params": [NSNull null],
                                         @"pm": @{
                                                 @"javaClass": @"com.neusoft.education.edp.client.PageManager",
                                                 @"pageSize": @20,
                                                 @"pageNo": @1,
                                                 @"totalCount": @-1,
                                                 @"order": [NSNull null],
                                                 @"filters": @{
                                                         @"javaClass": @"com.neusoft.education.edp.client.QueryFilter",
                                                         @"parameters": @{
                                                                 @"javaClass": @"java.util.HashMap",
                                                                 @"map": @{}
                                                                 }
                                                         },
                                                 @"pageSumcols": [NSNull null],
                                                 @"pageSums": [NSNull null],
                                                 @"sumcols": [NSNull null],
                                                 @"isNewSum": [NSNull null],
                                                 @"sums": [NSNull null],
                                                 @"resPojoName": @"com.neusoft.education.dcp.apps.card.entity.CardListEntity"
                                                 }
                                         },
                                 @"javaClass": @"java.util.HashMap"
                                 };
    [HWYNetworkingJson POST:SZGD_ONECARD_URL paramters:parameters success:^(id responseObject) {
        NSArray *oneCardRecordArr = [HWYOneCardRecordData getOneCardRecordDataFromDict:responseObject];
        [HWYOneCardRecordData saveOneCardRecordData:oneCardRecordArr];
        block();
    } failure:^(NSError *error) {
        block();
    }];
}

+ (void)logoutSzgdSuccess:(void(^)())success failure:(void(^)())failure {
    [HWYNetworkingHtml GET:SZGD_LOGOUT_URL paramters:nil success:^(id responseObject) {
        NSLog(@"数字工大注销成功!");
        success();
    } failure:^(NSError *error) {
        NSLog(@"数字工大注销失败!");
        failure();
    }];
}

@end
