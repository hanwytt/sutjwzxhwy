//
//  HWYOffLineLoginViewController.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/23.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWYLoginViewController.h"

@protocol HWYLoginOffLineState <NSObject>

- (void)loginOffLineState:(BOOL)success number:(NSString *)number;

@end

@interface HWYLoginOffLineViewController : HWYLoginViewController

@property (nonatomic) id<HWYLoginOffLineState> delegate;

@end
