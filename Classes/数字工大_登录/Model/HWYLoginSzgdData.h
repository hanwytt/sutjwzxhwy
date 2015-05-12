//
//  HWYLoginSzgdData.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/19.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYLoginSzgdData : NSObject

@property (assign, nonatomic) BOOL success;
@property (copy, nonatomic) NSString *lt;
@property (copy, nonatomic) NSString *href;

+ (NSString *)getLoginSzgdLtFromHtml:(id)responseObject;
+ (HWYLoginSzgdData *)getLoginSzgdDataFromHtml:(id)responseObject;
+ (void)saveLoginSzgdData:(NSString *)name password:(NSString *)password;
+ (NSString *)getLoginSzgdPassword:(NSString *)name;

@end
