//
//  HWYScheduleHtmlViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 15/1/5.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import "HWYScheduleWebViewController.h"
#import "HWYAppDefine.h"
#import "HWYURLConfig.h"
#import "MBProgressHUD.h"
#import "HWYAppDelegate.h"

@interface HWYScheduleWebViewController ()

@end

@implementation HWYScheduleWebViewController

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
    [self configTitleAndBackItem:@"课程表"];
}

- (void)initView {
    NSString *yearStr = [_semester substringToIndex:4];//0-4不包括4
    NSInteger year = [yearStr integerValue];
    year = (year - 2008) * 2;
    if ([_semester containsString:@"一"]) {
        year++;
    } else {
        year+=2;
    }
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64)];
    webView.scalesPageToFit = YES;
//    NSString *str = [NSString stringWithFormat:@"%@&YearTermNO=%ld", JWZX_SCHEDULE_URL, (long)year];
//    NSURL *url = [NSURL URLWithString:str];
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
        NSString *str = [NSString stringWithFormat:@"%@&YearTermNO=%ld", JWZX_SCHEDULE_URL, (long)year];
        NSURL *url = [NSURL URLWithString:str];
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
