//
//  NSDate+MJ.h
//  ItcastWeibo
//
//  Created by apple on 14-5-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIView (Log)

+ (NSString *)searchAllSubviews:(UIView *)superview;

- (NSString *)description;

@end

@interface NSDictionary (Log)

- (NSString *)descriptionWithLocale:(id)locale;

@end

@interface NSArray (Log)

- (NSString *)descriptionWithLocale:(id)locale;

@end
