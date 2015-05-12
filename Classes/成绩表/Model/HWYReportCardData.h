//
//  HWYReportCardsData.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYReportCountData : NSObject

@property (copy, nonatomic) NSString *bxCount;
@property (copy, nonatomic) NSString *xxCount;
@property (copy, nonatomic) NSString *rxCount;
@property (copy, nonatomic) NSString *stuCount;

+ (HWYReportCountData *)getReportCountFromHtml:(id)responseObject;
+ (void)saveReportCountData:(HWYReportCountData *)reportCount;
+ (HWYReportCountData *)getReportCountData;

@end

@interface HWYReportCardData : NSObject

@property (assign, nonatomic) NSInteger ordernum;
@property (copy, nonatomic) NSString *semesterId;
@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *courseName;
@property (copy, nonatomic) NSString *period;
@property (copy, nonatomic) NSString *credit;
@property (copy, nonatomic) NSString *semester;
@property (copy, nonatomic) NSString *property;
@property (copy, nonatomic) NSString *score;

+ (NSArray *)getReportCardArrFromHtml:(id)responseObject;
+ (void)saveReportCardData:(NSArray *)arr;
+ (NSArray *)getReportCardData;
+ (NSArray *)queryReportCardData:(NSString *)courseName;

@end
