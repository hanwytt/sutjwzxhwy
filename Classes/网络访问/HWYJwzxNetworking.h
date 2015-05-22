//
//  HWYJwzxNetworking.h
//  sutjwzxhwy
//
//  Created by hanwy on 15/5/15.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWYNetworkingHtml.h"
#import "HWYLoginJwzxData.h"

@interface HWYJwzxNetworking : NSObject

+ (void)loginJwzx:(id)parameters compelet:(void(^)(HWYLoginJwzxData *jwzx))block;

+ (void)getInformationData:(void(^)()) block;

+ (void)getScheduleData:(NSString *)semester compelet:(void(^)())block;

+ (void)getReportCardData:(void(^)())block;

+ (void)logoutJwzxSuccess:(void(^)())success failure:(void(^)())failure;

@end
