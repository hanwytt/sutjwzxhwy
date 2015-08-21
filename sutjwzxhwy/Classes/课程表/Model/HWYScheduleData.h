//
//  HWYScheduleData.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYScheduleData : NSObject

@property (copy, nonatomic) NSString *semester;
@property (assign, nonatomic) NSInteger week;
@property (assign, nonatomic) NSInteger section;
@property (copy, nonatomic) NSString *courseId;
@property (copy, nonatomic) NSString *course;
@property (copy, nonatomic) NSString *teacher;
@property (copy, nonatomic) NSString *schooltime;
@property (copy, nonatomic) NSString *timedesc;
@property (copy, nonatomic) NSString *room;

+ (NSArray *)getScheduleArrFromHtml:(id)responseObject withSemester:(NSString *)semester;
+ (void)saveScheduleData:(NSArray *)arr;
+ (NSArray *)getScheduleData:(NSString *)semester;

@end
