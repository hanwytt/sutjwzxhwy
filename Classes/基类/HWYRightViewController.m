//
//  HWYBaseViewController.m
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import "HWYRightViewController.h"
#import "HWYAppDelegate.h"
#import "HWYAppDefine.h"

static CGFloat range = P_WIDTH/2 - 70 + P_WIDTH * 0.8 * 0.5;    //218

@interface HWYRightViewController ()<UIGestureRecognizerDelegate>

@property (strong,nonatomic) UIControl *control;

@end

@implementation HWYRightViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.extendedLayoutIncludesOpaqueBars = YES;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBaseView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBaseView {
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:_pan];

    UIPanGestureRecognizer *controlPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    _control = [[UIControl alloc] initWithFrame:self.navigationController.view.frame];
    [_control addTarget:self action:@selector(singleTap:) forControlEvents:UIControlEventTouchUpInside];
    [_control addGestureRecognizer:controlPan];
    [self.navigationController.view addSubview:_control];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configTitleAndLeftItem:(NSString *)title {
    [self.navigationItem setTitle:title];
    UIImage *leftImage = [[UIImage imageNamed:@"icon_left_item"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

#pragma -mark 边缘滑动返回
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    } else {
        return YES;
    }
}

- (void)pan:(UIPanGestureRecognizer *)sender {
    UIView *view = self.navigationController.view;
    CGPoint translation = [sender translationInView:view];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat x = view.center.x + translation.x - P_WIDTH/2;
            if (x >= 0 && x <= range) {
//                [UIView animateWithDuration:0.001 animations:^{
//                    CGFloat oldScale = 1.0 - (view.center.x - P_WIDTH/2)/(range/0.2);
//                    CGFloat newScale = 1.0 - x/(range/0.2);
//                    // 缩放
//                    view.transform = CGAffineTransformScale(view.transform, newScale/oldScale, newScale/oldScale);
//                    // 平移
//                    view.center = CGPointMake(view.center.x + translation.x*newScale/oldScale*range/(P_WIDTH-70), view.center.y);
//                    if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
//                        [self.delegate moveTransformView:(view.center.x - P_WIDTH/2)];
//                    }
//                } completion:^(BOOL finished) {
//                    [sender setTranslation:CGPointZero inView:view];
//                }];
                CGFloat oldScale = 1.0 - (view.center.x - P_WIDTH/2)/(range/0.2);
                CGFloat newScale = 1.0 - x/(range/0.2);
                // 缩放
                view.transform = CGAffineTransformScale(view.transform, newScale/oldScale, newScale/oldScale);
                // 平移
                view.center = CGPointMake(view.center.x + translation.x*newScale/oldScale, view.center.y);
                if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
                    [self.delegate moveTransformView:(view.center.x - P_WIDTH/2)];
                }
                [sender setTranslation:CGPointZero inView:view];
            } else if (x < 0) {
                [UIView animateWithDuration:0.1 animations:^{
                    view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    view.center = CGPointMake(P_WIDTH/2, view.center.y);
                    if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
                        [self.delegate moveTransformView:0];
                    }
                } completion:^(BOOL finished) {
                    [sender setTranslation:CGPointZero inView:view];
                }];
            } else {
                [UIView animateWithDuration:0.1 animations:^{
                    view.transform = CGAffineTransformMakeScale(0.8, 0.8);
                    view.center = CGPointMake(P_WIDTH/2+range, view.center.y);
                    if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
                        [self.delegate moveTransformView:range];
                    }
                } completion:^(BOOL finished) {
                    [sender setTranslation:CGPointZero inView:view];
                }];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
            if (view.center.x - P_WIDTH/2 <= range/2) {
                CGFloat duration = (view.center.x - P_WIDTH/2)/range*0.8;
                [UIView animateWithDuration:duration animations:^{
                    view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    view.center = CGPointMake(P_WIDTH/2, view.center.y);
                    if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
                        [self.delegate moveTransformView:0];
                    }
                } completion:^(BOOL finished) {
                    [HWYAppDelegate shareDelegate].menuVisible = NO;
                    _control.hidden = YES;
                }];
            }else{
                CGFloat duration = (range-(view.center.x - P_WIDTH/2))/range*0.8;
                [UIView animateWithDuration:duration animations:^{
                    view.transform = CGAffineTransformMakeScale(0.8, 0.8);
                    view.center = CGPointMake(P_WIDTH/2+range , view.center.y);
                    if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
                        [self.delegate moveTransformView:range];
                    }
                } completion:^(BOOL finished) {
                    [HWYAppDelegate shareDelegate].menuVisible = YES;
                    _control.hidden = NO;
                }];
            }
            break;
        default:
            break;
    }
}

