//
//  UIWebView+Extension.m
//  sutjwzxhwy
//
//  Created by hanwy on 15/6/3.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import "UIWebView+Extension.h"

@implementation UIWebView (Extension)

- (void)loadHtmlWithString:(NSString *)string success:(void(^)())success
                   failure:(void(^)())failure {
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:string];
        NSData * data = [[NSData alloc] initWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data != nil) {
                [self loadData:data MIMEType:nil textEncodingName:nil baseURL:nil];
                success();
            } else {
                failure();
            }
            application.networkActivityIndicatorVisible = NO;
        });
    });
}

@end
