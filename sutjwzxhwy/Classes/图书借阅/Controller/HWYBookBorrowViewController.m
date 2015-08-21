//
//  HWYBookBorrowViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYBookBorrowViewController.h"
#import "HWYBookBorrowTableViewCell.h"
#import "HWYBookBorrowData.h"
#import "HWYSzgdNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "HWYAppDefine.h"
#import "MJRefresh.h"

@interface HWYBookBorrowViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSString *_identify;
    NSArray *_bookBorrowArr;
}

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation HWYBookBorrowViewController

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
    [self configTitleAndLeftItem:@"图书借阅"];
}

- (void)initView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _identify = @"bookBorrowCell";
    [_tableView registerClass:[HWYBookBorrowTableViewCell class] forCellReuseIdentifier:_identify];
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf refreshTableView];
    }];
}

- (void)initBookBorrow {
    _bookBorrowArr = [HWYBookBorrowData getBookBorrowData];
    if (KArrayEmpty(_bookBorrowArr)) {
        [MBProgressHUD showInfo:@"无图书借阅信息" toView:self.view];
    }
    [_tableView reloadData];
    if ([_tableView.header isRefreshing]) {
        [_tableView.header endRefreshing];
    }
}

- (void)requestNetworking {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"图书借阅-离线模式");
        [self didAfterDelay:^{
            [self initBookBorrow];
            [hud hide:YES];
        }];
    } else {
        NSLog(@"图书借阅-正常模式");
        [HWYSzgdNetworking getBookBorrowData:^{
            [self initBookBorrow];
            [hud hide:YES];
        }];
    }
}

- (void)refreshTableView {
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"图书借阅-离线模式");
        [self didAfterDelay:^{
            [self initBookBorrow];
        }];
    } else {
        NSLog(@"图书借阅-正常模式");
        [HWYSzgdNetworking getBookBorrowData:^{
            [self initBookBorrow];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bookBorrowArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWYBookBorrowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
    if (cell) {
        cell = [[HWYBookBorrowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identify];
    }
    HWYBookBorrowData *bookBorrow = _bookBorrowArr[indexPath.row];
    [cell configBookBorrow:bookBorrow];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 27;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = KColor(251, 251, 251);
    headerView.layer.borderWidth = 0.5;
    headerView.layer.borderColor = [KColor(203, 214, 226) CGColor];
    
    UILabel *countTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 75, 21)];
    countTitle.font = [UIFont systemFontOfSize:15.0];
    countTitle.textAlignment = NSTextAlignmentRight;
    countTitle.text = @"借书数量:";
    [headerView addSubview:countTitle];
    UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(80, 3, 30, 21)];
    count.font = [UIFont systemFontOfSize:15.0];
    count.text = [NSString stringWithFormat:@"%lu", (unsigned long)_bookBorrowArr.count];
    [headerView addSubview:count];
    
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