-(void)leftItemClick:(UIButton *)sender{
    UIView *view = self.navigationController.view;
    if ([HWYAppDelegate shareDelegate].menuVisible) {
        [UIView animateWithDuration:0.4 animations:^{
            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            view.center = CGPointMake(P_WIDTH/2, view.center.y);
            if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
                [self.delegate moveTransformView:0];
            }
        } completion:^(BOOL finished) {
            [HWYAppDelegate shareDelegate].menuVisible = NO;
            _control.hidden = YES;
        }];
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            view.transform = CGAffineTransformMakeScale(0.8, 0.8);
            view.center = CGPointMake(P_WIDTH/2+range, view.center.y);
            if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
                [self.delegate moveTransformView:range];
            }
        } completion:^(BOOL finished) {
            [HWYAppDelegate shareDelegate].menuVisible = YES;
            _control.hidden = NO;
        }];
    }
}

-(void)singleTap:(UIControl *)sender{
    if ([HWYAppDelegate shareDelegate].menuVisible) {
        UIView *view = self.navigationController.view;
        [UIView animateWithDuration:0.4 animations:^{
            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            view.center = CGPointMake(P_WIDTH/2, view.center.y);
            if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
                [self.delegate moveTransformView:0];
            }
        } completion:^(BOOL finished) {
            [HWYAppDelegate shareDelegate].menuVisible = NO;
            _control.hidden = YES;
        }];
    }
}

//- (void)pan:(UIPanGestureRecognizer *)sender {
//    UIView *view = self.navigationController.view;
//    CGPoint translation = [sender translationInView:view];
//    switch (sender.state) {
//        case UIGestureRecognizerStateBegan:
//            break;
//        case UIGestureRecognizerStateChanged:
//            CGFloat x = view.center.x + translation.x - P_WIDTH/2;
//            if (x >= 0 && x <= range) {
//                view.center = CGPointMake(view.center.x + translation.x,
//                                          view.center.y);
//                if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
//                    [self.delegate moveTransformView:x];
//                }
//            }
//            [sender setTranslation:CGPointZero inView:view];
//            break;
//        case UIGestureRecognizerStateEnded:
//            if (view.center.x - P_WIDTH/2 <= range/2) {
//                [UIView animateWithDuration:0.2 animations:^{
//                    view.center = CGPointMake(P_WIDTH/2, view.center.y);
//                    if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
//                        [self.delegate moveTransformView:0];
//                    }
//                } completion:^(BOOL finished) {
//                    [HWYAppDelegate shareDelegate].menuVisible = NO;
//                    _control.hidden = YES;
//                }];
//            }else{
//                [UIView animateWithDuration:0.2 animations:^{
//                    view.center = CGPointMake(P_WIDTH/2+range, view.center.y);
//                    if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
//                        [self.delegate moveTransformView:range];
//                    }
//                } completion:^(BOOL finished) {
//                    [HWYAppDelegate shareDelegate].menuVisible = YES;
//                    _control.hidden = NO;
//                }];
//            }
//            break;
//        default:
//            break;
//    }
//}
//
//-(void)leftItemClick:(UIButton *)sender{
//    UIView *view = self.navigationController.view;
//    if ([HWYAppDelegate shareDelegate].menuVisible) {
//        [UIView animateWithDuration:0.4 animations:^{
//            view.center = CGPointMake(P_WIDTH/2, view.center.y);
//            if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
//                [self.delegate moveTransformView:0];
//            }
//        } completion:^(BOOL finished) {
//            [HWYAppDelegate shareDelegate].menuVisible = NO;
//            _control.hidden = YES;
//        }];
//    }else{
//        [UIView animateWithDuration:0.4 animations:^{
//            view.center = CGPointMake(P_WIDTH/2+range, view.center.y);
//            if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
//                [self.delegate moveTransformView:range];
//            }
//        } completion:^(BOOL finished) {
//            [HWYAppDelegate shareDelegate].menuVisible = YES;
//            _control.hidden = NO;
//        }];
//    }
//}
//
//-(void)singleTap:(UITapGestureRecognizer *)sender{
//    if ([HWYAppDelegate shareDelegate].menuVisible) {
//        UIView *view = self.navigationController.view;
//        [UIView animateWithDuration:0.4 animations:^{
//            view.center = CGPointMake(P_WIDTH/2, view.center.y);
//            if ([self.delegate respondsToSelector:@selector(moveTransformView:)]) {
//                [self.delegate moveTransformView:0];
//            }
//        } completion:^(BOOL finished) {
//            [HWYAppDelegate shareDelegate].menuVisible = NO;
//            _control.hidden = YES;
//        }];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
