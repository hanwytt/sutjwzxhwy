//
//  HWYAppDefine.h
//  sutjwzxhwy
//
//  Created by hanwy on 15/5/14.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#ifndef sutjwzxhwy_HWYAppDefine_h
#define sutjwzxhwy_HWYAppDefine_h

#define KSatusBarHeight     20
#define KNavBarHeight       44
#define KTabBarHeight       49;
#define KScreenWidth        ([UIScreen mainScreen].bounds.size.width)
#define KScreenHeight       ([UIScreen mainScreen].bounds.size.height)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPHONE5_HEIGHT_LESS (iPhone5?88:0)

#define P_WIDTH             320                            //窗口宽度

#define P_HEIGHT            (iPhone5?568:480)              //窗口高度

//设置颜色
#define KColor(R,G,B)       [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

//蓝色
#define KBlueColor          KColor(41, 133, 226)

//cell选中颜色
#define KCellSelectedColor  KColor(220, 234, 240)

//请求超时时间
#define KRequestTimeOut     30

//判断数组是否为空
#define KArrayEmpty(arr)    (arr == nil || arr.count == 0)
//字符串空判断
#define KStringExist(str)   (str != nil && str.length > 0 && ![str isEqualToString:@""])

//Document文件路径
#define KDocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject]

//数据库名
#define KDatabase           @"sutjwzx.sqlite"

//系统版本号
#define KiOSVersion         [[UIDevice currentDevice] systemVersion] floatValue]

//程序信息
#define KInfoDictionary     [[NSBundle mainBundle] infoDictionary]
//程序名
#define KBundleDisplayName  [KInfoDictionary objectForKey:@"CFBundleDisplayName"];
//程序版本号
#define KBundleVersion      [KInfoDictionary objectForKey:@"CFBundleVersion"]

//NSUserDefaults
#define KUserDefaults       [NSUserDefaults standardUserDefaults]

//默认账户
#define KDefaultNumber      @"defaultNumber"

//离线模式
#define KModeOffline        @"OffLineMode"
//记住密码
#define KModeRememb         @"RemembMode"
//自动识别
#define KModeAutoIdentification     @"AutoIdentification"

//自动识别
#define KFirstLaunch                @"firstLaunch"

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#endif
