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
#import "HWYNewsNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "HWYAppDefine.h"

@interface HWYNoticeInfoViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSString *_plateid;
    NSString *_title;
    NSString *_identify;
    NSArray *_noticeInfoArr;
}
@property (strong,nonatomic) UINavigationBar *navBar;
@property (strong,nonatomic) UINavigationItem *navItem;
@property (strong, nonatomic) UITableView *tableView;
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
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf refreshTableView];
    }];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        [weakSelf refreshTableFooterView];
    }];
}


- (void)initNoticeInfo {
    _noticeInfoArr = [HWYNoticeInfoData getNoticeInfoData:_plateid];
    [_tableView reloadData];
    if ([_tableView.header isRefreshing]) {
        [_tableView.header endRefreshing];
    }
}

- (void)requestNetworking {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"通知信息-离线模式");
        [self didAfterDelay:^{
            [self initNoticeInfo];
            [hud hide:YES];
        }];
    } else {
        NSLog(@"通知信息-正常模式");
        [HWYNewsNetworking getNoticeInfoData:_plateid pageNo:1 compelet:^(NSError *error) {
            [self initNoticeInfo];
            [hud hide:YES];
        }];
    }
}

- (void)refreshTableView {
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"通知信息-离线模式");
        [self didAfterDelay:^{
            [self initNoticeInfo];
        }];
    } else {
        NSLog(@"通知信息-正常模式");
        [HWYNewsNetworking getNoticeInfoData:_plateid pageNo:1 compelet:^(NSError *error) {
            [self initNoticeInfo];
        }];
    }
}

- (void)refreshTableFooterView {
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"通知信息-离线模式");
        [self didAfterDelay:^{
            [self initNoticeInfo];
        }];
    } else {
        NSLog(@"通知信息-正常模式");
        NSInteger pageNo = _noticeInfoArr.count/20 + 1;
        [HWYNewsNetworking getNoticeInfoData:_plateid pageNo:pageNo compelet:^(NSError *error) {
            [self initNoticeInfo];
            [_tableView.footer endRefreshing];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _tableView.footer.hidden = !_noticeInfoArr.count;
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
        cell.backgroundColor = KColor(251, 251, 251);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
