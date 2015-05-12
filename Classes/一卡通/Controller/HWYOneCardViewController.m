//
//  HWYOneCardViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYOneCardViewController.h"
#import "HWYOneCardTableViewCell.h"
#import "HWYGeneralConfig.h"
#import "HWYOneCardData.h"
#import "HWYNetworking.h"
#import "MBProgressHUD.h"
#import "HWYAppDelegate.h"


@interface HWYOneCardViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSString *_identify;
    HWYOneCardBalanceData *_oneCardBalance;
    NSArray *_oneCardRecordArr;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation HWYOneCardViewController

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
    [self configTitleAndLeftItem:@"一卡通"];
    
}

- (void)initView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 48;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _identify = @"OneCardCell";
    [_tableView registerClass:[HWYOneCardTableViewCell class] forCellReuseIdentifier:_identify];
    [self.view addSubview:_tableView];
    [self addRefreshControl];
}

- (void)addRefreshControl {
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [_refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
}

- (void)initOneCard {
    _oneCardBalance = [HWYOneCardBalanceData getOneCardBalanceData];
    _oneCardRecordArr = [HWYOneCardRecordData getOneCardRecordData];
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
        NSLog(@"一卡通-离线模式");
        [self performSelector:@selector(initOneCard) withObject:nil afterDelay:0.5];
        [hud hide:YES afterDelay:0.5];
    } else {
        if ([HWYAppDelegate isReachable]) {
            [HWYNetworking getOneCardBalanceData:^(NSError *error) {
                NSLog(@"一卡通-正常模式");
                [HWYNetworking getOneCardRecordData:^(NSError *error) {
                    [self initOneCard];
                    [hud hide:YES];
                }];
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
    return _oneCardRecordArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWYOneCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
    if (cell) {
        cell = [[HWYOneCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identify];
    }
    HWYOneCardRecordData *oneCardRecord = _oneCardRecordArr[indexPath.row];
    [cell configOneCardRecord:oneCardRecord];
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = kColor(251, 251, 251);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (!kArrayEmpty(_oneCardRecordArr)) {
        return 48;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kColor(251, 251, 251);
    headerView.layer.borderWidth = 0.5;
    headerView.layer.borderColor = [kColor(203, 214, 226) CGColor];
    
    UILabel *XHTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 75, 21)];
    XHTitle.font = [UIFont systemFontOfSize:15.0];
    XHTitle.textAlignment = NSTextAlignmentRight;
    XHTitle.text = @"学       号:";
    [headerView addSubview:XHTitle];
    UILabel *XH = [[UILabel alloc] initWithFrame:CGRectMake(80, 3, 100, 21)];
    XH.font = [UIFont systemFontOfSize:15.0];
    XH.text = _oneCardBalance.XH;
    [headerView addSubview:XH];

    UILabel *YKTTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 75, 21)];
    YKTTitle.font = [UIFont systemFontOfSize:15.0];
    YKTTitle.textAlignment = NSTextAlignmentRight;
    YKTTitle.text = @"一卡通号:";
    [headerView addSubview:YKTTitle];
    UILabel *YKT = [[UILabel alloc] initWithFrame:CGRectMake(80, 24, 100, 21)];
    YKT.font = [UIFont systemFontOfSize:15.0];
    YKT.text = _oneCardBalance.YKT;
    [headerView addSubview:YKT];
    
    UILabel *YETitle = [[UILabel alloc] initWithFrame:CGRectMake(185, 13, 75, 21)];
    YETitle.font = [UIFont systemFontOfSize:15.0];
    YETitle.textAlignment = NSTextAlignmentRight;
    YETitle.text = @"余额:";
    [headerView addSubview:YETitle];
    UILabel *YE = [[UILabel alloc] initWithFrame:CGRectMake(260, 13, 55, 21)];
    YE.font = [UIFont systemFontOfSize:17.0];
    YE.textAlignment = NSTextAlignmentCenter;
    YE.text = _oneCardBalance.YE;
    [headerView addSubview:YE];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void)refreshOneCard {
    [self initOneCard];
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
        NSLog(@"一卡通-离线模式");
        [self refreshOneCard];
    } else {
        if ([HWYAppDelegate isReachable]) {
            [HWYNetworking getOneCardBalanceData:^(NSError *error) {
                NSLog(@"一卡通-正常模式");
                [HWYNetworking getOneCardRecordData:^(NSError *error) {
                    [self refreshOneCard];
                }];
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
