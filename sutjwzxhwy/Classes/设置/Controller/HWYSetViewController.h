//
//  HWYSettingViewController.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWYRightViewController.h"

@protocol HWYLogoutState <NSObject>

- (void)logoutState;

@end

@interface HWYSetViewController : HWYRightViewController

@property (nonatomic) id<HWYLogoutState> delegateLogout;
- (void)getLoginState:(BOOL)offLine jwzx:(BOOL)offLine szgd:(BOOL)szgd;

@end
