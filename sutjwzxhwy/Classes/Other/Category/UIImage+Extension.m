//
//  UIImage+Extension.m
//  黑马微博
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

//根据图片进行拉伸 默认根据width 0.5 height 0.7
+ (UIImage *)imageStretchable:(NSString *)imageName
{
    UIImage *image=[UIImage imageNamed:imageName];
    image=[image stretchableImageWithLeftCapWidth:image.size.width*0.5 topCapHeight:image.size.height*0.7];
    return image;
}

//根据进行拉伸 根据用户自定义传进来的
+ (UIImage *)imageStretchable:(NSString *)imageName WithLeftCapWidth:(CGFloat)width topCapHeight:(CGFloat)height
{
    UIImage *image=[UIImage imageNamed:imageName];
    image=[image stretchableImageWithLeftCapWidth:image.size.width*width topCapHeight:image.size.height*height];
    return image;
}

//根据图片名称 或者NSData 进行裁剪图片成圆
+ (instancetype)CircleImageWithName:(NSString *)name andImageData:(NSData *)imageData borderWidth:(CGFloat)border borderColor:(UIColor *)bordercolor
{
    UIImage *oldImage;
    if (imageData) {
        oldImage = [UIImage imageWithData:imageData];
    }else if (name)
    {
        oldImage = [UIImage imageNamed:name];
    }
    return [self CircleImageWithOldImage:oldImage borderWidth:border borderColor:bordercolor];
}

//根据图片进行裁剪图片成圆
+ (UIImage *)CircleImageWithOldImage:(UIImage *)oldImage borderWidth:(CGFloat)border borderColor:(UIColor *)bordercolor
{
    oldImage = [UIImage RectImageWithOldImage:oldImage];
    
    // 开启上下文
    CGFloat imageW=oldImage.size.width+2*border;
    CGFloat imageH=oldImage.size.height+2*border;
    UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
    
    // 取得当前的上下文
    CGContextRef cxf=UIGraphicsGetCurrentContext();
    // 画边框(大圆)
    [bordercolor set];
    CGFloat bigRadios=imageW*0.5; // 大圆半径
    CGFloat centerX=bigRadios;   // 圆心
    CGFloat centerY=bigRadios;
    CGContextAddArc(cxf, centerX, centerY, bigRadios, 0, M_PI*2, 0);
    CGContextFillPath(cxf); // 画圆
    
    // 小圆
    CGFloat smallRadius = bigRadios - border;
    CGContextAddArc(cxf, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(cxf);
    // 画图
    [oldImage drawInRect:CGRectMake(border, border, oldImage.size.width, oldImage.size.height)];
    // 取图
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return newImage;
}

//根据图片进行裁剪图片成正方形
+ (UIImage *)RectImageWithOldImage:(UIImage *)oldImage
{
    CGImageRef cgImg = CGImageCreateWithImageInRect(oldImage.CGImage, CGRectMake(0, 0, oldImage.size.width, oldImage.size.width));
    oldImage = [UIImage imageWithCGImage:cgImg];
    //注意释放CGImageRef，因为创建方法包含Create
    CGImageRelease(cgImg);
    return oldImage;
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
