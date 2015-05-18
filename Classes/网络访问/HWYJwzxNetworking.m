//
//  HWYJwzxNetworking.m
//  sutjwzxhwy
//
//  Created by hanwy on 15/5/15.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import "HWYJwzxNetworking.h"

@implementation HWYJwzxNetworking

+ (void)loginJwzx:(id)parameters compelet:(void(^)(HWYLoginJwzxData *jwzx))block {
    [HWYNetworkingHtml POST:JWZX_LOGIN_URL paramters:parameters success:^(id responseObject) {
        block([HWYLoginJwzxData getLoginJwzxDataFromHtml:responseObject]);
    } failure:^(NSError *error) {
        block(nil);
    }];
}

+ (void)getInformationData:(void (^)())block {

}

+ (void)getScheduleData:(NSString *)semester compelet:(void (^)())block {

}

+ (void)getReportCardData:(void (^)())block {

}

+ (void)logoutJwzx:(void (^)(BOOL))block {

}

@end
