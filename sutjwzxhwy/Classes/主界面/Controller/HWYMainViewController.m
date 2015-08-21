//
//  HWYMainViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYMainViewController.h"
#import "HWYNavigationController.h"
#import "HWYLoginOffLineViewController.h"
#import "HWYLoginJwzxViewController.h"
#import "HWYLoginSzgdViewController.h"
#import "HWYNewsListViewController.h"
#import "HWYNoticeListViewController.h"
#import "HWYInformationViewController.h"
#import "HWYScheduleViewController.h"
#import "HWYReportCardViewController.h"
#import "HWYOneCardViewController.h"
#import "HWYBookBorrowViewController.h"
#import "HWYSetViewController.h"
#import "HWYInformationData.h"
#import "UIImage+Extension.h"
#import "MBProgressHUD+MJ.h"
#import "HWYAppDelegate.h"
#import "HWYAppDefine.h"
#import "HWYURLConfig.h"
#import "HWYMenuData.h"

static CGFloat range = P_WIDTH/2 - 70 + P_WIDTH * 0.8 * 0.5;

@interface HWYMainViewController () <UITableViewDataSource,UITableViewDelegate,HWYLoginJwzxState,HWYLoginSzgdState,HWYLoginOffLineState,HWYLogoutState,HWYMoveTransformView> {
    NSString *_identify;
    BOOL _offLine;
    BOOL _jwzx;
    BOOL _szgd;
    NSInteger _forwardRow;
    NSInteger _currentRow;
    HWYNavigationController *_nav;
    HWYRightViewController *_viewController;
}
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIImageView *btnImage;
@property (strong, nonatomic) UILabel *btnLable;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) NSArray *menuArr;
@end

@implementation HWYMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *)menuArr {
    if (_menuArr == nil) {
        //plist文件的路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"menu.plist" ofType:nil];
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dict in arr) {
            HWYMenuData *menu = [HWYMenuData menuWithDict:dict];
            [temp addObject:menu];
        }
        _menuArr = temp;
    }
    return _menuArr;
}

- (void)initView {
    _offLine = NO;
    _jwzx = NO;
    _szgd = NO;
    _forwardRow = -1;
    _currentRow = -1;
    _imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [_imageView setImage:[UIImage imageNamed:@"bg_home_default"]];
    [self.view addSubview:_imageView];
    
    //设置tableview的headview
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, P_WIDTH, 60)];
    _headerView.backgroundColor = [UIColor clearColor];
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(40, 0, 210, 50);
    _btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [_btnImage setImage:[UIImage imageNamed:@"bg_default_login"]];
    [_loginBtn addSubview:_btnImage];
    _btnLable = [[UILabel alloc] initWithFrame:CGRectMake(60, 15, 150, 21)];
    _btnLable.font =[UIFont boldSystemFontOfSize:20.0];
    _btnLable.textColor = [UIColor whiteColor];
    _btnLable.alpha = 0.5;
    _btnLable.text = @"登录";
    [_loginBtn addSubview:_btnLable];
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_loginBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(-100, 56, P_WIDTH, P_HEIGHT-56) style:UITableViewStylePlain];
    _tableView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.backgroundColor = [UIColor clearColor];
    _identify = @"menuCell";
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:_identify];
    [self.view addSubview:_tableView];
    [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
    if (cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.layoutMargins = UIEdgeInsetsMake(0, 50, 0, 0);
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:18.0];
    HWYMenuData *menu = self.menuArr[indexPath.row];
    cell.textLabel.text = menu.title;
    NSString *iconStr = [NSString string];
    if (_currentRow == indexPath.row) {
        cell.textLabel.alpha = 1.0;
        iconStr = [NSString stringWithFormat:@"icon_%@_selected", menu.icon];
    } else {
        cell.textLabel.alpha = 0.5;
        iconStr = [NSString stringWithFormat:@"icon_%@_normal", menu.icon];
    }
    cell.imageView.image = [UIImage imageNamed:iconStr];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return _headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _currentRow = indexPath.row;
    if (_currentRow == _forwardRow) {
        [_viewController leftItemClick:nil];
        return;
    }
    if ([KUserDefaults boolForKey:KModeOffline]) {
        if (!(_offLine | _jwzx | _szgd) && _currentRow >=2 && _currentRow <= 6) {
            HWYLoginOffLineViewController *offLine = [[HWYLoginOffLineViewController alloc] init];
            offLine.delegate = self;
            HWYNavigationController *nav = [[HWYNavigationController alloc] initWithRootViewController:offLine];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
            });
        } else {
            [self initRightView];
        }
    } else {
        if (!_jwzx && _currentRow >= 2 && _currentRow <= 4) {
            HWYLoginJwzxViewController *jwzx = [[HWYLoginJwzxViewController alloc] init];
            jwzx.delegate = self;
            jwzx.login = _offLine | _jwzx | _szgd;
            HWYNavigationController *nav = [[HWYNavigationController alloc] initWithRootViewController:jwzx];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
            });
        } else if (!_szgd && _currentRow >= 5 && _currentRow <= 6) {
            HWYLoginSzgdViewController *szgd = [[HWYLoginSzgdViewController alloc] init];
            szgd.delegate = self;
            szgd.login = _offLine | _jwzx | _szgd;
            HWYNavigationController *nav = [[HWYNavigationController alloc] initWithRootViewController:szgd];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
            });
        } else {
            [self initRightView];
        }
    }
}

