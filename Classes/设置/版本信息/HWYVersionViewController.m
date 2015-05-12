//
//  HWYVersionViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 15/1/2.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import "HWYVersionViewController.h"
#import "HWYGeneralConfig.h"

@interface HWYVersionViewController ()

@end

@implementation HWYVersionViewController

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
    [self configTitleAndBackItem:@"版本信息"];
}

- (void)initView {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((P_WIDTH - 100)/2, 100, 100, 100)];
    imageView.image = [UIImage imageNamed:@"icon_sut"];
    [self.view addSubview:imageView];
    
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 230, P_WIDTH, 21)];
    nameLable.font = [UIFont boldSystemFontOfSize:22.0];
    nameLable.textAlignment = NSTextAlignmentCenter;
    nameLable.text = _K_DISPLAYNAME_STRING;
    [self.view addSubview:nameLable];
    
    UILabel *versionLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 260, P_WIDTH, 21)];
    versionLable.font = [UIFont systemFontOfSize:17.0];
    versionLable.textColor = [UIColor grayColor];
    versionLable.textAlignment = NSTextAlignmentCenter;
    versionLable.text = [NSString stringWithFormat:@"当前版本v%@", _K_VERSION_STRING];
    [self.view addSubview:versionLable];
    
    UILabel *descLable = [[UILabel alloc] initWithFrame:CGRectMake(0, P_HEIGHT - 41, P_WIDTH, 21)];
    descLable.font = [UIFont systemFontOfSize:11.0];
    descLable.textColor = [UIColor grayColor];
    descLable.textAlignment = NSTextAlignmentCenter;
    descLable.text = @"Copyright (c) 2014年 hanwy. All rights reserved.";
    [self.view addSubview:descLable];
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
