//
//  HWYOneCardData.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYOneCardBalanceData : NSObject

@property (copy, nonatomic) NSString *XH;
@property (copy, nonatomic) NSString *YKT;
@property (copy, nonatomic) NSString *YE;
@property (copy, nonatomic) NSString *ZYXF;
@property (copy, nonatomic) NSString *JRXF;
@property (copy, nonatomic) NSString *CARD_ID;

+ (HWYOneCardBalanceData *)getOneCardBalanceDataFromDict:(NSDictionary *)dict;
+ (void)saveOneCardBalanceData:(HWYOneCardBalanceData *)oneCardBalance;
+ (HWYOneCardBalanceData *)getOneCardBalanceData;

@end

@interface HWYOneCardRecordData : NSObject

@property (copy, nonatomic) NSString *XH;
@property (copy, nonatomic) NSString *YKT;
@property (copy, nonatomic) NSString *JE;
@property (copy, nonatomic) NSString *ZDMC;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *CARD_ID;

+ (NSArray *)getOneCardRecordDataFromDict:(NSDictionary *)dict;
+ (void)saveOneCardRecordData:(NSArray *)arr;
+ (NSArray *)getOneCardRecordData;
@end
