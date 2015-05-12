//
//  AppDelegate.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWYAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) BOOL menuVisible;

+ (HWYAppDelegate *)shareDelegate;
+ (BOOL)isReachable;
@end

