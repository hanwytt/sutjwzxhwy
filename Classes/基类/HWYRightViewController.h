//
//  HWYBaseViewController.h
//  sutjwzxhwy
//
//  Created by hanwy on 14/12/16.
//  Copyright (c) 2014年 hanwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HWYMoveTransformView <NSObject>

- (void)moveTransformView:(CGFloat)x;

@end

@interface HWYRightViewController : UIViewController

@property (strong,nonatomic) UIPanGestureRecognizer *pan;
@property (nonatomic) id<HWYMoveTransformView> delegate;

- (void)configTitleAndLeftItem:(NSString *)title;

-(void)leftItemClick:(UIButton *)sender;

@end
