//
//  HWYInformationData.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYInformationData : NSObject

@property (copy, nonatomic) NSString *number;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *sex;
@property (copy, nonatomic) NSString *nation;
@property (copy, nonatomic) NSString *school;
@property (copy, nonatomic) NSString *department;
@property (copy, nonatomic) NSString *major;
@property (copy, nonatomic) NSString *className;
@property (copy, nonatomic) NSString *grade;
@property (copy, nonatomic) NSString *education;
@property (copy, nonatomic) NSString *idCardNo;
@property (copy, nonatomic) NSString *interval;
@property (copy, nonatomic) NSData *imageData;

+ (HWYInformationData *)getInformationDataFromHtml:(id)responseObject;
+ (void)saveInformationData:(HWYInformationData *)info;
+ (HWYInformationData *)getInformationData:(NSString *)number;
+ (void)saveInfoImageData:(NSData *)data number:(NSString *)number;
+ (NSData *)getInfoImageData:(NSString *)number;
    
@end
