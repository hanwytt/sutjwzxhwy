//
//  HWYNewsListData.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/29.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYNewsListData : NSObject

@property (copy, nonatomic) NSString *PLATE_ID;
@property (copy, nonatomic) NSString *SCOPE_ID;
@property (copy, nonatomic) NSString *PLATE_NAME;

+ (NSArray *)getNewsListDataFromDict:(NSDictionary *)dict;

+ (void)saveNewsListData:(NSArray *)arr;

+ (NSArray *)getNewsListData;

@end
