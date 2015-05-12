//
//  AppDelegate.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYAppDelegate.h"
#import "Reachability.h"
#import "HWYMainViewController.h"
#import "HWYGeneralConfig.h"
#import "FMDB.h"

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
    if (![userDefaults boolForKey:@"firstLaunch"]) {
        [userDefaults setBool:YES forKey:@"firstLaunch"];
        [userDefaults synchronize];
        [self initDatabase];
        [self initData];
        NSLog(@"YES");
    }
}

- (void)initDatabase {
    NSString *dbpath = [DocumentsDirectory stringByAppendingPathComponent:_K_DATABASE];
    NSLog(@"%@", dbpath);
    FMDatabase* db = [FMDatabase databaseWithPath:dbpath];
    if (![db open]) {
        NSLog(@"Could not open db.");
        return;
    }
    NSString *jwzx_szgd_login = @"CREATE TABLE jwzx_szgd_login (number VARCHAR PRIMARY KEY NOT NULL, password_jwzx VARCHAR, password_szgd VARCHAR)";
    NSString *jwzx_info = @"CREATE TABLE jwzx_info (number VARCHAR PRIMARY KEY NOT NULL REFERENCES jwzx_szgd_login (number), name VARCHAR, sex VARCHAR, nation VARCHAR, school VARCHAR, department VARCHAR, major VARCHAR, className VARCHAR, grade VARCHAR, education VARCHAR, idCardNo VARCHAR, interval VARCHAR, imageData BLOB)";
    NSString *jwzx_schedule = @"CREATE TABLE jwzx_schedule (number VARCHAR NOT NULL REFERENCES jwzx_szgd_login (number), semester VARCHAR NOT NULL, week INTEGER NOT NULL, section INTEGER NOT NULL, courseId VARCHAR, course VARCHAR, teacher VARCHAR, schooltime VARCHAR, timedesc VARCHAR, room VARCHAR, PRIMARY KEY (number,semester,week,section))";
    NSString *jwzx_report_count = @"CREATE TABLE jwzx_report_count (number VARCHAR PRIMARY KEY NOT NULL REFERENCES jwzx_szgd_login (number), bxCount VARCHAR, xxCount VARCHAR, rxCount VARCHAR, stuCount VARCHAR)";
    NSString *jwzx_report_card = @"CREATE TABLE jwzx_report_card (number VARCHAR NOT NULL REFERENCES jwzx_szgd_login (number), courseId VARCHAR, courseName VARCHAR, semesterId VARCHAR, semester VARCHAR, period VARCHAR, credit VARCHAR, property VARCHAR, score VARCHAR, ordernum INTEGER, PRIMARY KEY (number,courseId))";
    NSString *szgd_bookborrow = @"CREATE TABLE szgd_bookborrow (number VARCHAR NOT NULL REFERENCES jwzx_szgd_login (number), propNo VARCHAR NOT NULL, mTitle VARCHAR, mAuthor VARCHAR, lendDate VARCHAR, normRetDate VARCHAR, PRIMARY KEY (number,propNo))";
    NSString *szgd_onecard_balance = @"CREATE TABLE szgd_onecard_balance (XH VARCHAR PRIMARY KEY NOT NULL REFERENCES jwzx_szgd_login (number), YKT VARCHAR, YE VARCHAR, ZYXF VARCHAR, JRXF VARCHAR, CARD_ID VARCHAR)";
    NSString *szgd_onecard_record = @"CREATE TABLE szgd_onecard_record (XH VARCHAR NOT NULL REFERENCES jwzx_szgd_login (number), YKT VARCHAR, JE VARCHAR, ZDMC VARCHAR, time VARCHAR, CARD_ID VARCHAR NOT NULL, PRIMARY KEY (XH,CARD_ID))";
    NSString *news_list = @"CREATE TABLE news_list (PLATE_ID VARCHAR PRIMARY KEY NOT NULL, SCOPE_ID VARCHAR, PLATE_NAME VARCHAR)";
    NSString *news_info = @"CREATE TABLE news_info (RESOURCE_ID VARCHAR PRIMARY KEY NOT NULL, SCOPE_ID VARCHAR, UNIT_NAME VARCHAR, AUDIT_TIME VARCHAR, PLATE_ID VARCHAR, PLATE_NAME VARCHAR, TITLE VARCHAR, VIEW_COUNT VARCHAR, IS_TOP BOOLEAN, IS_IMPORTANT BOOLEAN, NEWS_EDITOR VARCHAR,USER_NAME VARCHAR, NEWS_REPORTER VARCHAR, CONTENT VARCHAR)";
    NSString *notice_list = @"CREATE TABLE notice_list (PLATE_ID VARCHAR PRIMARY KEY NOT NULL, SCOPE_ID VARCHAR, NAME VARCHAR)";
    NSString *notice_info = @"CREATE TABLE notice_info (RESOURCE_ID VARCHAR PRIMARY KEY NOT NULL, SCOPE_ID VARCHAR, UNIT_NAME VARCHAR, AUDIT_TIME VARCHAR, PLATE_ID VARCHAR, PLATE_NAME VARCHAR, TITLE VARCHAR, VIEW_COUNT VARCHAR, NEWS_EDITOR VARCHAR,USER_NAME VARCHAR, NEWS_REPORTER VARCHAR, CONTENT VARCHAR)";
    [db executeUpdate:jwzx_szgd_login];
    [db executeUpdate:jwzx_info];
    [db executeUpdate:jwzx_schedule];
    [db executeUpdate:jwzx_report_count];
    [db executeUpdate:jwzx_report_card];
    [db executeUpdate:szgd_bookborrow];
    [db executeUpdate:szgd_onecard_balance];
    [db executeUpdate:szgd_onecard_record];
    [db executeUpdate:news_list];
    [db executeUpdate:news_info];
    [db executeUpdate:notice_list];
    [db executeUpdate:notice_info];
    [db close];
}

- (void)initData {
    [userDefaults setBool:NO forKey:_K_MODE_OFFLINE];
    [userDefaults setBool:NO forKey:_K_MODE_REMEMb];
    [userDefaults setBool:NO forKey:_K_MODE_AUTOIDENTIFICATION];
    [userDefaults setValue:@"" forKey:_K_DEFAULT_NUMBER];
    [userDefaults synchronize];
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
        case ReachableViaWWAN:  // 使用3G网络
            return YES;
            break;
        case ReachableViaWiFi:  // 使用WiFi网络
            return YES;
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
