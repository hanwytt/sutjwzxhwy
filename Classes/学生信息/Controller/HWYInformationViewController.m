//
//  HWYInformationViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYInformationViewController.h"
#import "HWYInformationWebViewController.h"
#import "HWYInformationData.h"
#import "HWYNetworking.h"
#import "HWYAppDelegate.h"
#import "MBProgressHUD.h"
#import "UIKit+AFNetworking.h"
#import "HWYGeneralConfig.h"
#import "HWYURLConfig.h"

@interface HWYInformationViewController () {
    HWYInformationData *_info;
}

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *number;
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UILabel *sex;
@property (strong, nonatomic) UILabel *nation;
@property (strong, nonatomic) UILabel *school;
@property (strong, nonatomic) UILabel *department;
@property (strong, nonatomic) UILabel *major;
@property (strong, nonatomic) UILabel *className;
@property (strong, nonatomic) UILabel *grade;
@property (strong, nonatomic) UILabel *education;
@property (strong, nonatomic) UILabel *idCardNo;
@property (strong, nonatomic) UILabel *interval;
@property (strong, nonatomic) UIView *contentView;

@end

@implementation HWYInformationViewController

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
    [self configTitleAndLeftItem:@"学生信息"];
    if (![userDefaults boolForKey:_K_MODE_OFFLINE]) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"网页版" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
        rightItem.tintColor = [UIColor whiteColor];
        [self.navigationItem setRightBarButtonItem:rightItem];
    }
}

- (void)initView {
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, P_WIDTH, P_HEIGHT - 64)];
    _contentView.hidden = YES;
    [self.view addSubview:_contentView];
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 116, 160)];
    _imageView.image = [UIImage imageNamed:@"bg_default_photo"];
    [_contentView addSubview:_imageView];
    
    UILabel *numberTitle = [[UILabel alloc] initWithFrame:CGRectMake(160, 30, 40, 21)];
    numberTitle.font = [UIFont systemFontOfSize:15.0];
    numberTitle.text = @"学号:";
    [_contentView addSubview:numberTitle];
    _number = [[UILabel alloc] initWithFrame:CGRectMake(200, 30, 100, 21)];
    _number.font = [UIFont systemFontOfSize:15.0];
    [_contentView addSubview:_number];
    
    UILabel *nameTitle = [[UILabel alloc] initWithFrame:CGRectMake(160, 51, 40, 21)];
    nameTitle.font = [UIFont systemFontOfSize:15.0];
    nameTitle.text = @"姓名:";
    [_contentView addSubview:nameTitle];
    _name = [[UILabel alloc] initWithFrame:CGRectMake(200, 51, 100, 21)];
    _name.font = [UIFont systemFontOfSize:15.0];
    [_contentView addSubview:_name];
    
    UILabel *sexTitle = [[UILabel alloc] initWithFrame:CGRectMake(160, 72, 40, 21)];
    sexTitle.font = [UIFont systemFontOfSize:15.0];
    sexTitle.text = @"性别:";
    [_contentView addSubview:sexTitle];
    _sex = [[UILabel alloc] initWithFrame:CGRectMake(200, 72, 100, 21)];
    _sex.font = [UIFont systemFontOfSize:15.0];
    [_contentView addSubview:_sex];
    
    UILabel *nationTitle = [[UILabel alloc] initWithFrame:CGRectMake(160, 93, 40, 21)];
    nationTitle.font = [UIFont systemFontOfSize:15.0];
    nationTitle.text = @"民族:";
    [_contentView addSubview:nationTitle];
    _nation = [[UILabel alloc] initWithFrame:CGRectMake(200, 93, 100, 21)];
    _nation.font = [UIFont systemFontOfSize:15.0];
    [_contentView addSubview:_nation];
    
    UILabel *schoolTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 170, 75, 21)];
    schoolTitle.font = [UIFont systemFontOfSize:15.0];
    schoolTitle.text = @"学校名称:";
    [_contentView addSubview:schoolTitle];
    _school = [[UILabel alloc] initWithFrame:CGRectMake(80, 170, 230, 21)];
    _school.font = [UIFont systemFontOfSize:15.0];
    [_contentView addSubview:_school];
    
    UILabel *departmentTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 191, 75, 21)];
    departmentTitle.font = [UIFont systemFontOfSize:15.0];
    departmentTitle.text = @"所属学院:";
    [_contentView addSubview:departmentTitle];
    _department = [[UILabel alloc] initWithFrame:CGRectMake(80, 191, 230, 21)];
    _department.font = [UIFont systemFontOfSize:15.0];
    [_contentView addSubview:_department];
    
    UILabel *majorTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 212, 75, 21)];
    majorTitle.font = [UIFont systemFontOfSize:15.0];
    majorTitle.text = @"所属专业:";
    [_contentView addSubview:majorTitle];
    _major = [[UILabel alloc] initWithFrame:CGRectMake(80, 212, 230, 21)];
    _major.font = [UIFont systemFontOfSize:15.0];
    [_contentView addSubview:_major];
    
    UILabel *classNameTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 233, 75, 21)];
    classNameTitle.font = [UIFont systemFontOfSize:15.0];
    classNameTitle.text = @"所属班级:";
    [_contentView addSubview:classNameTitle];
    _className = [[UILabel alloc] initWithFrame:CGRectMake(80, 233, 230, 21)];
    _className.font = [UIFont systemFontOfSize:15.0];
    [_contentView addSubview:_className];
    
    UILabel *gradeTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 254, 75, 21)];
    gradeTitle.font = [UIFont systemFontOfSize:15.0];
    gradeTitle.text = @"年       级:";
    [_contentView addSubview:gradeTitle];
    _grade = [[UILabel alloc] initWithFrame:CGRectMake(80, 254, 230, 21)];
    _grade.font = [UIFont systemFontOfSize:15.0];
    [_contentView addSubview:_grade];
    
    UILabel *educationTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 275, 75, 21)];
    educationTitle.font = [UIFont systemFontOfSize:15.0];
    educationTitle.text = @"培养层次:";
    [_contentView addSubview:educationTitle];
    _education = [[UILabel alloc] initWithFrame:CGRectMake(80, 275, 230, 21)];
    _education.font = [UIFont systemFontOfSize:15.0];
    [_contentView addSubview:_education];
    
    UILabel *idCardNoTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 296, 75, 21)];
    idCardNoTitle.font = [UIFont systemFontOfSize:15.0];
    idCardNoTitle.text = @"身份证号:";
    [_contentView addSubview:idCardNoTitle];
    _idCardNo = [[UILabel alloc] initWithFrame:CGRectMake(80, 296, 230, 21)];
    _idCardNo.font = [UIFont systemFontOfSize:15.0];
    [_contentView addSubview:_idCardNo];
    
    UILabel *intervalTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 317, 75, 21)];
    intervalTitle.font = [UIFont systemFontOfSize:15.0];
    intervalTitle.text = @"乘车区间:";
    [_contentView addSubview:intervalTitle];
    _interval = [[UILabel alloc] initWithFrame:CGRectMake(80, 317, 230, 21)];
    _interval.font = [UIFont systemFontOfSize:15.0];
    [_contentView addSubview:_interval];
}

