//
//  HWYSettingViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYSetViewController.h"
#import "HWYVersionViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "HWYAppDefine.h"
#import "MBProgressHUD.h"
#import "HWYNetworking.h"
#import "HWYAppDelegate.h"

@interface HWYSetViewController () <UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate> {
    NSString *_identifySwitch;
    NSString *_identifySet;
    NSArray *_setArr;
}

@property (strong, nonatomic) UITableView *tableView;
@property (assign ,nonatomic) BOOL offLine;
@property (assign ,nonatomic) BOOL jwzx;
@property (assign ,nonatomic) BOOL szgd;

@end

@implementation HWYSetViewController

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

- (void)getLoginState:(BOOL)offLine jwzx:(BOOL)jwzx szgd:(BOOL)szgd {
    _offLine = offLine;
    _jwzx = jwzx;
    _szgd = szgd;
}

- (void)initNavBar {
    [self configTitleAndLeftItem:@"设置"];
}

- (void)initView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, P_WIDTH, 60)];
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(12, 10, 295, 41);
    [logoutBtn setBackgroundImage:[UIImage imageNamed:@"bg_logout"] forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logoutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:logoutBtn];
    
    _setArr = @[@[@"离线模式", @"记住密码", @"自动识别验证码"], @[@"版本信息", @"意见反馈", @"评分"]];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    if (_offLine | _jwzx | _szgd) {
        _tableView.tableFooterView = footerView;
    }
    
    _identifySet = @"setCell";
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:_identifySet];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_setArr[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifySwitch];
    
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    UIView *selectView = [[UIView alloc] initWithFrame:cell.frame];
    selectView.backgroundColor = KCellSelectedColor;
    cell.selectedBackgroundView = selectView;
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.text = _setArr[indexPath.section][indexPath.row];
    
    switch (indexPath.section) {
        case 0:
        {
            UISwitch *swith = [[UISwitch alloc] init];
            BOOL on;
            switch (indexPath.row) {
                case 0:
                    on = [KUserDefaults boolForKey:KModeOffline];
                    break;
                case 1:
                    on = [KUserDefaults boolForKey:KModeRememb];
                    break;
                case 2:
                    on = [KUserDefaults boolForKey:KModeAutoIdentification];
                    break;
                default:
                    break;
            }
            swith.on = on;
            swith.tag = 1000 + indexPath.row;
            [swith addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:swith];
            cell.accessoryView = swith;
        }
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            cell.accessoryView = nil;
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    HWYVersionViewController *viewController = nil;
    switch (section) {
        case 0:
            return;
            break;
        case 1:
            switch (row) {
                case 0:
                    viewController = [HWYVersionViewController new];
                    break;
                case 1:
                    [self sendMail];
                    return;
                    break;
                default:
                    return;
                    break;
            }
            break;
        default:
            return;
            break;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)switchChanged:(UISwitch *)sender {
    BOOL on = sender.on;
    switch (sender.tag) {
        case 1000:
            [KUserDefaults setBool:on forKey:KModeOffline];
            break;
        case 1001:
            [KUserDefaults setBool:on forKey:KModeRememb];
            break;
        case 1002:
            [KUserDefaults setBool:on forKey:KModeAutoIdentification];
            break;
        default:
            break;
    }
    [KUserDefaults synchronize];
}

- (void)sendMail
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    if ([HWYAppDelegate isReachable]) {
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (!mailClass) {
            hud.labelText = @"当前系统版本不支持应用内发送邮件功能";
            [hud show:YES];
            [hud hide:YES afterDelay:0.5];
            return;
        }
        if (![mailClass canSendMail]) {
            hud.labelText = @"用户没有设置邮件账户";
            [hud show:YES];
            [hud hide:YES afterDelay:0.5];
            return;
        }
        [hud removeFromSuperview];
        [self displayMailPicker];
    } else {
        hud.labelText = @"当前网络不可用";
        [hud show:YES];
        [hud hide:YES afterDelay:0.5];
    }
}

