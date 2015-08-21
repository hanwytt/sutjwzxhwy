//
//  HWYAnalysisHtml.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/17.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWYLoginJwzxData.h"
#import "HWYLoginSzgdData.h"
#import "HWYScheduleData.h"

@interface HWYAnalysisHtml : NSObject

//解析登录教务在线结果
+ (HWYLoginJwzxData *)getLoginJwzxDataFromHtml:(id)responseObject;
//解析个人信息
+ (NSArray *)getInformationArrFromHtml:(id)responseObject;
//解析课程表
+ (NSArray *)getScheduleArrWithHttp:(id)responseObject;
//解析成绩表总计
+ (NSArray *)getReportCountArrWithHttp:(id)responseObject;
//解析成绩表成绩
+ (NSArray *)getReportCardArrWithHttp:(id)responseObject;
//解析登录数字工大加密字符串
+ (NSString *)getLoginSzgdLtWithHttp:(id)responseObject;
//解析登录数字工大结果
+ (HWYLoginSzgdData *)getLoginSzgdDataWithHttp:(id)responseObject;
@end
