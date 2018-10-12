//
//  SKBlockTest.h
//  SKAutoTest
//
//  Created by zhanghuabing on 2018/10/9.
//  Copyright © 2018年 zhb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKBlockTest : NSObject

@property (copy, nonatomic) void (^testBlock)(void);

- (void)test;

@end
