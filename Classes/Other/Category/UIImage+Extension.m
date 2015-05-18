//
//  UIImage+Extension.m
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

+ (void)imageWithUrl:(NSURL *)url success:(void (^)(NSData * data, UIImage *image))success failure:(void (^)())failure {
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL:url];
        UIImage *image = [[UIImage alloc] initWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                success(data, image);
            } else {
                failure();
            }
            application.networkActivityIndicatorVisible = NO;
        });
    });
}
@end
