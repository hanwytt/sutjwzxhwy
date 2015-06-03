//
//  HWYNewsNetworking.h
//  sutjwzxhwy
//
//  Created by hanwy on 15/5/15.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYNewsNetworking : NSObject

+ (void)getNewsListData:(void(^)())block;

+ (void)getNewsInfoData:(NSString *)plateid type:(NSInteger)type compelet:(void(^)())block;

+ (void)getNewsInfoDetailData:(NSString *)resourceid compelet:(void(^)())block;

+ (void)getNoticeListData:(void(^)())block;

+ (void)getNoticeInfoData:(NSString *)plateid compelet:(void(^)())block;

+ (void)getNoticeInfoDetailData:(NSString *)resourceid compelet:(void(^)())block;

@end
