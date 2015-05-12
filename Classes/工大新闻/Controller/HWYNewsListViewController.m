//
//  HWYWelcomeViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYNewsListViewController.h"
#import "HWYNewsInfoViewController.h"
#import "HWYNewsListData.h"
#import "HWYGeneralConfig.h"
#import "HWYNetworking.h"
#import "MBProgressHUD.h"
#import "HWYAppDelegate.h"

@interface HWYNewsListViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSString *_identify;
    NSArray *_headerArr;
    NSArray *_newsTypeArr;
    NSArray *_newsListArr;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation HWYNewsListViewController

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
    [self configTitleAndLeftItem:@"工大新闻"];
}

- (void)initView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _identify = @"newsListCell";
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

- (void)initNewsList {
    _headerArr = @[@"全部新闻", @"重要新闻", @"新闻类别"];
    _newsTypeArr = @[@"工大要闻", @"头版头条"];
    _newsListArr = [HWYNewsListData getNewsListData];
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
        NSLog(@"新闻列表-离线模式");
        [self performSelector:@selector(initNewsList) withObject:nil afterDelay:0.6];
        [hud hide:YES afterDelay:0.6];
    } else {
        if ([HWYAppDelegate isReachable]) {
            NSLog(@"新闻列表-正常模式");
            [HWYNetworking getNewsListData:^(NSError *error) {
                [self initNewsList];
                [hud hide:YES];
            }];
        } else {
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_error_black"]];
            hud.mode = MBProgressHUDModeCustomView;
            hud.labelText = @"当前网络不可用";
            [hud hide:YES afterDelay:0.6];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _headerArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return _newsTypeArr.count;
    } else {
        return _newsListArr.count;
    }
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
    if (indexPath.section == 0) {
        cell.textLabel.text = @"全部新闻";
    } else if (indexPath.section == 1) {
        cell.textLabel.text = _newsTypeArr[indexPath.row];
    } else {
        HWYNewsListData *newsList = _newsListArr[indexPath.row];
        cell.textLabel.text = newsList.PLATE_NAME;
    }
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = kColor(251, 251, 251);
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _headerArr[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    HWYNewsInfoViewController *newsInfo = [HWYNewsInfoViewController new];
    switch (indexPath.section) {
        case 0:
            [newsInfo initTitleWith:@"全部新闻" plateid:@"" type:0];
            break;
        case 1:
        {
            NSString *type = [NSString string];
            if (indexPath.row == 0) {
                type = @"imp";
            } else {
                type = @"head";
            }
            [newsInfo initTitleWith:_newsTypeArr[indexPath.row] plateid:type type:indexPath.row + 1];
        }
            break;
        case 2:
        {
            HWYNewsListData *newsList = _newsListArr[indexPath.row];
            [newsInfo initTitleWith:newsList.PLATE_NAME plateid:newsList.PLATE_ID type:0];
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:newsInfo animated:YES];
}

- (void)refreshNewsList {
    [self initNewsList];
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
        NSLog(@"新闻列表-离线模式");
        [self refreshNewsList];
    } else {
        if ([HWYAppDelegate isReachable]) {
            [HWYNetworking getNewsListData:^(NSError *error) {
                NSLog(@"新闻列表-正常模式");
                [self refreshNewsList];
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
