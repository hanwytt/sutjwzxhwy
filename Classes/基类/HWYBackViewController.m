//
//  HWYBackViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/31.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYBackViewController.h"

@interface HWYBackViewController ()

@end

@implementation HWYBackViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBaseView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBaseView {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configTitleAndBackItem:(NSString *)title {
    [self.navigationItem setTitle:title];
    UIImage *backImage = [[UIImage imageNamed:@"icon_back_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick:)];
    [self.navigationItem setLeftBarButtonItem:backItem];
}

- (void)backItemClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
