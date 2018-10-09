//
//  SKURLProtocol.m
//  SKAutoTest
//
//  Created by zhanghuabing on 2018/9/28.
//  Copyright © 2018年 zhb. All rights reserved.
//

#import "SKURLProtocol.h"

@implementation SKURLProtocol

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    return [super initWithRequest:request cachedResponse:cachedResponse client:client];
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return YES;
}

- (void)startLoading {
    [self.task resume];
}

- (void)stopLoading {
    if (self.task != nil) {
        [self.task cancel];
    }
}

@end
