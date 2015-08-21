//
//  HWYNoticeInfoData.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/30.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYNoticeInfoData : NSObject

@property (copy, nonatomic) NSString *RESOURCE_ID;
@property (copy, nonatomic) NSString *SCOPE_ID;
@property (copy, nonatomic) NSString *UNIT_NAME;
@property (copy, nonatomic) NSString *AUDIT_TIME;
@property (copy, nonatomic) NSString *PLATE_ID;
@property (copy, nonatomic) NSString *PLATE_NAME;
@property (copy, nonatomic) NSString *TITLE;
@property (copy, nonatomic) NSString *VIEW_COUNT;
@property (copy, nonatomic) NSString *USER_NAME;

+ (NSArray *)getNoticeInfoFromDict:(NSDictionary *)dict;
+ (void)saveNoticeInfoData:(NSArray *)arr;
+ (NSArray *)getNoticeInfoData:(NSString *)plateid;

@end
