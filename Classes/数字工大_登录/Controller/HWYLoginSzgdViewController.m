//
//  HWYLoginSzgdViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYLoginSzgdViewController.h"
#import "HWYLoginSzgdData.h"
#import "HWYAppDelegate.h"
#import "HWYGeneralConfig.h"
#import "HWYNetworking.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface HWYLoginSzgdViewController () <UITextFieldDelegate> {
    BOOL _success;
    HWYLoginSzgdData *_szgd;
}
@property (strong,nonatomic) UIView *contentView;
@property (strong,nonatomic) UITextField *nameField;
@property (strong,nonatomic) UITextField *passwordField;
@property (strong,nonatomic) UIButton *loginBtn;
@property (nonatomic) Reachability *reachable;
@property (strong,nonatomic) UIBarButtonItem * previousItem;
@property (strong,nonatomic) UIBarButtonItem * nextItem;
@end

@implementation HWYLoginSzgdViewController

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachableChanged:) name:kReachabilityChangedNotification object:nil];
    _reachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [_reachable startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initNavBar {
    [self configTitle:@"数字工大"];
}

- (void)initView {
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64)];
    [self.view addSubview:_contentView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, P_WIDTH, 75)];
    imageView.image = [UIImage imageNamed:@"bg_szgd"];
    [_contentView addSubview:imageView];
    
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 85, 300, 45)];
    UIImageView *nameImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_name"]];
    _nameField.leftView=nameImageView;
    _nameField.leftViewMode = UITextFieldViewModeAlways;
    _nameField.font = [UIFont systemFontOfSize:14.0];
    _nameField.background = [UIImage imageNamed:@"bg_input_up"];
    _nameField.placeholder = @"请输入账号";
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameField.borderStyle = UITextBorderStyleNone;
    NSString *number = [userDefaults valueForKey:_K_DEFAULT_NUMBER];
    if (kStringExist(number)) {
        _nameField.text = number;
        if (_login) {
            _nameField.enabled = NO;
        }
    }
    _nameField.keyboardType = UIKeyboardTypeNumberPad;
    _nameField.returnKeyType = UIReturnKeyDone;
    [_nameField addTarget:self action:@selector(textFiledReturnEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _nameField.delegate = self;
    [_contentView addSubview:_nameField];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 130, 300, 45)];
    UIImageView *passwordImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_password"]];
    _passwordField.leftView=passwordImageView;
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.background = [UIImage imageNamed:@"bg_input_down"];
    _passwordField.font = [UIFont systemFontOfSize:14.0];
    _passwordField.placeholder = @"请输入密码";
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.borderStyle = UITextBorderStyleNone;
    _passwordField.secureTextEntry = YES;
    if ([userDefaults boolForKey:_K_MODE_REMEMb]) {
        NSString *pwd = [HWYLoginSzgdData getLoginSzgdPassword:number];
        if (kStringExist(pwd)) {
            _passwordField.text = pwd;
        }
    }
    _passwordField.returnKeyType = UIReturnKeyDone;
    [_passwordField addTarget:self action:@selector(textFiledReturnEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _passwordField.delegate = self;
    [_contentView addSubview:_passwordField];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(7, 185, 305, 46);
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_btn_normal"] forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_btn_pressed"] forState:UIControlStateHighlighted];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = 5;
    _loginBtn.layer.masksToBounds = YES;
    [_loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_loginBtn];
    
    _previousItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_forward_disabled"] style:UIBarButtonItemStylePlain target:self action:@selector(previousItemClick:)];
    _nextItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_next_disabled"] style:UIBarButtonItemStylePlain target:self action:@selector(nextItemClick:)];
    UIBarButtonItem *spaceItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneItemClick:)];
    doneItem.tintColor = _K_BLUE_COLOR;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, P_WIDTH, 44)];
    toolBar.items = @[ _previousItem, _nextItem, spaceItem, doneItem];
    _nameField.inputAccessoryView = toolBar;
    _passwordField.inputAccessoryView = toolBar;
    
    _szgd = [[HWYLoginSzgdData alloc] init];
}

//- (void)requestNetworking {
//    _szgd = [[HWYLoginSzgdData alloc] init];
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//    hud.labelFont = [UIFont systemFontOfSize:15.0];
//    hud.removeFromSuperViewOnHide = YES;
//    [self.view addSubview:hud];
//    if ([HWYAppDelegate isReachable]) {
//        hud.mode = MBProgressHUDModeIndeterminate;
//        hud.labelText = @"加载中";
//        [hud show:YES];
//        [HWYNetworking getLoginSzgdLt:^(NSString *lt, NSError *error) {
//            _szgd.lt = lt;
//            [hud hide:YES];
//        }];
//    } else {
//        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
//        hud.mode = MBProgressHUDModeCustomView;
//        hud.labelText = @"当前网络不可用";
//        [hud show:YES];
//        [hud hide:YES afterDelay:0.5];
//    }
//}

