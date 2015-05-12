//
//  HWYLoginJwzxViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYLoginJwzxViewController.h"
#import "HWYMainViewController.h"
#import "HWYLoginJwzxData.h"
#import "HWYGeneralConfig.h"
#import "HWYURLConfig.h"
#import "UIKit+AFNetworking.h"
#import "MBProgressHUD.h"
#import "HWYNetworking.h"
#import "HWYAppDelegate.h"
#import <TesseractOCR/TesseractOCR.h>

@interface HWYLoginJwzxViewController () <UITextFieldDelegate> {
    HWYLoginJwzxData *_jwzx;
}

@property (strong,nonatomic) UIView *contentView;
@property (strong,nonatomic) UITextField *nameField;
@property (strong,nonatomic) UITextField *passwordField;
@property (strong,nonatomic) UIButton *agnomenBtn;
@property (strong,nonatomic) UITextField *agnomenField;
@property (strong,nonatomic) UIButton *loginBtn;
@property (strong,nonatomic) UIBarButtonItem * previousItem;
@property (strong,nonatomic) UIBarButtonItem * nextItem;

@end

@implementation HWYLoginJwzxViewController

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initNavBar {
    [self configTitle:@"教务在线"];
}

- (void)initView {
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64)];
    [self.view addSubview:_contentView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, P_WIDTH, 75)];
    imageView.image = [UIImage imageNamed:@"bg_jwzx"];
    [_contentView addSubview:imageView];
    
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 85, 300, 45)];
    UIImageView *nameImageView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_login_name"]];
    _nameField.leftView=nameImageView;
    _nameField.leftViewMode = UITextFieldViewModeAlways;
    _nameField.font = [UIFont systemFontOfSize:14.0];
    _nameField.background = [UIImage imageNamed:@"bg_input_up"];
    _nameField.placeholder = @"请输入账号";
    _nameField.borderStyle = UITextBorderStyleNone;
    _nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
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
    _passwordField.font = [UIFont systemFontOfSize:14.0];
    _passwordField.background = [UIImage imageNamed:@"bg_input_middle"];
    _passwordField.placeholder = @"请输入密码";
    _passwordField.borderStyle = UITextBorderStyleNone;
    _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordField.secureTextEntry = YES;
    if ([userDefaults boolForKey:_K_MODE_REMEMb]) {
        NSString *pwd = [HWYLoginJwzxData getLoginJwzxPassword:number];
        if (kStringExist(pwd)) {
            _passwordField.text = pwd;
        }
    }
    _passwordField.returnKeyType = UIReturnKeyDone;
    [_passwordField addTarget:self action:@selector(textFiledReturnEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _passwordField.delegate = self;
    [_contentView addSubview:_passwordField];
    
    UIView *agnomenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 45)];
    _agnomenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _agnomenBtn.frame = CGRectMake(10, 12, 50, 21);
    [_agnomenBtn setBackgroundImage:[UIImage imageNamed:@"icon_login_agnomen"] forState:UIControlStateNormal];
    [_agnomenBtn addTarget:self action:@selector(agnomenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [agnomenView addSubview:_agnomenBtn];
    
    _agnomenField = [[UITextField alloc] initWithFrame:CGRectMake(10, 175, 300, 45)];
    _agnomenField.leftView=agnomenView;
    _agnomenField.leftViewMode = UITextFieldViewModeAlways;
    _agnomenField.font = [UIFont systemFontOfSize:14.0];
    _agnomenField.background = [UIImage imageNamed:@"bg_input_down"];
    _agnomenField.placeholder = @"请输入验证码";
    _agnomenField.borderStyle = UITextBorderStyleNone;
    _agnomenField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _agnomenField.keyboardType = UIKeyboardTypeNumberPad;
    _agnomenField.returnKeyType = UIReturnKeyDone;
    [_agnomenField addTarget:self action:@selector(textFiledReturnEditing:) forControlEvents:UIControlEventEditingDidEndOnExit];
    _agnomenField.delegate = self;
    [_contentView addSubview:_agnomenField];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(10, 230, 305, 46);
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
    _agnomenField.inputAccessoryView = toolBar;
    
    [self agnomenBtnClick:nil];
}

- (void)agnomenBtnClick:(UIButton *)sender {
//    [JWZX_LOGIN_AGNOMENT_URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    UIApplication *application = [UIApplication sharedApplication];
//    application.networkActivityIndicatorVisible = YES;
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    if ([HWYAppDelegate isReachable]) {
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = @"加载中";
        [hud show:YES];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *url=[NSURL URLWithString:JWZX_LOGIN_AGNOMENT_URL];
            NSData * data = [[NSData alloc]initWithContentsOfURL:url];
            UIImage *image = [[UIImage alloc]initWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data != nil) {
                    [_agnomenBtn setBackgroundImage:image forState:UIControlStateNormal];
                    if ([userDefaults boolForKey:_K_MODE_AUTOIDENTIFICATION]) {
                        hud.labelText = @"自动识别中";
                        [hud hide:YES afterDelay:0.5];
                        Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"ita"];
                        [tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
                        [tesseract setImage:image]; //image to check
                        [tesseract recognize];
                        NSString *recognizedText = [tesseract recognizedText];
                        tesseract = nil; //deallocate and free all memory
                        recognizedText = [recognizedText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                        _agnomenField.text = recognizedText;
                    }
                    [hud hide:YES];
                } else {
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
                    hud.mode = MBProgressHUDModeCustomView;
                    hud.labelText = @"获取验证码失败";
                    [hud hide:YES afterDelay:0.5];
                }
            });
        });
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"当前网络不可用";
        [hud show:YES];
        [hud hide:YES afterDelay:0.5];
    }
    //    NSURL *url = [NSURL URLWithString:JWZX_LOGIN_AGNOMENT_URL];
