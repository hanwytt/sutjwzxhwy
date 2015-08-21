//
//  HWYSutNewsData.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/26.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYNewsInfoData : NSObject

@property (copy, nonatomic) NSString *RESOURCE_ID;
@property (copy, nonatomic) NSString *SCOPE_ID;
@property (copy, nonatomic) NSString *UNIT_NAME;
@property (copy, nonatomic) NSString *AUDIT_TIME;
@property (copy, nonatomic) NSString *PLATE_ID;
@property (copy, nonatomic) NSString *PLATE_NAME;
@property (copy, nonatomic) NSString *TITLE;
@property (copy, nonatomic) NSString *VIEW_COUNT;
@property (assign, nonatomic) Boolean IS_TOP;
@property (assign, nonatomic) Boolean IS_IMPORTANT;

+ (NSArray *)getNewsInfoFromDict:(NSDictionary *)dict;
+ (void)saveNewsInfoData:(NSArray *)arr type:(NSInteger)type;
+ (NSArray *)getNewsInfoData:(NSString *)plateid type:(NSInteger)type;

@end