- (void)reachableChanged:(NSNotification*)note {
    Reachability *curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    switch (status) {
        case NotReachable:
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"当前网络不可用";
            [hud show:YES];
            [hud hide:YES afterDelay:0.5];
            break;
        case ReachableViaWWAN:
        case ReachableViaWiFi:
        {
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.labelText = @"加载中";
            [hud show:YES];
            [HWYNetworking getLoginSzgdLt:^(BOOL success, NSString *lt, NSError *error) {
                _szgd.lt = lt;
                _success = success;
                if (_success) {
                    [hud hide:YES];
                } else {
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
                    hud.labelText = @"加载失败";
                    [hud hide:YES afterDelay:0.5];
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)loginBtnClick:(UIButton *)sender {
    [self doneItemClick:nil];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    if ([HWYAppDelegate isReachable]) {
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"登录中";
        [hud show:YES];
        if (_success) {
            [hud hide:YES];
            [self loginSzgd];
        } else {
            [HWYNetworking getLoginSzgdLt:^(BOOL success, NSString *lt, NSError *error) {
                _szgd.lt = lt;
                _success = success;
                if (_success) {
                    [hud hide:YES];
                    [self loginSzgd];
                } else {
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
                    hud.labelText = @"登录失败";
                    [hud hide:YES afterDelay:0.5];
                }
            }];
        }
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"当前网络不可用";
        [hud show:YES];
        [hud hide:YES afterDelay:0.5];
    }
}

- (void)loginSzgd {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"登录中";
    [hud show:YES];
    [HWYNetworking getLoginSzgdData:_nameField.text password:_passwordField.text lt:_szgd.lt compelet:^(BOOL success, HWYLoginSzgdData *szgd, NSError *error) {
        _success = success;
        _szgd = szgd;
        if (_success) {
            if (_szgd.success) {
                [HWYNetworking getLoginSzgdJump:_szgd.href compelet:^(BOOL success, NSError *error) {
                    _success = success;
                    if (_success) {
                        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_success_black"]];
                        hud.mode = MBProgressHUDModeCustomView;
                        hud.labelText = @"登录成功";
                        [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
                        [hud hide:YES afterDelay:0.5];
                        if (![_nameField.text isEqualToString:[userDefaults valueForKey:_K_DEFAULT_NUMBER]]) {
                            [userDefaults setObject:_nameField.text forKey:_K_DEFAULT_NUMBER];
                            [userDefaults synchronize];
                        }
                        [HWYLoginSzgdData saveLoginSzgdData:_nameField.text password:_passwordField.text];
                    } else {
                        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
                        hud.mode = MBProgressHUDModeCustomView;
                        hud.labelText = @"登录失败";
                        [hud hide:YES afterDelay:0.5];
                    }
                }];
            } else if (_szgd.lt == nil) {
                _success = NO;
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"登录失败";
                [hud hide:YES afterDelay:0.5];
            } else {
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"错误的用户名或密码";
                [hud hide:YES afterDelay:0.5];
            }
        } else {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"登录失败";
            [hud hide:YES afterDelay:0.5];
        }
    }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(loginSzgdState:number:)]) {
            [self.delegate loginSzgdState:YES number:_nameField.text];
        }
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _nameField) {
        _previousItem.enabled = NO;
        _nextItem.enabled = YES;
        _previousItem.image = [UIImage imageNamed:@"icon_forward_disabled"];
        _nextItem.image = [UIImage imageNamed:@"icon_next_normal"];
    } else {
        if (_login) {
            _previousItem.enabled = NO;
            _previousItem.image = [UIImage imageNamed:@"icon_forward_disabled"];
        } else {
            _previousItem.enabled = YES;
            _previousItem.image = [UIImage imageNamed:@"icon_forward_normal"];
        }
        _nextItem.enabled = NO;
        _nextItem.image = [UIImage imageNamed:@"icon_next_disabled"];
    }
}

- (void)previousItemClick:(UIButton *)sender {
    [_nameField becomeFirstResponder];
}

- (void)nextItemClick:(UIButton *)sender {
    [_passwordField becomeFirstResponder];
}

- (void)doneItemClick:(UIButton *)sender {
    [_nameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

- (void)textFiledReturnEditing:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        _contentView.frame = CGRectMake(0, 0, _contentView.frame.size.width, _contentView.frame.size.height);
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    [UIView animateWithDuration:0.25 animations:^{
        _contentView.frame = CGRectMake(0, 64, _contentView.frame.size.width, _contentView.frame.size.height);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [_reachable stopNotifier];
    [[NSNotificationCenter defaultCenter] removeObserver:nil];
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
