//
//  HWYJwzxNetworking.m
//  sutjwzxhwy
//
//  Created by hanwy on 15/5/15.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import "HWYJwzxNetworking.h"
#import "HWYInformationData.h"
#import "HWYScheduleData.h"
#import "HWYReportCardData.h"

@implementation HWYJwzxNetworking

+ (void)loginJwzx:(id)parameters compelet:(void(^)(HWYLoginJwzxData *jwzx))block {
    [HWYNetworkingHtml POST:JWZX_LOGIN_URL paramters:parameters success:^(id responseObject) {
        block([HWYLoginJwzxData getLoginJwzxDataFromHtml:responseObject]);
    } failure:^(NSError *error) {
        block(nil);
    }];
}

+ (void)getInformationData:(void (^)())block {
    [HWYNetworkingHtml GET:JWZX_INFO_URL paramters:nil success:^(id responseObject) {
        HWYInformationData *info = [HWYInformationData getInformationDataFromHtml:responseObject];
        [HWYInformationData saveInformationData:info];
        block();
    } failure:^(NSError *error) {
        block();
    }];
}

+ (void)getScheduleData:(NSString *)semester compelet:(void (^)())block {
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
   [HWYNetworkingHtml GET:JWZX_SCHEDULE_URL paramters:parameters success:^(id responseObject) {
       NSArray *scheduleArr = [HWYScheduleData getScheduleArrFromHtml:responseObject withSemester:semester];
       [HWYScheduleData saveScheduleData:scheduleArr];
       block();
   } failure:^(NSError *error) {
       block();
   }];
}

+ (void)getReportCardData:(void (^)())block {
    [HWYNetworkingHtml GET:JWZX_REPORTCARD_URL paramters:nil success:^(id responseObject) {
        HWYReportCountData *reportCount = [HWYReportCountData getReportCountFromHtml:responseObject];
        [HWYReportCountData saveReportCountData:reportCount];
        NSArray *reportCardArr = [HWYReportCardData getReportCardArrFromHtml:responseObject];
        [HWYReportCardData saveReportCardData:reportCardArr];
        block();
    } failure:^(NSError *error) {
        block();
    }];
}

+ (void)logoutJwzxSuccess:(void(^)())success failure:(void(^)())failure {
    [HWYNetworkingHtml GET:JWZX_LOGOUT_URL paramters:nil success:^(id responseObject) {
        NSLog(@"教务在线注销成功");
        success();
    } failure:^(NSError *error) {
        NSLog(@"教务在线注销失败");
        failure();
    }];
}

@end
