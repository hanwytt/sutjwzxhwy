//
//  HWYReportCardsViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYReportCardViewController.h"
#import "HWYReportCardTableViewCell.h"
#import "HWYReportCardWebViewController.h"
#import "HWYReportCardData.h"
#import "HWYNetworking.h"
#import "HWYAppDefine.h"
#import "HWYAppDelegate.h"
#import "MBProgressHUD+MJ.h"
#import "MJRefresh.h"

@interface HWYReportCardViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate> {
    NSString *_identify;
    HWYReportCountData *_reportCount;
    NSArray *_reportCardArr;
    NSArray *_searchArr;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UISearchDisplayController *searchDisplay;

@end

@implementation HWYReportCardViewController

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

#pragma mark - 初始化navigationBar
- (void)initNavBar {
    [self configTitleAndLeftItem:@"成绩表"];
    if (![KUserDefaults boolForKey:KModeOffline]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"网页版" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
        rightItem.tintColor = [UIColor whiteColor];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
}

#pragma mark - 初始化view
- (void)initView {
    //初始化tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 48;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _identify = @"rseportCardCell";
    [_tableView registerClass:[HWYReportCardTableViewCell class] forCellReuseIdentifier:_identify];
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf refreshTableView];
    }];
    // 马上进入刷新状态
//    [self.tableView.legendHeader beginRefreshing];

    _searchBar = [[UISearchBar alloc] init];
    _searchBar.placeholder = @"搜索";
    [_searchBar setBackgroundImage:[UIImage imageNamed:@"bg_tabbar"] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    _searchBar.delegate = self;
    [_searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [_searchBar sizeToFit];
    _tableView.tableHeaderView = _searchBar;
    
    _searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplay.searchResultsDelegate= self;
    _searchDisplay.searchResultsDataSource = self;
    _searchDisplay.delegate = self;
}

#pragma mark - 从本地数据库加载数据
- (void)initReportCard {
    _reportCount = [HWYReportCountData getReportCountData];
    _reportCardArr = [HWYReportCardData getReportCardData];
    [_tableView reloadData];
    [self.tableView.header endRefreshing];
}

#pragma mark - 获取数据
- (void)requestNetworking {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"成绩表-离线模式");
        [hud hideHUDDefaultDelay:^{
            [self initReportCard];
        }];
    } else {
        NSLog(@"成绩表-正常模式");
        [HWYNetworking getReportCardData:^(NSError *error) {
            [self initReportCard];
            [hud hide:YES];
        }];
    }
}

- (void)refreshTableView {
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"成绩表-离线模式");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self initReportCard];
        });
    } else {
        NSLog(@"成绩表-正常模式");
        [HWYNetworking getReportCardData:^(NSError *error) {
            [self initReportCard];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_tableView == tableView) {
        return _reportCardArr.count;
    } else {
        return _searchArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWYReportCardTableViewCell *cell = [[HWYReportCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identify];
//    HWYReportCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
//    if (cell) {
//        cell = [[HWYReportCardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identify];
//    }
    HWYReportCardData *reportCard = [HWYReportCardData new];
    if(_tableView == tableView) {
        reportCard = _reportCardArr[indexPath.row];
    } else {
        reportCard = _searchArr[indexPath.row];
    }
    [cell configReportCard:reportCard];
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = KColor(251, 251, 251);
    }
    return cell;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    _searchBar.showsScopeBar = YES;
    [_searchBar sizeToFit];
    [_searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    _searchBar.showsScopeBar = NO;
    [_searchBar sizeToFit];
    [_searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    _searchBar.placeholder = @"请输入课程名";
    UIView *searchBarView = [_searchBar subviews].firstObject;
    for(id view in [searchBarView subviews])
    {
        if([view isKindOfClass:[UIButton class]])
        {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    _searchBar.placeholder = @"搜索";
}

-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    _searchArr = [HWYReportCardData queryReportCardData:searchText];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles]
      objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles]
      objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_tableView == tableView) {
        if (!KArrayEmpty(_reportCardArr)) {
            return 48;
        }
        return 0;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = KColor(251, 251, 251);
    headerView.layer.borderWidth = 0.5;
    headerView.layer.borderColor = [KColor(203, 214, 226) CGColor];
    
    UILabel *bxCountTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, 85, 21)];
    bxCountTitle.font = [UIFont systemFontOfSize:13.0];
    bxCountTitle.textAlignment = NSTextAlignmentRight;
    bxCountTitle.text = @"已获必修学分:";
    [headerView addSubview:bxCountTitle];
    UILabel *bxCount = [[UILabel alloc] initWithFrame:CGRectMake(90, 3, 40, 21)];
    bxCount.font = [UIFont systemFontOfSize:15.0];
    bxCount.textAlignment = NSTextAlignmentCenter;
    bxCount.text = _reportCount.bxCount;
    [headerView addSubview:bxCount];
    
    UILabel *xxCountTitle = [[UILabel alloc] initWithFrame:CGRectMake(190, 3, 85, 21)];
    xxCountTitle.font = [UIFont systemFontOfSize:13.0];
    xxCountTitle.textAlignment = NSTextAlignmentRight;
    xxCountTitle.text = @"已获限修学分:";
    [headerView addSubview:xxCountTitle];
    UILabel *xxCount = [[UILabel alloc] initWithFrame:CGRectMake(275, 3, 40, 21)];
    xxCount.font = [UIFont systemFontOfSize:15.0];
    xxCount.textAlignment = NSTextAlignmentCenter;
    xxCount.text = _reportCount.xxCount;
    [headerView addSubview:xxCount];
    
    UILabel *rxCountTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 24, 85, 21)];
    rxCountTitle.font = [UIFont systemFontOfSize:13.0];
    rxCountTitle.textAlignment = NSTextAlignmentRight;
    rxCountTitle.text = @"已获任修学分:";
    [headerView addSubview:rxCountTitle];
    UILabel *rxCount = [[UILabel alloc] initWithFrame:CGRectMake(90, 24, 40, 21)];
    rxCount.font = [UIFont systemFontOfSize:15.0];
    rxCount.textAlignment = NSTextAlignmentCenter;
    rxCount.text = _reportCount.rxCount;
    [headerView addSubview:rxCount];
    
    UILabel *stuCountTitle = [[UILabel alloc] initWithFrame:CGRectMake(190, 24, 85, 21)];
    stuCountTitle.font = [UIFont systemFontOfSize:13.0];
    stuCountTitle.textAlignment = NSTextAlignmentRight;
    stuCountTitle.text = @"学分绩点:";
    [headerView addSubview:stuCountTitle];
    UILabel *stuCount = [[UILabel alloc] initWithFrame:CGRectMake(275, 24, 40, 21)];
    stuCount.font = [UIFont systemFontOfSize:15.0];
    stuCount.textAlignment = NSTextAlignmentCenter;
    stuCount.text = _reportCount.stuCount;
    [headerView addSubview:stuCount];
    
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void)rightItemClick:(UIButton *)sender {
    HWYReportCardWebViewController *reportCardWeb = [HWYReportCardWebViewController new];
    [self.navigationController pushViewController:reportCardWeb animated:YES];
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
