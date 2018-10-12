//
//  SKNetworkTest.m
//  SKAutoTest
//
//  Created by zhanghuabing on 2018/9/28.
//  Copyright © 2018年 zhb. All rights reserved.
//

#import "SKNetworkTest.h"
#import "SKURLProtocol.h"

@implementation SKNetworkTest

+ (void)testURLProtolWithUrl:(NSString *)url {
    [NSURLProtocol registerClass:[SKURLProtocol class]];
    
    NSURLSession *session   = [NSURLSession sharedSession];
    NSURL *reqUrl = [NSURL URLWithString:url];
    NSURLSessionDataTask *task = [session dataTaskWithURL:reqUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"error : %@ \n response = %@", error, response);
    }];
    [task resume];
}

@end
