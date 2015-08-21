//
//  HWYNetworkingJson.h
//  sutjwzxhwy
//
//  Created by hanwy on 15/5/14.
//  Copyright (c) 2015年 hanwy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "HWYURLConfig.h"

@interface HWYNetworkingJson : NSObject
+ (void)GET:(NSString *)url
         paramters:(id)parameters
           success:(void(^)(id responseObject))success
           failure:(void(^)(NSError *error))failure;

+ (void)POST:(NSString *)url
          paramters:(id)parameters
            success:(void(^)(id responseObject))success
            failure:(void(^)(NSError *error))failure;
@end