//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    //设置主题
    [mailPicker setSubject: @"意见反馈"];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"yyydyhanwy@163.com"];
    [mailPicker setToRecipients: toRecipients];
    //添加抄送
    //    NSArray *ccRecipients = [NSArray arrayWithObjects:@"yyydyhanwy@163.com", nil];
    //    [mailPicker setCcRecipients:ccRecipients];
    //添加密送
    //    NSArray *bccRecipients = [NSArray arrayWithObjects:@"yyydyhanwy@163.com", nil];
    //    [mailPicker setBccRecipients:bccRecipients];
    
    //    NSString *emailBody = @"";
    //    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailPicker animated:YES completion:^{
        
    }];
}

#pragma mark - 实现 MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_success_black"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:^{
        switch (result) {
            case MFMailComposeResultCancelled:
                hud.labelText = @"已取消";
                break;
            case MFMailComposeResultSaved:
                hud.labelText = @"已保存";
                break;
            case MFMailComposeResultSent:
                hud.labelText = @"已发送";
                break;
            case MFMailComposeResultFailed:
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
                hud.labelText = @"保存或发送失败";
                break;
            default:
                [hud removeFromSuperview];
                return;
                break;
        }
        [hud show:YES];
        [hud hide:YES afterDelay:0.5];
    }];
}

- (void)logoutBtnClick:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self logout];
    }
}

- (void)logout {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"注销中";
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    [hud show:YES];
    if (_jwzx | _szgd) {
        if ([HWYAppDelegate isReachable]) {
            if (_jwzx && _szgd) {
                [HWYNetworking getLogoutJwzx:^(BOOL jwzx, NSError *error) {
                    [HWYNetworking getLogoutSzgd:^(BOOL szgd, NSError *error) {
                        hud.mode = MBProgressHUDModeCustomView;
                        if (jwzx && szgd) {
                            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_success_black"]];
                            hud.labelText = @"注销成功";
                            [hud hide:YES afterDelay:0.5];
                            
                            _tableView.tableFooterView = nil;
                            if ([self.delegateLogout respondsToSelector:@selector(logoutState)]) {
                                [self.delegateLogout logoutState];
                            }
                            [_tableView reloadData];
                        } else {
                            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
                            hud.labelText = @"注销失败";
                            [hud hide:YES afterDelay:0.5];
                        }
                    }];
                }];
            } else if (_jwzx) {
                [HWYNetworking getLogoutJwzx:^(BOOL jwzx, NSError *error) {
                    hud.mode = MBProgressHUDModeCustomView;
                    if (jwzx) {
                        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_success_black"]];
                        hud.labelText = @"注销成功";
                        [hud hide:YES afterDelay:0.5];
                        
                        _tableView.tableFooterView = nil;
                        if ([self.delegateLogout respondsToSelector:@selector(logoutState)]) {
                            [self.delegateLogout logoutState];
                        }
                        [_tableView reloadData];
                    } else {
                        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
                        hud.labelText = @"注销失败";
                        [hud hide:YES afterDelay:0.5];
                    }
                }];
            }  else if (_szgd)  {
                [HWYNetworking getLogoutSzgd:^(BOOL szgd, NSError *error) {
                    hud.mode = MBProgressHUDModeCustomView;
                    if (szgd) {
                        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_success_black"]];
                        hud.labelText = @"注销成功";
                        [hud hide:YES afterDelay:0.5];
                        
                        _tableView.tableFooterView = nil;
                        if ([self.delegateLogout respondsToSelector:@selector(logoutState)]) {
                            [self.delegateLogout logoutState];
                        }
                        [_tableView reloadData];
                    } else {
                        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
                        hud.labelText = @"注销失败";
                        [hud hide:YES afterDelay:0.5];
                    }
                }];
            }
        } else {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"当前网络不可用";
            [hud hide:YES afterDelay:0.5];
        }
    } else {
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_success_black"]];
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"注销成功";
        [hud hide:YES afterDelay:0.5];
        
        _tableView.tableFooterView = nil;
        if ([self.delegateLogout respondsToSelector:@selector(logoutState)]) {
            [self.delegateLogout logoutState];
        }
        [_tableView reloadData];
    }
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