//
//  HWYMenuData.h
//  sutjwzxhwy
//
//  Created by hanwy on 15/4/25.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWYMenuData : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)menuWithDict:(NSDictionary *)dict;

@end
