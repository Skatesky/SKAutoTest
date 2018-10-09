//
//  SKForwardObject.m
//  SKAutoTest
//
//  Created by zhanghuabing on 2018/9/26.
//  Copyright © 2018年 zhb. All rights reserved.
//

#import "SKForwardObject.h"
#import <objc/runtime.h>
#import "ForwardTestA.h"

@implementation SKForwardObject

void dynamicMethodIMP(id self, SEL _cmd) {
    // implementation ....
    NSLog(@"%s", __func__);
}

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    return NO;
//    if (sel == @selector(resolveThisMethodDynamically)) {
//        class_addMethod([self class], sel, (IMP) dynamicMethodIMP, "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}
//
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    return nil;
//    if (aSelector == @selector(resolveThisMethodDynamically)) {
//        return [ForwardTestA new];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"%s", __func__);
    if (aSelector == @selector(resolveThisMethodDynamically)) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%s", __func__);
    ForwardTestA *testA = [ForwardTestA new];
    if ([testA respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:testA];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

@end
