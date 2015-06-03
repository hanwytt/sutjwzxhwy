//
//  HWYNewsNetworking.m
//  sutjwzxhwy
//
//  Created by hanwy on 15/5/15.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import "HWYNewsNetworking.h"
#import "HWYNetworkingJson.h"
#import "HWYNewsListData.h"
#import "HWYNewsInfoData.h"
#import "HWYNewsInfoDetailData.h"
#import "HWYNoticeListData.h"
#import "HWYNoticeInfoData.h"
#import "HWYNoticeInfoDetailData.h"

@implementation HWYNewsNetworking

+ (void)getNewsListData:(void(^)())block {
    NSDictionary *parameters = @{
                                 @"map": @{@"method": @"getPimPlateList",
                                           @"params": [NSNull null]
                                           },
                                 @"javaClass": @"java.util.HashMap"
                                 };
    [HWYNetworkingJson POST:SZGD_CMS_URL paramters:parameters success:^(id responseObject) {
        NSArray *pimListArr = [HWYNewsListData getNewsListDataFromDict:responseObject];
        [HWYNewsListData saveNewsListData:pimListArr];
        block();
    } failure:^(NSError *error) {
        block();
    }];
}


+ (void)getNewsInfoData:(NSString *)plateid type:(NSInteger)type compelet:(void(^)())block {
    NSString *method = nil;
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
    
    [HWYNetworkingJson POST:SZGD_CMS_URL paramters:parameters success:^(id responseObject) {
        NSArray *newsInfoArr = [HWYNewsInfoData getNewsInfoFromDict:responseObject];
        [HWYNewsInfoData saveNewsInfoData:newsInfoArr type:type];
        block();
    } failure:^(NSError *error) {
        block();
    }];
}

+ (void)getNewsInfoDetailData:(NSString *)resourceid compelet:(void(^)())block {
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
    [HWYNetworkingJson POST:SZGD_CMS_URL paramters:parameters success:^(id responseObject) {
        HWYNewsInfoDetailData *newsInfoDetail = [HWYNewsInfoDetailData getNewsInfoDetailDataFromDict:responseObject];
        [HWYNewsInfoDetailData saveNewsInfoDetailData:newsInfoDetail];
        block();
    } failure:^(NSError *error) {
        block();
    }];
}

+ (void)getNoticeListData:(void(^)())block {
    NSDictionary *parameters = @{
                                 @"map": @{@"method": @"getPimType",
                                           @"params": [NSNull null]
                                           },
                                 @"javaClass": @"java.util.HashMap"
                                 };
    [HWYNetworkingJson POST:SZGD_PIM_URL paramters:parameters success:^(id responseObject) {
        NSArray *noticeListArr = [HWYNoticeListData getNoticeListDataFromDict:responseObject];
        [HWYNoticeListData saveNoticeListData:noticeListArr];
        block();
    } failure:^(NSError *error) {
        block();
    }];
}

+ (void)getNoticeInfoData:(NSString *)plateid compelet:(void(^)())block {
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
    [HWYNetworkingJson POST:SZGD_PIM_URL paramters:parameters success:^(id responseObject) {
        NSArray *noticeInfoArr = [HWYNoticeInfoData getNoticeInfoFromDict:responseObject];
        [HWYNoticeInfoData saveNoticeInfoData:noticeInfoArr];
        block();
    } failure:^(NSError *error) {
        block();
    }];
}

+ (void)getNoticeInfoDetailData:(NSString *)resourceid compelet:(void(^)())block {
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
    [HWYNetworkingJson POST:SZGD_PIM_URL paramters:parameters success:^(id responseObject) {
        HWYNoticeInfoDetailData *noticeInfoDetail = [HWYNoticeInfoDetailData getNoticeInfoDetailDataFromDict:responseObject];
        [HWYNoticeInfoDetailData saveNoticeInfoDetailData:noticeInfoDetail];
        block();
    } failure:^(NSError *error) {
        block();
    }];
}

@end
