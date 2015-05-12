//
//  HWYSutNoticeViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/26.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNoticeListViewController.h"
#import "HWYNoticeInfoViewController.h"
#import "HWYNoticeListData.h"
#import "HWYGeneralConfig.h"
#import "HWYNetworking.h"
#import "MBProgressHUD.h"
#import "HWYAppDelegate.h"

@interface HWYNoticeListViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSString *_identify;
    NSArray *_noticeListArr;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation HWYNoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBar];
    [self initView];
    [self requestNetworking];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavBar {
    [self configTitleAndLeftItem:@"公告通知"];
}

- (void)initView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _identify = @"noticeListCell";
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:_identify];
    [self.view addSubview:_tableView];
    [self addRefreshControl];
}

- (void)addRefreshControl {
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [_refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
}

- (void)initNoticeList {
    _noticeListArr = [HWYNoticeListData getNoticeListData];
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
        NSLog(@"通知列表-离线模式");
        [self performSelector:@selector(initNoticeList) withObject:nil afterDelay:0.5];
        [hud hide:YES afterDelay:0.5];
    } else {
        if ([HWYAppDelegate isReachable]) {
            [HWYNetworking getNoticeListData:^(NSError *error) {
                NSLog(@"通知列表-正常模式");
                [self initNoticeList];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!kArrayEmpty(_noticeListArr)) {
        return _noticeListArr.count + 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
    if (cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identify];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    UIView *selectView = [[UIView alloc] initWithFrame:cell.frame];
    selectView.backgroundColor = _K_CELL_SELECTED_COLOR;
    cell.selectedBackgroundView = selectView;
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"全部通知";
    } else {
        HWYNoticeListData *noticeList = _noticeListArr[indexPath.row-1];
        cell.textLabel.text = noticeList.NAME;
    }
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = kColor(251, 251, 251);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    HWYNoticeInfoViewController *noticeInfo = [HWYNoticeInfoViewController new];
    if (indexPath.row == 0) {
        [noticeInfo initTitleWith:@"全部通知" plateid:@""];
    } else {
        HWYNoticeListData *noticeList = _noticeListArr[indexPath.row - 1];
        [noticeInfo initTitleWith:noticeList.NAME plateid:noticeList.PLATE_ID];
    }
    [self.navigationController pushViewController:noticeInfo animated:YES];
}

- (void)refreshNoticeList {
    [self initNoticeList];
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
        NSLog(@"通知列表-离线模式");
        [self refreshNoticeList];
        
    } else {
        if ([HWYAppDelegate isReachable]) {
            [HWYNetworking getNoticeListData:^(NSError *error) {
                NSLog(@"通知列表-正常模式");
                [self refreshNoticeList];
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
