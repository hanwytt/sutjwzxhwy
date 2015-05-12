//
//  HWYLoginJwzxData.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/18.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYLoginJwzxData : NSObject

@property (assign, nonatomic) BOOL success;
@property (copy, nonatomic) NSString *content;

+ (HWYLoginJwzxData *)getLoginJwzxDataFromHtml:(NSString *)responseString and:(id)responseObject;
+ (void)saveLoginJwzxData:(NSString *)name password:(NSString *)password;
+ (NSString *)getLoginJwzxPassword:(NSString *)name;

@end
