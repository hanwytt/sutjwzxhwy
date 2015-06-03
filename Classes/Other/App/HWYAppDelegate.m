//
//  AppDelegate.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYAppDelegate.h"
#import "HWYMainViewController.h"
#import "HWYAppDefine.h"
#import "MBProgressHUD+MJ.h"

@interface HWYAppDelegate ()

@end

@implementation HWYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window .backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    application.statusBarStyle = UIStatusBarStyleLightContent;
    
    self.menuVisible = YES;
    
    HWYMainViewController *root = [[HWYMainViewController alloc] init];
    self.window.rootViewController = root;
    
    [self isFirstLaunch];
    
    return YES;
}

- (void)isFirstLaunch {
    if (![KUserDefaults boolForKey:KFirstLaunch]) {
        [KUserDefaults setBool:YES forKey:KFirstLaunch];
        [KUserDefaults synchronize];
        [self initData];
        NSLog(@"YES");
    }
}

- (void)initData {
    [KUserDefaults setBool:NO forKey:KModeOffline];
    [KUserDefaults setBool:NO forKey:KModeRememb];
    [KUserDefaults setBool:NO forKey:KModeAutoIdentification];
    [KUserDefaults setValue:@"" forKey:KDefaultNumber];
    [KUserDefaults synchronize];
}

+ (HWYAppDelegate *)shareDelegate
{
    return [UIApplication sharedApplication].delegate;
}

+ (BOOL)isReachable {
    Reachability *reachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus status = [reachable currentReachabilityStatus];
    switch (status) {
        case NotReachable:   // 没有网络连接
            return NO;
            break;
        case ReachableViaWWAN:  // 使用蜂窝移动网络
            return YES;
            break;
        case ReachableViaWiFi:  // 使用WiFi网络
            return YES;
            break;
    }
}

- (void)reachableChanged:(NSNotification*)note {
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            [MBProgressHUD showInfo:@"当前网络不可用"];
            break;
        case ReachableViaWWAN:
            [MBProgressHUD showInfo:@"正在使用蜂窝移动网络"];
            break;
        case ReachableViaWiFi:
            [MBProgressHUD showInfo:@"正在使用WiFi"];
            break;
        default:
            break;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [_reachable stopNotifier];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachableChanged:) name:kReachabilityChangedNotification object:nil];
    _reachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [_reachable startNotifier];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
