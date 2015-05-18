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
#import "MBProgressHUD.h"
#import "HWYAppDefine.h"
#import "HWYNetworking.h"
#import "HWYAppDelegate.h"

@interface HWYBookBorrowViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSString *_identify;
    NSArray *_bookBorrowArr;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
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
    [self addRefreshControl];
}

- (void)addRefreshControl {
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [_refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:_refreshControl];
}

- (void)initBookBorrow {
    _bookBorrowArr = [HWYBookBorrowData getBookBorrowData];
    if (KArrayEmpty(_bookBorrowArr)) {
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
        hud.labelFont = [UIFont systemFontOfSize:15.0];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"无图书借阅信息";
        hud.removeFromSuperViewOnHide = YES;
        [self.view addSubview:hud];
        [hud show:YES];
        [hud hide:YES afterDelay:0.5];
    } else {
        [_tableView reloadData];
    }
}

- (void)requestNetworking {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.labelFont = [UIFont systemFontOfSize:15.0];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中";
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    [hud show:YES];
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"图书借阅-离线模式");
        [self performSelector:@selector(initBookBorrow) withObject:nil afterDelay:0.5];
        [hud hide:YES afterDelay:0.5];
    } else {
        if ([HWYAppDelegate isReachable]) {
            [HWYNetworking getBookBorrowData:^(NSError *error) {
                NSLog(@"图书借阅-正常模式");
                [self initBookBorrow];
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
    if (!KArrayEmpty(_bookBorrowArr)) {
        return 27;
    }
    return 0;
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

- (void)refreshBookBorrow {
    [self initBookBorrow];
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
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"图书借阅-离线模式");
        [self refreshBookBorrow];
    } else {
        if ([HWYAppDelegate isReachable]) {
            [HWYNetworking getBookBorrowData:^(NSError *error) {
                NSLog(@"图书借阅-正常模式");
                [self refreshBookBorrow];
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
