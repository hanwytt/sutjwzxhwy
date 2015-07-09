//
//  HWYScheduleHtmlViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 15/1/5.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import "HWYScheduleWebViewController.h"
#import "MBProgressHUD+MJ.h"
#import "HWYAppDefine.h"
#import "HWYURLConfig.h"
#import "UIWebView+Extension.h"

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
    year = (year - 2007) * 2;
    if ([_semester containsString:@"一"]) {
        year++;
    } else {
        year+=2;
    }
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64)];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    
    NSString *str = [NSString stringWithFormat:@"%@&YearTermNO=%ld", JWZX_SCHEDULE_URL, (long)year];
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [webView loadHtmlWithString:str success:^{
        [hud hide:YES];
    } failure:^{
        [hud hide:YES];
        [MBProgressHUD showError:@"加载失败" toView:self.view];
    }];
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
