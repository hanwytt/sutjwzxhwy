//
//  HWYScheduleViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYScheduleViewController.h"
#import "HWYScheduleTableViewCell.h"
#import "HWYScheduleWebViewController.h"
#import "HWYScheduleData.h"
#import "HWYAppDefine.h"
#import "HWYJwzxNetworking.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "HWYAppDelegate.h"

@interface HWYScheduleViewController () <UITableViewDataSource,UITableViewDelegate, UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    NSString *_identify;
    NSArray *_scheduleArr;
    NSArray *_currentArr;
}

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *currentBtn;
@property (strong, nonatomic) UIView *selectView;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UITextField *semesterText;
@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSArray *semesterArr;
@end

@implementation HWYScheduleViewController

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
    [self configTitleAndLeftItem:@"课程表"];
    if (![KUserDefaults boolForKey:KModeOffline]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"网页版" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
        rightItem.tintColor = [UIColor whiteColor];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
}

- (NSArray *)semesterArr {
    if (_semesterArr == nil) {
        //plist文件的路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"semester.plist" ofType:nil];
        _semesterArr = [NSArray arrayWithContentsOfFile:path];
    }
    return _semesterArr;
}


- (void)initView {
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, P_WIDTH, 216)];
    _pickerView.backgroundColor = KColor(200, 203, 211);
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, P_WIDTH, 44)];
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick:)];
    UIBarButtonItem *spaceItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick:)];
    _toolBar.items = @[leftItem, spaceItem, rightItem];
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    comps = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:nowDate];
    NSInteger nowYear = [comps year];
    NSInteger nowMonth = [comps month];
    NSInteger row = (nowYear - 2008) * 2 - 1;
    if (nowMonth > 7) {
        row++;
    }
    [_pickerView selectRow:row inComponent:0 animated:NO];
    
    _semesterText = [[UITextField alloc] initWithFrame:CGRectMake(0, 65, 320, 42)];
    _semesterText.font = [UIFont systemFontOfSize:15.0];
    _semesterText.borderStyle = UITextBorderStyleNone;
    _semesterText.background = [UIImage imageNamed:@"bg_input_one"];
    _semesterText.inputView = _pickerView;
    _semesterText.inputAccessoryView = _toolBar;
    _semesterText.text = self.semesterArr[row];
    [self.view addSubview:_semesterText];
    
    //定义tableView的headview
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, 33)];
    _headerView.backgroundColor = KColor(251, 251, 251);
    _headerView.layer.borderWidth = 0.5;
    _headerView.layer.borderColor = [KColor(221, 221, 221) CGColor];
    
    UIButton *mondayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mondayBtn.tag = 1000;
    mondayBtn.frame = CGRectMake(0, 0, 45, 30);
    [mondayBtn setTitle:@"一" forState:UIControlStateNormal];
    [mondayBtn setTitleColor:KBlueColor forState:UIControlStateNormal];
    mondayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [mondayBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:mondayBtn];
    
    _currentBtn = mondayBtn;
    _currentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
    
    UIButton *tuesdayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tuesdayBtn.tag = 1001;
    tuesdayBtn.frame = CGRectMake(45, 0, 46, 30);
    [tuesdayBtn setTitle:@"二" forState:UIControlStateNormal];
    [tuesdayBtn setTitleColor:KBlueColor forState:UIControlStateNormal];
    tuesdayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [tuesdayBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:tuesdayBtn];
    
    UIButton *wednesdayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    wednesdayBtn.tag = 1002;
    wednesdayBtn.frame = CGRectMake(91, 0, 46, 30);
    [wednesdayBtn setTitle:@"三" forState:UIControlStateNormal];
    [wednesdayBtn setTitleColor:KBlueColor forState:UIControlStateNormal];
    wednesdayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [wednesdayBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:wednesdayBtn];
    
    UIButton *thursdayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    thursdayBtn.tag = 1003;
    thursdayBtn.frame = CGRectMake(137, 0, 46, 30);
    [thursdayBtn setTitle:@"四" forState:UIControlStateNormal];
    [thursdayBtn setTitleColor:KBlueColor forState:UIControlStateNormal];
    thursdayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [thursdayBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:thursdayBtn];
    
    UIButton *fridayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fridayBtn.tag = 1004;
    fridayBtn.frame = CGRectMake(183, 0, 46, 30);
    [fridayBtn setTitle:@"五" forState:UIControlStateNormal];
    [fridayBtn setTitleColor:KBlueColor forState:UIControlStateNormal];
    fridayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [fridayBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:fridayBtn];
    
    UIButton *saturdayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saturdayBtn.tag = 1005;
    saturdayBtn.frame = CGRectMake(229, 0, 46, 30);
    [saturdayBtn setTitle:@"六" forState:UIControlStateNormal];
    [saturdayBtn setTitleColor:KBlueColor forState:UIControlStateNormal];
    saturdayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [saturdayBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:saturdayBtn];
    
    UIButton *sundayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sundayBtn.tag = 1006;
    sundayBtn.frame = CGRectMake(275, 0, 45, 30);
    [sundayBtn setTitle:@"日" forState:UIControlStateNormal];
    [sundayBtn setTitleColor:KBlueColor forState:UIControlStateNormal];
    sundayBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [sundayBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:sundayBtn];
    
    _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, 46, 3)];
    _selectView.backgroundColor = KBlueColor;
    [_headerView addSubview:_selectView];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 108, P_WIDTH, P_HEIGHT-108) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 69;
    _tableView.separatorInset = UIEdgeInsetsZero;
    _tableView.layoutMargins = UIEdgeInsetsZero;
    _tableView.tableHeaderView = _headerView;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _identify = @"scheduleCell";
    [_tableView registerClass:[HWYScheduleTableViewCell class] forCellReuseIdentifier:_identify];
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        [weakSelf refreshTableView];
    }];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeLeft.delegate = self;
    [super.pan requireGestureRecognizerToFail:swipeLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    swipeRight.delegate = self;
    [super.pan requireGestureRecognizerToFail:swipeRight];
    [self.view addGestureRecognizer:swipeRight];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [tap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap];
}

