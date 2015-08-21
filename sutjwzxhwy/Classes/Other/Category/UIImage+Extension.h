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
 *  根据图片进行拉伸 默认根据width 0.5 height 0.7
 *
 *  @param imageName 图片名称
 *
 *  @return 拉伸后图片
 */
+ (UIImage *)imageStretchable:(NSString *)imageName;

/**
 *  根据进行拉伸 根据用户自定义传进来的
 *
 *  @param imageName 图片名称
 *  @param width     自定义宽
 *  @param height    自定义高
 *
 *  @return 拉伸后图片
 */
+ (UIImage *)imageStretchable:(NSString *)imageName WithLeftCapWidth:(CGFloat)width topCapHeight:(CGFloat)height;
/**
 *  根据图片名称 或者NSData 进行裁剪图片成圆
 *
 *  @param name        图片名称
 *  @param imageData   图片数据
 *  @param border      两圆之间距离
 *  @param bordercolor 两圆之间颜色
 *
 *  @return     裁剪后的圆
 */
+ (instancetype)CircleImageWithName:(NSString *)name andImageData:(NSData *)imageData borderWidth:(CGFloat)border borderColor:(UIColor *)bordercolor;
/**
 *  根据图片进行裁剪图片成圆
 *
 *  @param oldImage    图片名称
 *  @param border      两圆之间距离
 *  @param bordercolor 两圆之间颜色
 *
 *  @return 裁剪后的圆
 */
+ (UIImage *)CircleImageWithOldImage:(UIImage *)oldImage borderWidth:(CGFloat)border borderColor:(UIColor *)bordercolor;
/**
 *  根据图片进行裁剪图片成正方形
 *
 *  @param oldImage   图片名称
 *
 *  @return 返回裁剪压缩后的数据
 */
//
+ (UIImage *)RectImageWithOldImage:(UIImage *)oldImage;

//多线程加载网络图片
+ (void)imageWithUrl:(NSURL *)url success:(void(^)(NSData * data, UIImage *image))success failure:(void(^)())failure;

@end
