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
#import "HWYNewsNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "HWYAppDefine.h"

@interface HWYNoticeListViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSString *_identify;
    NSArray *_noticeListArr;
}

@property (strong, nonatomic) UITableView *tableView;

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

    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf refreshTableView];
    }];
    
}

- (void)initNoticeList {
    _noticeListArr = [HWYNoticeListData getNoticeListData];
    [_tableView reloadData];
    if ([_tableView.header isRefreshing]) {
        [_tableView.header endRefreshing];
    }
}

- (void)requestNetworking {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"通知列表-离线模式");
        [self didAfterDelay:^{
            [self initNoticeList];
            [hud hide:YES];
        }];
    } else {
        NSLog(@"通知列表-正常模式");
        [HWYNewsNetworking getNoticeListData:^(NSError *error) {
            [self initNoticeList];
            [hud hide:YES];
        }];
    }
}

- (void)refreshTableView {
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"通知列表-离线模式");
        [self didAfterDelay:^{
            [self initNoticeList];
        }];
    } else {
        NSLog(@"通知列表-正常模式");
        [HWYNewsNetworking getNoticeListData:^(NSError *error) {
            [self initNoticeList];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!KArrayEmpty(_noticeListArr)) {
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
    selectView.backgroundColor = KCellSelectedColor;
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
        cell.backgroundColor = KColor(251, 251, 251);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