- (void)initSchedule {
    _scheduleArr = [HWYScheduleData getScheduleData:_semesterText.text];
    _currentArr = _scheduleArr[_currentBtn.tag - 1000];
    [_tableView reloadData];
    if ([_tableView.header isRefreshing]) {
        [_tableView.header endRefreshing];
    }
}

- (void)requestNetworking {
    MBProgressHUD *hud = [MBProgressHUD showMessage:@"加载中..." toView:self.view];
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"课程表-离线模式");
        [self didAfterDelay:^{
            [self initSchedule];
            [hud hide:YES];
        }];
    } else {
        NSLog(@"课程表-正常模式");
        [HWYJwzxNetworking getScheduleData:_semesterText.text compelet:^{
            [self initSchedule];
            [hud hide:YES];
        }];
    }
}

- (void)refreshTableView {
    if ([KUserDefaults boolForKey:KModeOffline]) {
        NSLog(@"课程表-离线模式");
        [self didAfterDelay:^{
            [self initSchedule];
        }];
    } else {
        NSLog(@"课程表-正常模式");
        [HWYJwzxNetworking getScheduleData:_semesterText.text compelet:^{
            [self initSchedule];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HWYScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identify];
    if (cell) {
        cell = [[HWYScheduleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identify];
    }
    HWYScheduleData *schedule = _currentArr[indexPath.row];
    [cell configSchedule:schedule];
    [cell.imageCourse setImage:[UIImage imageNamed:[NSString stringWithFormat:@"section%ld", (long)indexPath.row + 1]]];
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
    } else {
        cell.backgroundColor = KColor(251, 251, 251);
    }
    return cell;
}

- (void)selectBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (_currentBtn == sender) {
        return;
    }
    NSInteger tag = _currentBtn.tag;
    _currentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    _currentBtn = sender;
    [UIView animateWithDuration:0.3 animations:^{
        _currentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        _selectView.center = CGPointMake(_currentBtn.center.x, _selectView.center.y);
    }];
    _currentArr = _scheduleArr[sender.tag-1000];
    if (_currentBtn.tag < tag) {
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationLeft];
    } else {
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
    if ([gestureRecognizer locationInView:self.view].x >= 60) {
        return YES;
    } else {
        return NO;
    }
}

- (void)swipe:(UISwipeGestureRecognizer *)sender {
    NSInteger tag = _currentBtn.tag;
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (tag>1000) {
            tag--;
        } else {
            tag = 1006;
        }
    } else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (tag<1006) {
            tag++;
        } else {
            tag = 1000;
        }
    }
    UIButton *btn = (UIButton *)[_headerView viewWithTag:tag];
    [self selectBtnClick:btn];
}

//设置当前pickerview里有几列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//设置当前pickerview里当前传入的列里有几行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.semesterArr.count;
}

//设置当前pickerview里每列的宽度
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return P_WIDTH;
}

//设置当前pikerview里行的高度
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

//设置当前pickerview里每行显示的内容
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.semesterArr[row];
}

- (void)leftBtnClick:(UIButton *)sender {
    [_semesterText resignFirstResponder];
}

- (void)rightBtnClick:(UIButton *)sender {
    NSInteger row = [_pickerView selectedRowInComponent:0];
    _semesterText.text = self.semesterArr[row];
    [self requestNetworking];
    [_semesterText resignFirstResponder];
}

-(void)tap:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

- (void)leftItemClick:(UIButton *)sender {
    [super leftItemClick:sender];
    [self.view endEditing:YES];
}

- (void)rightItemClick:(UIButton *)sender {
    [self.view endEditing:YES];
    HWYScheduleWebViewController *scheduleWeb = [HWYScheduleWebViewController new];
    scheduleWeb.semester = _semesterText.text;
    [self.navigationController pushViewController:scheduleWeb animated:YES];
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
