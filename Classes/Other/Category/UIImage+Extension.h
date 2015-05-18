//
//  UIImage+Extension.h
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

//多线程加载网络图片
+ (void)imageWithUrl:(NSURL *)url success:(void(^)(NSData * data, UIImage *image))success failure:(void(^)())failure;

@end
