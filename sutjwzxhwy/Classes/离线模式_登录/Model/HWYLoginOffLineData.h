//
//  HWYLoginOffLineData.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/23.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYLoginOffLineData : NSObject

+ (BOOL)getLoginOffLineData:(NSString *)name password:(NSString *)password;
+ (NSString *)getLoginOffLinePassword:(NSString *)name;

@end
