//
//  HWYSutNewsDetailViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/27.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNewsInfoDetailViewController.h"
#import "HWYNetworking.h"
#import "HWYGeneralConfig.h"
#import "MBProgressHUD.h"
#import "HWYAppDelegate.h"

@interface HWYNewsInfoDetailViewController () {
    HWYNewsInfoDetailData *_newsInfoDetail;
}
@property (strong,nonatomic) UINavigationBar *navBar;
@property (strong,nonatomic) UINavigationItem *navItem;
@property (strong,nonatomic) UIWebView *webView;
@end

@implementation HWYNewsInfoDetailViewController

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
    [self configTitleAndBackItem:@"新闻详情"];
}

- (void)initView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64)];
    [self.view addSubview:_webView];
}

- (void)initNewsInfoDetail {
    _newsInfoDetail = [HWYNewsInfoDetailData getNewsInfoDetailData:_resourceid];
    NSString *htmlString = [NSString string];
    if (kStringExist(_newsInfoDetail.CONTENT)) {
        htmlString = [self getHtmlString];
        [_webView loadHTMLString:htmlString baseURL:nil];
    } else {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.labelFont = [UIFont systemFontOfSize:15.0];
        hud.removeFromSuperViewOnHide = YES;
        [self.view addSubview:hud];
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"加载数据失败";
        [hud show:YES];
        [hud hide:YES afterDelay:0.5];
    }
}

- (void)requestNetworking {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中";
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    [hud show:YES];
    if ([userDefaults boolForKey:_K_MODE_OFFLINE]) {
        NSLog(@"新闻详情-离线模式");
        [self performSelector:@selector(initNewsInfoDetail) withObject:nil afterDelay:0.5];
        [hud hide:YES afterDelay:0.5];
    } else {
        if ([HWYAppDelegate isReachable]) {
            [HWYNetworking getNewsInfoDetailData:_resourceid compelet:^(NSError *error) {
                NSLog(@"新闻详情-正常模式");
                [self initNewsInfoDetail];
                [hud hide:YES];
            }];
        } else {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"当前网络不可用";
            [hud hide:YES afterDelay:0.5];
        }
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
    [htmlString appendFormat:@"<p align=\"center\"><strong>%@</strong></p>", _newsInfoDetail.TITLE];
    if (!kStringExist(_newsInfoDetail.NEWS_REPORTER)) {
        _newsInfoDetail.NEWS_REPORTER = @"";
    }
    if (!kStringExist(_newsInfoDetail.NEWS_EDITOR)) {
        _newsInfoDetail.NEWS_EDITOR = @"";
    }
    [htmlString appendFormat:@"<p align=\"center\" class=\"text-content\"><strong>%@&nbsp;&nbsp;%@&nbsp;&nbsp;%@</strong></p>", _newsInfoDetail.AUDIT_TIME, _newsInfoDetail.NEWS_REPORTER, _newsInfoDetail.NEWS_EDITOR];
    [htmlString appendFormat:@"<div align=\"left\" class=\"text-content\">%@</div>", _newsInfoDetail.CONTENT];
    [htmlString appendFormat:@"<p align=\"right\" class=\"text-content\"><font color=\"#666666\">访问量：</font>%@</p>", _newsInfoDetail.VIEW_COUNT];
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