- (void)initInfo {
    NSString *number = [userDefaults valueForKey:_K_DEFAULT_NUMBER];
    _info = [HWYInformationData getInformationData:number];
    if (_info) {
        _contentView.hidden = NO;
        _number.text = _info.number;
        _name.text = _info.name;
        _sex.text = _info.sex;
        _nation.text = _info.nation;
        _school.text = _info.school;
        _department.text = _info.department;
        _major.text = _info.major;
        _className.text = _info.className;
        _grade.text = _info.grade;
        _education.text = _info.education;
        _idCardNo.text = _info.idCardNo;
        _interval.text = _info.interval;
        [self requestInfoImage];
    } else {
        _contentView.hidden = YES;
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
    if ([userDefaults boolForKey:_K_MODE_OFFLINE]) {
        NSLog(@"学生信息-离线模式");
        [self performSelector:@selector(initInfo) withObject:nil afterDelay:0.5];
        [hud hide:YES afterDelay:0.5];
    } else {
        if ([HWYAppDelegate isReachable]) {
            [HWYNetworking getInformationData:^(NSError *error) {
                NSLog(@"学生信息-正常模式");
                [self initInfo];
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

- (void)requestInfoImage {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:_imageView];
    hud.margin = 3.0;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.removeFromSuperViewOnHide = YES;
    [_imageView addSubview:hud];
    [hud show:YES];
    if ([userDefaults boolForKey:_K_MODE_OFFLINE]) {
        NSLog(@"学生头像-离线模式");
        [self performSelector:@selector(initInfoImage) withObject:nil afterDelay:0.5];
        [hud hide:YES afterDelay:0.5];
    } else {
        NSLog(@"学生头像-正常模式");
        NSString *number = _info.number;
        NSString *string = [NSString stringWithFormat:JWZX_INFO_IMAGE_URL, number];
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest *requst = [NSURLRequest requestWithURL:url];
        __block UIImageView *tempImageView = _imageView;
        [_imageView setImageWithURLRequest:requst placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            NSData *imageData = nil;
            if (UIImagePNGRepresentation(image) == nil) {
                imageData = UIImageJPEGRepresentation(image, 1);
            } else {
                imageData = UIImagePNGRepresentation(image);
            }
            [HWYInformationData saveInfoImageData:imageData number:number];
            tempImageView.bounds = CGRectMake(0, 0, image.size.width*2, image.size.height*2);
            [tempImageView setImage:image];
            [hud hide:YES];
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSData *imageData = [HWYInformationData getInfoImageData:[userDefaults valueForKey:_K_DEFAULT_NUMBER]];
            UIImage *image = [UIImage imageWithData:imageData];
            [tempImageView setImage:image];
            [hud hide:YES];
        }];
    }
}

- (void)initInfoImage {
    NSString *number = [userDefaults valueForKey:_K_DEFAULT_NUMBER];
    _info.imageData = [HWYInformationData getInfoImageData:number];
    UIImage *image = [UIImage imageWithData:_info.imageData];
    [_imageView setImage:image];
}

- (void)rightItemClick:(UIButton *)sender {
    HWYInformationWebViewController *informationWeb = [HWYInformationWebViewController new];
    [self.navigationController pushViewController:informationWeb animated:YES];
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