- (void)initRightView {
    _forwardRow = _currentRow;
    [_tableView reloadData];
    if ([[self.view subviews] containsObject:_nav.view]) {
        [_nav.view removeFromSuperview];
        [_nav removeFromParentViewController];
    }
    switch (_currentRow) {
        case 0:
            _viewController = [HWYNewsListViewController new];
            break;
        case 1:
            _viewController = [HWYNoticeListViewController new];
            break;
        case 2:
            _viewController = [HWYInformationViewController new];
            break;
        case 3:
            _viewController = [HWYScheduleViewController new];
            break;
        case 4:
            _viewController = [HWYReportCardViewController new];
            break;
        case 5:
            _viewController = [HWYBookBorrowViewController new];
            break;
        case 6:
            _viewController = [HWYOneCardViewController new];
            break;
        case 7:
            _viewController = [HWYSetViewController new];
            [((HWYSetViewController *)_viewController) getLoginState:_offLine jwzx:_jwzx szgd:_szgd];;
            ((HWYSetViewController *)_viewController).delegateLogout = self;
            break;
        default:
            return;
            break;
    }
    _viewController.delegate = self;
    _nav = [[HWYNavigationController alloc] initWithRootViewController:_viewController];
    _nav.view.transform = CGAffineTransformMakeScale(0.8, 0.8);
    _nav.view.center = CGPointMake(P_WIDTH/2 + range, _nav.view.center.y);
    [self addChildViewController:_nav];
    [self.view addSubview:_nav.view];
    [_viewController leftItemClick:nil];
}

- (void)moveTransformView:(CGFloat)x {
    _tableView.transform = CGAffineTransformMakeScale(0.8 + x/(range/0.2), 0.8 + x/(range/0.2));
    _tableView.center = CGPointMake(P_WIDTH/2 - 100 + x/2.18, _tableView.center.y);
    _tableView.alpha = 0.5 + x/(range/0.5);
}

- (void)loginOffLineState:(BOOL)success {
    if (success) {
        _offLine = YES;
        [self loginState];
        if (_currentRow >= 2 && _currentRow <= 6) {
            [self initRightView];
        } else {
            _forwardRow = _currentRow;
        }
    }
}

- (void)loginJwzxState:(BOOL)success {
    if (success) {
        _jwzx = YES;
        [self loginState];
        if (_currentRow >= 2 && _currentRow <= 4) {
            [self initRightView];
        } else {
            _forwardRow = _currentRow;
        }
    }
}

- (void)loginSzgdState:(BOOL)success {
    if (success) {
        _szgd = YES;
        [self loginState];
        [self initRightView];
    }
}

- (void)loginBtnClick:(UIButton *)sender {
    if ([KUserDefaults boolForKey:KModeOffline]) {
        if (!(_offLine | _jwzx | _szgd)) {
            HWYLoginOffLineViewController *offLine = [[HWYLoginOffLineViewController alloc] init];
            offLine.delegate = self;
            HWYNavigationController *nav = [[HWYNavigationController alloc] initWithRootViewController:offLine];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:nav animated:YES completion:^{
                    
                }];
            });
        }
    } else if (!_jwzx) {
        HWYLoginJwzxViewController *jwzx = [[HWYLoginJwzxViewController alloc] init];
        jwzx.delegate = self;
        jwzx.login = _offLine | _jwzx | _szgd;
        HWYNavigationController *nav = [[HWYNavigationController alloc] initWithRootViewController:jwzx];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        });
    }
}

- (void)loginState {
    NSString *number = [KUserDefaults valueForKey:KDefaultNumber];
    NSData *imageData = [HWYInformationData getInfoImageData:number];
    if (imageData) {
        UIImage *newImage = [UIImage CircleImageWithName:nil andImageData:imageData borderWidth:0 borderColor:[UIColor whiteColor]];
        [_btnImage setImage:newImage];
    } else {
        NSString *string = [NSString stringWithFormat:JWZX_INFO_IMAGE_URL, number];
        NSURL *url = [NSURL URLWithString:string];
        [UIImage imageWithUrl:url success:^(NSData *data, UIImage *image) {
            [HWYInformationData saveInfoImageData:data number:number];
            UIImage *newImage = [UIImage CircleImageWithOldImage:image borderWidth:0 borderColor:[UIColor whiteColor]];
            [_btnImage setImage:newImage];
        } failure:^{
            [MBProgressHUD showError:@"获取头像失败" toView:self.view];
        }];
    }
    _btnLable.alpha = 1.0;
    _btnLable.text = number;
}

- (void)logoutState {
    _offLine = NO;
    _jwzx = NO;
    _szgd = NO;
    [_btnImage setImage:[UIImage imageNamed:@"bg_default_login"]];
    _btnLable.alpha = 0.5;
    _btnLable.text = @"登录";
}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"begin...");
//}
//
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"move...");
//}
//
//-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"end...");
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
