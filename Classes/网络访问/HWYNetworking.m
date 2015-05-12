//
//  HWYNetworking.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNetworking.h"
#import "HWYURLConfig.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@implementation HWYNetworking

+ (void)getLoginJwzxData:(NSString *)name password:(NSString *)password agnomen:(NSString *)agnomen compelet:(void(^)(BOOL success, HWYLoginJwzxData *jwzx, NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"WebUserNO": name, @"Password": password, @"Agnomen": agnomen};
    [manager POST:JWZX_LOGIN_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(YES, [HWYLoginJwzxData getLoginJwzxDataFromHtml:operation.responseString and:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        block(NO, nil, error);
    }];
}

+ (void)getInformationData:(void(^)(NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:JWZX_INFO_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HWYInformationData *info = [HWYInformationData getInformationDataFromHtml:responseObject];
        [HWYInformationData saveInformationData:info];
        block(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        block(error);
    }];
}

+ (void)getScheduleData:(NSString *)semester compelet:(void(^)(NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *yearStr = [semester substringToIndex:4];//0-4不包括4
    NSInteger year = [yearStr integerValue];
    year = (year - 2008) * 2;
    if ([semester containsString:@"一"]) {
        year++;
    } else {
        year+=2;
    }
    NSNumber *number = [NSNumber numberWithInteger:year];
    NSDictionary *parameters = @{
                                 @"YearTermNO": number
                                 };
    [manager GET:JWZX_SCHEDULE_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *scheduleArr = [HWYScheduleData getScheduleArrFromHtml:responseObject withSemester:semester];
        [HWYScheduleData saveScheduleData:scheduleArr];
        block(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        block(error);
    }];
}

+ (void)getReportCardData:(void(^)(NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:JWZX_REPORTCARD_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HWYReportCountData *reportCount = [HWYReportCountData getReportCountFromHtml:responseObject];
        [HWYReportCountData saveReportCountData:reportCount];
        NSArray *reportCardArr = [HWYReportCardData getReportCardArrFromHtml:responseObject];
        [HWYReportCardData saveReportCardData:reportCardArr];
        block(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        block(error);
    }];
}

+ (void)getLogoutJwzx:(void(^)(BOOL jwzx, NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:JWZX_LOGOUT_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"教务在线注销成功!");
        block(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        block(NO, error);
    }];
}

+ (void)getLoginSzgdLt:(void(^)(BOOL success, NSString *lt, NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"service": @"http://portal.sut.edu.cn/dcp/index.jsp"};
    [manager GET:SZGD_LOGIN_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(YES, [HWYLoginSzgdData getLoginSzgdLtFromHtml:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        block(NO, nil, error);
    }];
}

+ (void)getLoginSzgdData:(NSString *)username password:(NSString *)password lt:(NSString *)lt compelet:(void(^)(BOOL success, HWYLoginSzgdData *szgd, NSError *error)) block {
    if (lt == nil) {
        lt = @"";
    }
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{
                                 @"encodedService": @"http%3a%2f%2fportal.sut.edu.cn%2fdcp%2findex.jsp",
                                 @"service": @"http://portal.sut.edu.cn/dcp/index.jsp",
                                 @"serviceName": @"null",
                                 @"username": username,
                                 @"password": password,
                                 @"lt": lt,
                                 @"autoLogin": @"true"
                                 };
    [manager POST:SZGD_LOGIN_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(YES, [HWYLoginSzgdData getLoginSzgdDataFromHtml:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        block(NO, nil, error);
    }];
}

+ (void)getLoginSzgdJump:(NSString *)href compelet:(void(^)(BOOL success,NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:href parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"CAS认证成功!");
        block(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        block(NO, error);
    }];
}

+ (void)getBookBorrowData:(void(^)(NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{
                                 @"map": @{
                                            @"method": @"getUnBackBookInfo",
                                            @"params": [NSNull null]
                                            },
                                 @"javaClass": @"java.util.HashMap"
                                };
    [manager POST:JWZX_BOOKBORROW_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *bookBorrowArr = [HWYBookBorrowData getBookBorrowDataFromDict:responseObject];
        [HWYBookBorrowData saveBookBorrowData:bookBorrowArr];
        block(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        block(error);
    }];
}

+ (void)getOneCardBalanceData:(void(^)(NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{
                                 @"map": @{
                                         @"method": @"getCardStatusInfo",
                                         @"params": [NSNull null]
                                         },
                                 @"javaClass": @"java.util.HashMap"
                                 };
    [manager POST:SZGD_ONECARD_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        HWYOneCardBalanceData *oneCardBalance = [HWYOneCardBalanceData getOneCardBalanceDataFromDict:responseObject];
        [HWYOneCardBalanceData saveOneCardBalanceData:oneCardBalance];
        block(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        block(error);
    }];
}

+ (void)getOneCardRecordData:(void(^)(NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
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
    [manager POST:SZGD_ONECARD_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *oneCardRecordArr = [HWYOneCardRecordData getOneCardRecordDataFromDict:responseObject];
        [HWYOneCardRecordData saveOneCardRecordData:oneCardRecordArr];
        block(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        block(error);
    }];
}

+ (void)getLogoutSzgd:(void(^)(BOOL szgd, NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:SZGD_LOGOUT_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"数字工大注销成功!");
        block(YES, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error);
        block(NO, error);
    }];
}

+ (void)getNewsListData:(void(^)(NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{
                                 @"map": @{@"method": @"getPimPlateList",
                                           @"params": [NSNull null]
                                           },
                                 @"javaClass": @"java.util.HashMap"
                                 };
    [manager POST:SZGD_CMS_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *pimListArr = [HWYNewsListData getNewsListDataFromDict:responseObject];
        [HWYNewsListData saveNewsListData:pimListArr];
        block(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        block(error);
    }];
}

+ (void)getNewsInfoData:(NSString *)plateid type:(NSInteger)type compelet:(void(^)(NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *method = [NSString string];
    NSArray *list = [NSArray array];
    if (type == 0) {
        method = @"getPimInfo";
        list =  @[plateid, @"", @"", @""];
    } else {
        method = @"getPimInfoByType";
        list =  @[plateid, @"1"];
    }
    NSDictionary *parameters = @{
                                 @"map": @{
                                     @"method": method,
                                     @"params": @{
                                         @"javaClass": @"java.util.ArrayList",
                                         @"list": list
                                     },
                                     @"pm": @{
                                         @"javaClass": @"com.neusoft.education.edp.client.PageManager",
                                         @"pageSize": @30,
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
                                         @"resPojoName": @"com.neusoft.education.dcp.apps.cms.entity.CmsInfoListEntity"
                                     }
                                 },
                                 @"javaClass": @"java.util.HashMap"
                                 };
    [manager POST:SZGD_CMS_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *newsInfoArr = [HWYNewsInfoData getNewsInfoFromDict:responseObject];
        [HWYNewsInfoData saveNewsInfoData:newsInfoArr type:type];
        block(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        block(error);
    }];
}

+ (void)getNewsInfoDetailData:(NSString *)resourceid compelet:(void(^)(NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{
                                 @"map": @{
                                     @"method": @"getPimInfoDetail",
                                     @"params": @{
                                         @"javaClass": @"java.util.ArrayList",
                                         @"list": @[resourceid]
                                     }
                                 },
                                 @"javaClass": @"java.util.HashMap"
                                 };
    [manager POST:SZGD_CMS_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        HWYNewsInfoDetailData *newsInfoDetail = [HWYNewsInfoDetailData getNewsInfoDetailDataFromDict:responseObject];
        [HWYNewsInfoDetailData saveNewsInfoDetailData:newsInfoDetail];
        block(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        block(error);
    }];
}

+ (void)getNoticeListData:(void(^)(NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{
                                 @"map": @{@"method": @"getPimType",
                                           @"params": [NSNull null]
                                           },
                                 @"javaClass": @"java.util.HashMap"
                                 };
    [manager POST:SZGD_PIM_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *noticeListArr = [HWYNoticeListData getNoticeListDataFromDict:responseObject];
        [HWYNoticeListData saveNoticeListData:noticeListArr];
        block(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        block(error);
    }];
}

+ (void)getNoticeInfoData:(NSString *)plateid compelet:(void(^)(NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{
                                 @"map": @{
                                     @"method": @"getPimInfo",
                                     @"params": @{
                                         @"javaClass": @"java.util.ArrayList",
                                         @"list": @[plateid, @"", @"", @"", @""]
                                     },
                                     @"pm": @{
                                         @"javaClass": @"com.neusoft.education.edp.client.PageManager",
                                         @"pageSize": @30,
                                         @"pageNo": @1,
                                         @"totalCount": @-1,
                                         @"order":  [NSNull null],
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
                                         @"resPojoName": @"com.neusoft.education.dcp.apps.pim.entity.PimInfoListEntity"
                                     }
                                 },
                                 @"javaClass": @"java.util.HashMap"
                                 };
    [manager POST:SZGD_PIM_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *noticeInfoArr = [HWYNoticeInfoData getNoticeInfoFromDict:responseObject];
        [HWYNoticeInfoData saveNoticeInfoData:noticeInfoArr];
        block(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        block(error);
    }];
}

+ (void)getNoticeInfoDetailData:(NSString *)resourceid compelet:(void(^)(NSError *error)) block {
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSDictionary *parameters = @{
                                 @"map": @{
                                         @"method": @"getPimInfoDetail",
                                         @"params": @{
                                                 @"javaClass": @"java.util.ArrayList",
                                                 @"list": @[resourceid]
                                                 }
                                         },
                                 @"javaClass": @"java.util.HashMap"
                                 };
    [manager POST:SZGD_PIM_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        HWYNoticeInfoDetailData *noticeInfoDetail = [HWYNoticeInfoDetailData getNoticeInfoDetailDataFromDict:responseObject];
        [HWYNoticeInfoDetailData saveNoticeInfoDetailData:noticeInfoDetail];
        block(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        block(error);
    }];
}

@end
