//
//  HWYInformationHtmlViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 15/1/5.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import "HWYInformationWebViewController.h"
#import "HWYGeneralConfig.h"
#import "HWYURLConfig.h"
#import "MBProgressHUD.h"
#import "HWYAppDelegate.h"

@interface HWYInformationWebViewController ()

@end

@implementation HWYInformationWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavBar {
    [self configTitleAndBackItem:@"学生信息"];
}

- (void)initView {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64)];
    webView.scalesPageToFit = YES;
//    NSURL *url = [NSURL URLWithString:JWZX_INFO_URL];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中";
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    [hud show:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:JWZX_INFO_URL];
        NSData * data = [[NSData alloc] initWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data != nil) {
                [webView loadData:data MIMEType:nil textEncodingName:nil baseURL:nil];
                [hud hide:YES];
            } else {
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"加载失败";
                [hud hide:YES afterDelay:0.5];
            }
        });
    });
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
