//
//  HWYBaseNavigationController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/31.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNavigationController.h"

@interface HWYNavigationController ()

@end

@implementation HWYNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBaseNavBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBaseNavBar {
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_nav_bar_iOS7"] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = NO;
    self.navigationBar.titleTextAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName: [UIColor whiteColor]};
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
