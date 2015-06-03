//
//  HWYSutNewsViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/28.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNewsInfoViewController.h"
#import "HWYNewsInfoTableViewCell.h"
#import "HWYNewsInfoDetailViewController.h"
#import "HWYNewsNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "HWYAppDefine.h"

@interface HWYNewsInfoViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSString *_identify;
    NSArray *_newsInfoArr;
    BOOL _type;
    NSString *_plateid;
    NSString *_title;
}
@property (strong,nonatomic) UINavigationBar *navBar;
@property (strong,nonatomic) UINavigationItem *navItem;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation HWYNewsInfoViewController

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

- (void)initNavBar:(NSString *)title {
    [self configTitleAndBackItem:title];
}

- (void)initTitleWith:(NSString *)title plateid:(NSString *)plateid type:(NSInteger)type {
    _title = title;
    _plateid = plateid;
    _type = type;
}

- (void)initView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _identify = @"newsInfoCell";
    [_tableView registerClass:[HWYNewsInfoTableViewCell class] forCellReuseIdentifier:_identify];
    [self.view addSubview:_tableView];

    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf refreshTableView];
    }];
}

- (void)initNewsInfo {
    _newsInfoArr = [HWYNewsInfoData getNewsInfoData:_plateid type:_type];
    [_tableView reloadData];
    if ([_tableView.header isRefreshing]) {
        [_tableView.header endRefreshing];
    }
}

- (void)requestNetworking {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"新闻信息-离线模式");
        [self didAfterDelay:^{
            [self initNewsInfo];
            [hud hide:YES];
        }];
    } else {
        NSLog(@"新闻信息-正常模式");
        [HWYNewsNetworking getNewsInfoData:_plateid type:_type compelet:^(NSError *error) {
            [self initNewsInfo];
            [hud hide:YES];
        }];
    }
}

- (void)refreshTableView {
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"新闻信息-离线模式");
        [self didAfterDelay:^{
            [self initNewsInfo];
        }];
    } else {
        NSLog(@"新闻信息-正常模式");
        [HWYNewsNetworking getNewsInfoData:_plateid type:_type compelet:^(NSError *error) {
            [self initNewsInfo];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWYNewsInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
    if (cell) {
        cell = [[HWYNewsInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identify];
    }
    HWYNewsInfoData *newsInfo = _newsInfoArr[indexPath.row];
    [cell configNewsInfo:newsInfo];
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
    HWYNewsInfoDetailViewController *newsInfoDetail = [HWYNewsInfoDetailViewController new];
    HWYNewsInfoData *newsInfo = _newsInfoArr[indexPath.row];
    newsInfoDetail.resourceid = newsInfo.RESOURCE_ID;
    [self.navigationController pushViewController:newsInfoDetail animated:YES];
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
