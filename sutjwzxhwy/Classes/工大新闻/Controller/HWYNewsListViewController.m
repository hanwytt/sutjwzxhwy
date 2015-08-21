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
#import "HWYNewsNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"
#import "HWYAppDefine.h"

@interface HWYNewsListViewController () <UITableViewDataSource,UITableViewDelegate> {
    NSString *_identify;
    NSArray *_headerArr;
    NSArray *_newsTypeArr;
    NSArray *_newsListArr;
}

@property (strong, nonatomic) UITableView *tableView;

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
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf refreshTableView];
    }];
}

- (void)initNewsList {
    _headerArr = @[@"全部新闻", @"重要新闻", @"新闻类别"];
    _newsTypeArr = @[@"工大要闻", @"头版头条"];
    _newsListArr = [HWYNewsListData getNewsListData];
    [_tableView reloadData];
    if ([_tableView.header isRefreshing]) {
        [_tableView.header endRefreshing];
    }
}

- (void)requestNetworking {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"新闻列表-离线模式");
        [self didAfterDelay:^{
            [self initNewsList];
            [hud hide:YES];
        }];
    } else {
        NSLog(@"新闻列表-正常模式");
        [HWYNewsNetworking getNewsListData:^() {
            [self initNewsList];
            [hud hide:YES];
        }];
    }
}

- (void)refreshTableView {
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"新闻列表-离线模式");
        [self didAfterDelay:^{
            [self initNewsList];
        }];
    } else {
        NSLog(@"新闻列表-正常模式");
        [HWYNewsNetworking getNewsListData:^() {
            [self initNewsList];
        }];
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
    selectView.backgroundColor = KCellSelectedColor;
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
        cell.backgroundColor = KColor(251, 251, 251);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
