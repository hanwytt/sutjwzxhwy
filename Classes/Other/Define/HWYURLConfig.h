//
//  HWYURLConfig.h
//  LolBoxhwy
//
//  Created by hanwy on 14/12/3.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#ifndef LolBoxhwy_HWYURLConfig_h
#define LolBoxhwy_HWYURLConfig_h
//教务在线->登录->验证码图片
#define JWZX_LOGIN_AGNOMENT_URL @"http://jwc.sut.edu.cn/ACTIONVALIDATERANDOMPICTURE.APPPROCESS"
//教务在线->登录->提交账号密码
#define JWZX_LOGIN_URL @"http://jwc.sut.edu.cn/ACTIONLOGON.APPPROCESS?mode=4"
//教务在线->个人信息
#define JWZX_INFO_URL @"http://jwc.sut.edu.cn/ACTIONQUERYSTUDENT.APPPROCESS"
//教务在线->个人信息->头像
#define JWZX_INFO_IMAGE_URL @"http://jwc.sut.edu.cn/ACTIONQUERYSTUDENTPIC.APPPROCESS?ByStudentNO=%@"
//教务在线->课程表
#define JWZX_SCHEDULE_URL @"http://jwc.sut.edu.cn/ACTIONQUERYELECTIVERESULTBYSTUDENT.APPPROCESS?mode=1"
//教务在线->成绩表
#define JWZX_REPORTCARD_URL @"http://jwc.sut.edu.cn/ACTIONQUERYSTUDENTSCHOOLREPORT.APPPROCESS?mode=1"
//教务在线->注销
#define JWZX_LOGOUT_URL @"http://jwc.sut.edu.cn/ACTIONLOGOUT.APPPROCESS"

//数字工大->登录界面(请求加密字符串和提交账号密码参数不同)
#define SZGD_LOGIN_URL @"http://cas.sut.edu.cn/cas/login"
//数字工大->图书借阅
#define JWZX_BOOKBORROW_URL @"http://portal.sut.edu.cn/dcp/fresh/fresh.action?type=json&r=json&gp="
//数字工大->一卡通(余额和消费记录参数不同)
#define SZGD_ONECARD_URL @"http://portal.sut.edu.cn/dcp/card/card.action?type=json&r=json&gp="
//数字工大->注销
#define SZGD_LOGOUT_URL @"http://cas.sut.edu.cn/cas/logout"

//新闻
#define SZGD_CMS_URL @"http://portal.sut.edu.cn/dcp/cms/cms.service?type=json&r=json&gp="
//通知
#define SZGD_PIM_URL @"http://portal.sut.edu.cn/dcp/pim/pim.service?type=json&r=json&gp="

#endif
