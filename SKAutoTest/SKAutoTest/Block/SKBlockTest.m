//
//  SKBlockTest.m
//  SKAutoTest
//
//  Created by zhanghuabing on 2018/10/9.
//  Copyright © 2018年 zhb. All rights reserved.
//

#import "SKBlockTest.h"

@implementation SKBlockTest

- (void)test {
    //create a NSGlobalBlock
    float (^sum)(float, float) = ^(float a, float b){
        
        return a + b;
    };
    
    NSLog(@"block is %@", sum); //block is <__NSGlobalBlock__: 0x47d0>
    
    NSArray *testArr = @[@"1", @"2"];
    
    void (^TestBlock)(void) = ^{
        
        NSLog(@"testArr :%@", testArr);
    };
    
    NSLog(@"block is %@", ^{
        
        NSLog(@"test Arr :%@", testArr);
        
    });
    
    //block is <__NSStackBlock__: 0xbfffdac0>
    
    //打印可看出block是一个 NSStackBlock, 即在栈上, 当函数返回时block将无效
    
    NSLog(@"block is %@", TestBlock);
    
    //block is <__NSMallocBlock__: 0x75425a0>
    
    //上面这句在非arc中打印是 NSStackBlock, 但是在arc中就是NSMallocBlock
    
    //即在arc中默认会将block从栈复制到堆上，而在非arc中，则需要手动copy.
}

@end
