//
//  HWYNetworkingHtml.m
//  sutjwzxhwy
//
//  Created by hanwy on 15/5/14.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import "HWYNetworkingHtml.h"

@implementation HWYNetworkingHtml

#pragma mark - GET请求网络 完整返回请求到的数据
+ (void)GET:(NSString *)url
         paramters:(id)parameters
           success:(void(^)(id responseObject))success
           failure:(void(^)(NSError *error))failure
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:enc];
        NSLog(@"responseString = %@", responseString);
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@", error);
        if (failure) {
            [MBProgressHUD showError:@"网络连接错误"];
            failure(error);
        }
    }];
}

#pragma mark - POST请求网络 完整返回请求到的数据
+ (void)POST:(NSString *)url
          paramters:(id)parameters
            success:(void(^)(id responseObject))success
            failure:(void(^)(NSError *error))failure
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:enc];
        NSLog(@"responseString = %@", responseString);
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@", error);
        if (failure) {
            [MBProgressHUD showError:@"网络连接错误"];
            failure(error);
        }
    }];
}

@end
