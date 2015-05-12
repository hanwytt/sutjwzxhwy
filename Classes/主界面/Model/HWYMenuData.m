//
//  HWYMenuData.m
//  sutjwzxhwy
//
//  Created by hanwy on 15/4/25.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import "HWYMenuData.h"

@implementation HWYMenuData

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.title = dict[@"title"];
        self.icon = dict[@"icon"];
    }
    return self;
}

+ (instancetype)menuWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
