//
//  HWYOneCardViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYOneCardViewController.h"
#import "HWYOneCardTableViewCell.h"
#import "HWYOneCardData.h"
#import "HWYSzgdNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "HWYAppDefine.h"
#import "MJRefresh.h"


@interface HWYOneCardViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSString *_identify;
    HWYOneCardBalanceData *_oneCardBalance;
    NSArray *_oneCardRecordArr;
}

@property (strong, nonatomic) UITableView *tableView;

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
    
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf refreshTableView];
    }];
}

- (void)initOneCard {
    _oneCardBalance = [HWYOneCardBalanceData getOneCardBalanceData];
    _oneCardRecordArr = [HWYOneCardRecordData getOneCardRecordData];
    if (KArrayEmpty(_oneCardRecordArr)) {
        [MBProgressHUD showInfo:@"无近三个月消费记录" toView:self.view];
    }
    [_tableView reloadData];
    if ([_tableView.header isRefreshing]) {
        [_tableView.header endRefreshing];
    }
}

- (void)requestNetworking {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"一卡通-离线模式");
        [self didAfterDelay:^{
            [self initOneCard];
            [hud hide:YES];
        }];
    } else {
        NSLog(@"一卡通-正常模式");
        [HWYSzgdNetworking getOneCardBalanceData:^{
            [HWYSzgdNetworking getOneCardRecordData:^{
                [self initOneCard];
                [hud hide:YES];
            }];
        }];
    }
}

- (void)refreshTableView {
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"一卡通-离线模式");
        [self didAfterDelay:^{
            [self initOneCard];
        }];
    } else {
        NSLog(@"一卡通-正常模式");
        [HWYSzgdNetworking getOneCardBalanceData:^{
            [HWYSzgdNetworking getOneCardRecordData:^{
                [self initOneCard];
            }];
        }];

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
        cell.backgroundColor = KColor(251, 251, 251);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = KColor(251, 251, 251);
    headerView.layer.borderWidth = 0.5;
    headerView.layer.borderColor = [KColor(203, 214, 226) CGColor];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
