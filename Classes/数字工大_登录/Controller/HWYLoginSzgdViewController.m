//
//  HWYLoginSzgdViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYLoginSzgdViewController.h"
#import "HWYLoginSzgdData.h"
#import "HWYSzgdNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "HWYAppDefine.h"

@interface HWYLoginSzgdViewController () <UITextFieldDelegate> {
    HWYLoginSzgdData *_szgd;
}
@property (strong,nonatomic) UIView *contentView;
@property (strong,nonatomic) UITextField *nameField;
@property (strong,nonatomic) UITextField *passwordField;
@property (strong,nonatomic) UIButton *loginBtn;
@property (strong,nonatomic) UIBarButtonItem * previousItem;
@property (strong,nonatomic) UIBarButtonItem * nextItem;
@end

@implementation HWYLoginSzgdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
    [self getSzgdLt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    NSString *number = [KUserDefaults valueForKey:KDefaultNumber];
    if (KStringExist(number)) {
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
    if ([KUserDefaults boolForKey:KModeRememb]) {
        NSString *pwd = [HWYLoginSzgdData getLoginSzgdPassword:number];
        if (KStringExist(pwd)) {
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
    doneItem.tintColor = KBlueColor;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, P_WIDTH, 44)];
    toolBar.items = @[ _previousItem, _nextItem, spaceItem, doneItem];
    _nameField.inputAccessoryView = toolBar;
    _passwordField.inputAccessoryView = toolBar;
    
    _szgd = [[HWYLoginSzgdData alloc] init];
}

- (void)getSzgdLt {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    [HWYSzgdNetworking getLoginSzgdLt:^(NSString *lt) {
        [hud hide:YES];
        _szgd.lt = lt;
    }];
}

- (void)loginBtnClick:(UIButton *)sender {
    [self doneItemClick:nil];
    
    NSString *number = _nameField.text;
    NSString *password = _passwordField.text;
    
    if (!KStringExist(number)) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        return;
    } else if (!KStringExist(password)) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alter show];
        return;
    } else if (!KStringExist(_szgd.lt)) {
        MBProgressHUD *hud = [MBProgressHUD showMessage:@"登录中..." toView:self.view];
        [HWYSzgdNetworking getLoginSzgdLt:^(NSString *lt) {
            [hud hide:YES];
            _szgd.lt = lt;
            [self loginSzgd];
        }];
    }
    [self loginSzgd];
}

- (void)loginSzgd {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"登录中..." toView:self.view];
    [HWYSzgdNetworking getLoginSzgdData:_nameField.text password:_passwordField.text lt:_szgd.lt compelet:^(HWYLoginSzgdData *szgd) {
        _szgd = szgd;
        if (_szgd.success) {
            [HWYSzgdNetworking getLoginSzgdJump:_szgd.href success:^{
                [hud hide:YES];
                [MBProgressHUD showSuccess:@"登录成功" toView:self.view];
                if (![_nameField.text isEqualToString:[KUserDefaults valueForKey:KDefaultNumber]]) {
                    [KUserDefaults setObject:_nameField.text forKey:KDefaultNumber];
                    [KUserDefaults synchronize];
                }
                [HWYLoginSzgdData saveLoginSzgdData:_nameField.text password:_passwordField.text];
                [self didAfterDelay:^{
                    [self dismiss];
                }];
            } failure:^{
                [hud hide:YES];
                [MBProgressHUD showSuccess:@"用户名或密码的错误" toView:self.view];
            }];
        } else {
            [hud hide:YES];
            [MBProgressHUD showSuccess:@"用户名或密码的错误" toView:self.view];
        }
    }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(loginSzgdState:)]) {
            [self.delegate loginSzgdState:YES];
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
