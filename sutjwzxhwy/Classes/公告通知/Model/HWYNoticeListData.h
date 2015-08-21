//
//  HWYSutNoticeData.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/26.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYNoticeListData : NSObject

@property (copy, nonatomic) NSString *PLATE_ID;
@property (copy, nonatomic) NSString *SCOPE_ID;
@property (copy, nonatomic) NSString *NAME;

+ (NSArray *)getNoticeListDataFromDict:(NSDictionary *)dict;

+ (void)saveNoticeListData:(NSArray *)arr;

+ (NSArray *)getNoticeListData;

@end