//    NSURLRequest *requst = [NSURLRequest requestWithURL:url];
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//    hud.labelFont = [UIFont systemFontOfSize:15.0];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    hud.labelText = @"加载中";
//    hud.removeFromSuperViewOnHide = YES;
//    [self.view addSubview:hud];
//    [hud show:YES];
//    __block UIButton *agnomenBtn = _agnomenBtn;
//    __block UITextField *agnomenField = _agnomenField;
//    [_agnomenBtn setBackgroundImageForState:UIControlStateNormal withURLRequest:requst placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
//        [agnomenBtn setBackgroundImage:image forState:UIControlStateNormal];
//        if ([userDefaults boolForKey:_K_MODE_AUTOIDENTIFICATION]) {
//             hud.labelText = @"自动识别中";
//            Tesseract* tesseract = [[Tesseract alloc] initWithLanguage:@"eng+ita"];
//            [tesseract setVariableValue:@"0123456789" forKey:@"tessedit_char_whitelist"]; //limit search
//            [tesseract setImage:image]; //image to check
//            [tesseract recognize];
//            NSString *recognizedText = [tesseract recognizedText];
//            tesseract = nil; //deallocate and free all memory
//            agnomenField.text = recognizedText;
//        }
//        [hud hide:YES];
//    } failure:^(NSError *error) {
//        hud.labelText = @"获取验证码失败";
//        [hud hide:YES afterDelay:0.5];
//    }];
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
        [HWYNetworking getLoginJwzxData:_nameField.text password:_passwordField.text agnomen:_agnomenField.text compelet:^(BOOL success, HWYLoginJwzxData *jwzx, NSError *error) {
            _jwzx = jwzx;
            hud.mode = MBProgressHUDModeCustomView;
            if (success) {
                if (_jwzx.success) {
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_success_black"]];
                    hud.labelText = @"登录成功";
                    [self performSelector:@selector(dismiss) withObject:nil afterDelay:0.5];
                    [hud hide:YES afterDelay:0.5];
                    if (![_nameField.text isEqualToString:[userDefaults valueForKey:_K_DEFAULT_NUMBER]]) {
                        [userDefaults setObject:_nameField.text forKey:_K_DEFAULT_NUMBER];
                        [userDefaults synchronize];
                    }
                    [HWYLoginJwzxData saveLoginJwzxData:_nameField.text password:_passwordField.text];
                } else {
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
                    hud.labelText = _jwzx.content;
                    [hud hide:YES afterDelay:0.5];
                }
            } else {
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
                hud.labelText = @"登录失败";
            }
        }];
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"当前网络不可用";
        [hud show:YES];
        [hud hide:YES afterDelay:0.5];
    }
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(loginJwzxState:number:)]) {
            [self.delegate loginJwzxState:YES number:_nameField.text];
        }
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == _nameField) {
        _previousItem.enabled = NO;
        _nextItem.enabled = YES;
        _previousItem.image = [UIImage imageNamed:@"icon_forward_disabled"];
        _nextItem.image = [UIImage imageNamed:@"icon_next_normal"];
    } else if (textField == _passwordField) {
        if (_login) {
            _previousItem.enabled = NO;
            _previousItem.image = [UIImage imageNamed:@"icon_forward_disabled"];
        } else {
            _previousItem.enabled = YES;
            _previousItem.image = [UIImage imageNamed:@"icon_forward_normal"];
        }
        _nextItem.enabled = YES;
        _nextItem.image = [UIImage imageNamed:@"icon_next_normal"];
    } else {
        _previousItem.enabled = YES;
        _previousItem.image = [UIImage imageNamed:@"icon_forward_normal"];
        _nextItem.enabled = NO;
        _nextItem.image = [UIImage imageNamed:@"icon_next_disabled"];
    }
}

- (void)previousItemClick:(UIButton *)sender {
    if ([_passwordField isFirstResponder]) {
        [_nameField becomeFirstResponder];
    } else {
        [_passwordField becomeFirstResponder];
    }
}

- (void)nextItemClick:(UIButton *)sender {
    if ([_nameField isFirstResponder]) {
        [_passwordField becomeFirstResponder];
    } else {
        [_agnomenField becomeFirstResponder];
    }
}

- (void)doneItemClick:(UIButton *)sender {
    [_nameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_agnomenField resignFirstResponder];
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
