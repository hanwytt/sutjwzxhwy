//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"

@implementation MBProgressHUD (MJ)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 判断图片是否为空
    if (icon == nil) {
        hud.mode = MBProgressHUDModeText;
    } else {
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
    }
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:0.7];
}

#pragma mark 显示成功信息
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

#pragma mark 仅显示提示信息
+ (void)showInfo:(NSString *)info toView:(UIView *)view {
    [self show:info icon:nil view:view];
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (void)showInfo:(NSString *)info {
    [self showInfo:info toView:nil];
}

#pragma mark 显示加载信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

#pragma mark 隐藏加载信息
+ (void)hideHUDAfterDelay:(NSTimeInterval)delay forView:(UIView *)view completion:(void (^)())completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHUDForView:view];
        completion();
    });
}

+ (void)hideHUDForView:(UIView *)view :(void (^)())completion {
    [self hideHUDAfterDelay:0.5 forView:view completion:completion];
}

+ (void)hideHUD:(void (^)())completion {
    // 默认0.5秒后消失
    [self hideHUDAfterDelay:0.5 forView:nil completion:completion];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

- (void)hideHUDAfterDelay:(NSTimeInterval)delay completion:(void(^)())completion
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide:YES];
        completion();
    });
}

- (void)hideHUDDefaultDelay:(void(^)())completion
{
    // 默认0.5秒后消失
    [self hideHUDAfterDelay:0.5 completion:completion];
}
@end
