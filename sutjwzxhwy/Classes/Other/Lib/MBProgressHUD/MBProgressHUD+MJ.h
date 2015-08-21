//
//  MBProgressHUD+MJ.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (MJ)
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showInfo:(NSString *)info toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (void)showInfo:(NSString *)info;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDAfterDelay:(NSTimeInterval)delay forView:(UIView *)view completion:(void (^)())completion;
+ (void)hideHUDForView:(UIView *)view :(void (^)())completion;
+ (void)hideHUD:(void (^)())completion;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

- (void)hideHUDAfterDelay:(NSTimeInterval)delay completion:(void(^)())completion;
//*默认0.5秒后消失/
- (void)hideHUDDefaultDelay:(void(^)())completion;
@end
