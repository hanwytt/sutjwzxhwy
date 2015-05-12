//
//  HWYLoginViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/23.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYLoginViewController.h"
#import "HWYGeneralConfig.h"

@interface HWYLoginViewController ()

@property (strong,nonatomic) UINavigationBar *navBar;
@property (strong,nonatomic) UINavigationItem *navItem;

@end

@implementation HWYLoginViewController

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
//    _navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, P_WIDTH, STATUS_BAR_HEIGHT+NAVIGATIONBAR_HEIGHT)];
//    [_navBar setBackgroundImage:[UIImage imageNamed:@"bg_nav_bar_iOS7"] forBarMetrics:UIBarMetricsDefault];
//    _navBar.translucent = NO;
//    _navBar.titleTextAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName: [UIColor whiteColor]};
//    _navItem = [[UINavigationItem alloc] initWithTitle:nil];
//    UIImage *leftImage = [[UIImage imageNamed:@"icon_cancel_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
//    [_navItem setLeftBarButtonItem:leftItem];
//    [_navBar pushNavigationItem:_navItem animated:YES];
//    [self.view addSubview:_navBar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [tap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configTitle:(NSString *)title{
//    [_navItem setTitle:title];
    [self.navigationItem setTitle:title];
    UIImage *leftImage = [[UIImage imageNamed:@"icon_cancel_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}

-(void)leftItemClick:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

-(void)tap:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
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
