//
//  HWYNoticeInfoDetailViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/30.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNoticeInfoDetailViewController.h"
#import "HWYNoticeInfoDetailData.h"
#import "HWYNewsNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "HWYAppDefine.h"


@interface HWYNoticeInfoDetailViewController () {
    HWYNoticeInfoDetailData *_noticeInfoDetail;
}
@property (strong,nonatomic) UINavigationBar *navBar;
@property (strong,nonatomic) UINavigationItem *navItem;
@property (strong,nonatomic) UIWebView *webView;

@end

@implementation HWYNoticeInfoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
    [self requestNetworking];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavBar {
    [self configTitleAndBackItem:@"通知详情"];
}

- (void)initView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64)];
    [self.view addSubview:_webView];
}

- (void)initNoticeInfoDetail {
    _noticeInfoDetail = [HWYNoticeInfoDetailData getNoticeInfoDetailData:_resourceid];
    NSString *htmlString = [NSString string];
    if (!KStringExist(_noticeInfoDetail.CONTENT)) {
        [MBProgressHUD showError:@"通知内容为空" toView:self.view];
    }
    htmlString = [self getHtmlString];
    [_webView loadHTMLString:htmlString baseURL:nil];
}

- (void)requestNetworking {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"新闻详情-离线模式");
        [self didAfterDelay:^{
            [self initNoticeInfoDetail];
            [hud hide:YES];
        }];
    } else {
        NSLog(@"新闻详情-正常模式");
        [HWYNewsNetworking getNoticeInfoDetailData:_resourceid compelet:^(NSError *error) {
            [self initNoticeInfoDetail];
            [hud hide:YES];
        }];

    }
}

- (NSString *)getHtmlString {
    NSMutableString *htmlString=[[NSMutableString alloc]initWithString:@"<html>"];
    [htmlString appendString:@"<head>"];
    [htmlString appendString:@"<meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\"/>"];
    [htmlString appendString:@"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1; user-scalable=no;\"/>"];
    [htmlString appendString:@"<style>"];
    [htmlString appendString:@".text-title {font-size: 15pt;font-family: \"宋体\";color: #563960;font-weight: bolder;}"];
    [htmlString appendString:@".text-content {font-size: 10pt;color: #666666;text-decoration: none;line-height: 22px;}"];
    [htmlString appendString:@"</style>"];
    [htmlString appendString:@"</head>"];
    [htmlString appendString:@"<body>"];
    [htmlString appendFormat:@"<p align=\"center\"><strong>%@</strong></p>", _noticeInfoDetail.TITLE];
    if (!KStringExist(_noticeInfoDetail.UNIT_NAME)) {
        _noticeInfoDetail.UNIT_NAME = @"";
    }
    if (!KStringExist(_noticeInfoDetail.USER_NAME)) {
        _noticeInfoDetail.USER_NAME = @"";
    }
    [htmlString appendFormat:@"<p align=\"center\" class=\"text-content\"><strong>%@&nbsp;&nbsp;%@&nbsp;&nbsp;%@</strong></p>", _noticeInfoDetail.AUDIT_TIME, _noticeInfoDetail.UNIT_NAME, _noticeInfoDetail.USER_NAME];
    [htmlString appendFormat:@"<div align=\"left\" class=\"text-content\">%@</div>", _noticeInfoDetail.CONTENT];
    [htmlString appendFormat:@"<p align=\"right\" class=\"text-content\"><font color=\"#666666\">访问量：</font>%@</p>", _noticeInfoDetail.VIEW_COUNT];
    [htmlString appendString:@"</body></html>"];
    return htmlString;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
