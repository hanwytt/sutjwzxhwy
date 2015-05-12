//
//  HWYLoginSzgdViewController.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWYLoginViewController.h"

@protocol HWYLoginSzgdState <NSObject>

- (void)loginSzgdState:(BOOL)success number:(NSString *)number;

@end

@interface HWYLoginSzgdViewController : HWYLoginViewController

@property (assign ,nonatomic) BOOL login;
@property (nonatomic) id<HWYLoginSzgdState> delegate;

@end
