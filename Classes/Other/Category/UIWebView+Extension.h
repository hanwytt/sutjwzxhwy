//
//  UIWebView+Extension.h
//  sutjwzxhwy
//
//  Created by hanwy on 15/6/3.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Extension)

- (void)loadHtmlWithString:(NSString *)string success:(void(^)())success
                   failure:(void(^)())failure;

@end
