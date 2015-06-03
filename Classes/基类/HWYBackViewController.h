//
//  HWYBackViewController.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/31.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWYBackViewController : UIViewController

- (void)configTitleAndBackItem:(NSString *)title;

- (void)backItemClick:(UIButton *)sender;

- (void)didAfterDelay:(void (^)())block;
@end
