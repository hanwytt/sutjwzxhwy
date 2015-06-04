//
//  HWYLoginJwzxViewController.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWYLoginViewController.h"

@protocol HWYLoginJwzxState <NSObject>

- (void)loginJwzxState:(BOOL)success;

@end

@interface HWYLoginJwzxViewController : HWYLoginViewController

@property (assign ,nonatomic) BOOL login;
@property (nonatomic) id<HWYLoginJwzxState> delegate;

@end
