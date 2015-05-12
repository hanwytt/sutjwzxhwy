//
//  HWYNoticeInfoViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/30.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNoticeInfoViewController.h"
#import "HWYNoticeInfoTableViewCell.h"
#import "HWYNoticeInfoDetailViewController.h"
#import "HWYNoticeInfoData.h"
#import "HWYGeneralConfig.h"
#import "HWYNetworking.h"
#import "HWYAppDelegate.h"
#import "MBProgressHUD.h"

@interface HWYNoticeInfoViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSString *_plateid;
    NSString *_title;
    NSString *_identify;
    NSArray *_noticeInfoArr;
}
@property (strong,nonatomic) UINavigationBar *navBar;
@property (strong,nonatomic) UINavigationItem *navItem;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation HWYNoticeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar:_title];
    [self initView];
    [self requestNetworking];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTitleWith:(NSString *)title plateid:(NSString *)plateid {
    _title = title;
    _plateid = plateid;
}

- (void)initNavBar:(NSString *)title {
    [self configTitleAndBackItem:title];
}

- (void)initView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _identify = @"noticeInfoCell";
    [_tableView registerClass:[HWYNoticeInfoTableViewCell class] forCellReuseIdentifier:_identify];
    [self.view addSubview:_tableView];
    [self addRefreshControl];
}

- (void)addRefreshControl {
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [_refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
}

- (void)initNoticeInfo {
    _noticeInfoArr = [HWYNoticeInfoData getNoticeInfoData:_plateid];
    [_tableView reloadData];
}

- (void)requestNetworking {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中";
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    [hud show:YES];
    if ([userDefaults boolForKey:_K_MODE_OFFLINE]) {
        NSLog(@"通知信息-离线模式");
        [self performSelector:@selector(initNoticeInfo) withObject:nil afterDelay:0.5];
        [hud hide:YES afterDelay:0.5];
    } else {
        if ([userDefaults boolForKey:_K_MODE_OFFLINE]) {
            [self performSelector:@selector(initNoticeInfo) withObject:nil afterDelay:0.5];
            [hud hide:YES afterDelay:0.5];
        } else {
            if ([HWYAppDelegate isReachable]) {
                [HWYNetworking getNoticeInfoData:_plateid compelet:^(NSError *error) {
                    NSLog(@"通知信息-正常模式");
                    [self initNoticeInfo];
                    [hud hide:YES];
                }];
            } else {
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
                hud.mode = MBProgressHUDModeCustomView;
                hud.labelText = @"当前网络不可用";
                [hud hide:YES afterDelay:0.5];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _noticeInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWYNoticeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
    if (cell) {
        cell = [[HWYNoticeInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identify];
    }
    HWYNoticeInfoData *noticeInfo = _noticeInfoArr[indexPath.row];
    [cell configNoticeInfo:noticeInfo];
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = kColor(251, 251, 251);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    HWYNoticeInfoDetailViewController *noticeInfoDetail = [HWYNoticeInfoDetailViewController new];
    HWYNoticeInfoData *noticeInfo = _noticeInfoArr[indexPath.row];
    noticeInfoDetail.resourceid = noticeInfo.RESOURCE_ID;
    [self.navigationController pushViewController:noticeInfoDetail animated:YES];
}

- (void)refreshNoticeInfo {
    [self initNoticeInfo];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新成功"];
    [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
}

- (void)refreshToFail {
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新失败"];
    [self performSelector:@selector(endRefreshing) withObject:nil afterDelay:0.3];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"当前网络不可用";
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:0.5];
}

- (void)refreshView:(UIRefreshControl *)sender {
    sender.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中..."];
    if ([userDefaults boolForKey:_K_MODE_OFFLINE]) {
        NSLog(@"通知信息-离线模式");
        [self refreshNoticeInfo];
    } else {
        if ([HWYAppDelegate isReachable]) {
            [HWYNetworking getNoticeInfoData:_plateid compelet:^(NSError *error) {
                NSLog(@"通知信息-正常模式");
                [self refreshNoticeInfo];
            }];
        } else {
            [self refreshToFail];
        }
    }
}

- (void)endRefreshing {
    [_refreshControl endRefreshing];
    [self performSelector:@selector(resetRefreshControl) withObject:nil afterDelay:0.3];
}

- (void)resetRefreshControl {
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
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
