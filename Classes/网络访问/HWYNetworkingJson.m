//
//  HWYNetworkingJson.h
//  sutjwzxhwy
//
//  Created by hanwy on 15/5/14.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import "HWYNetworkingJson.h"

@implementation HWYNetworkingJson

#pragma mark - GET请求网络 完整返回请求到的数据
+ (void)GET:(NSString *)url
          paramters:(id)parameters
            success:(void(^)(id responseObject))success
            failure:(void(^)(NSError *error))failure
{
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
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
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject = %@",responseObject);
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
