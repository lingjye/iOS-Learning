//
//  NetRequest.m
//  PublicModule
//
//  Created by txooo on 2019/6/13.
//  Copyright © 2019 txooo. All rights reserved.
//

#import "NetRequest.h"

@implementation NetRequest

+ (void)request:(NetRequestResult)result {
    [[self class] logging:@"请求开始"];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager GET:@"http://www.baidu.com" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"%@", downloadProgress);
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self class] logging:@"请求完成"];
        result(@"OK");
        [[self class] logging:@"回调完成"];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [[self class] logging:@"请求错误"];
//        result(error.localizedDescription);
//    }];
}

+ (void)logging:(NSString *)msg {
    NSLog(@"%@: %@", [self class], msg);
}

@end
