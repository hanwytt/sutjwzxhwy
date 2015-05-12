//
//  HWYGeneralConfig.h
//  LolBoxhwy
//
//  Created by hanwy on 14/12/3.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#ifndef LolBoxhwy_HWYGeneralConfig_h
#define LolBoxhwy_HWYGeneralConfig_h

#define STATUS_BAR_HEIGHT 20
#define NAVIGATIONBAR_HEIGHT 44
#define TABBAR_HEIGHT 49;

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640,1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IPHONE5_HEIGHT_LESS (iPhone5?88:0)


#define FONT_HELVETICANEUE      @"Helvetica Neue"

#define P_WIDTH             320                            //窗口宽度

#define P_HEIGHT            (iPhone5?568:480)              //窗口高度

//设置颜色
#define kColor(R,G,B)             [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

//蓝色
#define _K_BLUE_COLOR             kColor(41, 133, 226)

//cell选中颜色
#define _K_CELL_SELECTED_COLOR    kColor(220, 234, 240)

//请求超时时间
#define _K_REQUEST_TIMEOUT        30

//判断数组是否为空
#define kArrayEmpty(arr)    (arr == nil || arr.count == 0)
//字符串空判断
#define kStringExist(str)   (str != nil && str.length > 0 && ![str isEqualToString:@""])

//Document文件路径
#define DocumentsDirectory [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject]

//数据库名
#define _K_DATABASE         @"sutjwzx.sqlite"

//系统版本号
#define _K_SYSTEMVERSION_INTEGER [[UIDevice currentDevice] systemVersion] integerValue]

//程序信息
#define infoDictionary  [[NSBundle mainBundle] infoDictionary]
//程序名
#define _K_DISPLAYNAME_STRING [infoDictionary objectForKey:@"CFBundleDisplayName"];
//程序版本号
#define _K_VERSION_STRING [infoDictionary objectForKey:@"CFBundleVersion"]

//NSUserDefaults
#define userDefaults [NSUserDefaults standardUserDefaults]

//默认账户
#define _K_DEFAULT_NUMBER    @"defaultNumber"

//离线模式
#define _K_MODE_OFFLINE                @"OffLineMode"
//记住密码
#define _K_MODE_REMEMb                 @"RemembMode"
//自动识别
#define _K_MODE_AUTOIDENTIFICATION     @"AutoIdentification"

#endif
