//
//  ViewController.m
//  SKAutoTest
//
//  Created by zhanghuabing on 2018/9/13.
//  Copyright © 2018年 zhb. All rights reserved.
//

#import "ViewController.h"
#import "RoseAD.h"
#import "SKForwardObject.h"
#import "SKNetworkTest.h"
#import "SKBlockTest.h"

@interface ViewController ()

@property (strong, nonatomic) dispatch_semaphore_t runLock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self demoBlock];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 信号量测试
- (void)demo1 {
    self.runLock = dispatch_semaphore_create(1);
    
    NSLog(@"%@", self.runLock);
    long __block signalNum = dispatch_semaphore_wait(self.runLock, DISPATCH_TIME_FOREVER);
    NSLog(@"1 ==== %ld", signalNum);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(3);
        signalNum = dispatch_semaphore_signal(self.runLock);
        NSLog(@"3 ==== %ld", signalNum);
    });
    signalNum = dispatch_semaphore_wait(self.runLock, DISPATCH_TIME_FOREVER);
    NSLog(@"2 ==== %ld", signalNum);
}

// 信号量测试
- (void)demo2 { // 创建队列组
    dispatch_group_t group = dispatch_group_create(); // 创建信号量，并且设置值为10
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 11; i++) {
        // 由于是异步执行的，所以每次循环Block里面的dispatch_semaphore_signal根本还没有执行就会执行dispatch_semaphore_wait，
        //从而semaphore-1.当循环10次后，semaphore等于0，则会阻塞线程，直到执行了Block的dispatch_semaphore_signal 才会继续执行
        NSInteger value = dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"1_%ld",value);
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i",i);
            sleep(3);
            // 每次发送信号则semaphore会+1，
            NSInteger value = dispatch_semaphore_signal(semaphore);
            NSLog(@"2_%ld",value);
            
        });
    }
}

- (void)demo3 {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(100, 100, 74, 56)];
    [self.view addSubview:webView];
    
    NSString *url = @"https://videoad-1255868781.cos.ap-guangzhou.myqcloud.com/videoad-1255868781%2F49%2F20180913%2F516.png";
//    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
//    NSString *htmlStr=[NSString stringWithFormat:@"<img src='%@'/>", url];
//
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
//    [webView loadData:data MIMEType:@"image/gif" textEncodingName:@"utf-8" baseURL:nil];
    
//    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
//                       "<head> \n"
//                       "<style type=\"text/css\"> \n"
//                       "body {font-size:15px;}\n"
//                       "</style> \n"
//                       "</head> \n"
//                       "<body>"
//                       "<script type='text/javascript'>"
//                       "window.onload = function(){\n"
//                       "var $img = document.getElementsByTagName('img');\n"
//                       "for(var p in  $img){\n"
//                       " $img[p].style.width = '100%%';\n"
//                       "$img[p].style.height ='auto'\n"
//                       "}\n"
//                       "}"
//                       "</script>%@"
//                       "</body>"
//                       "</html>",htmlString];
    
    NSString *baseUrl = @"https://videoad-1255868781.cos.ap-guangzhou.myqcloud.com";
    NSString *html = [NSString stringWithFormat:@"<img src=%@ alt="" />", url];
//    NSString *html= @"<img src=\"https://videoad-1255868781.cos.ap-guangzhou.myqcloud.com/videoad-1255868781%2F49%2F20180913%2F516.png\" alt="" />";
    NSString *css = @"<style type=\"text/css\"> img {\n"
    "width:100%;\n"
    "height:auto;\n"
    "}\n"
    "</style>\n";
//    NSString *css = @"<style type=\"text/css\"> img {\n"
//    "width:100%;\n"
//    "height:auto;\n"
//    "}\n"
//    "body {\n"
//    "margin-right:15px;\n"
//    "margin-left:15px;\n"
//    "margin-top:15px;\n"
//    "font-size:45px;\n"
//    "}\n"
//    "</style>\n";
    html = [NSString stringWithFormat:@"<html><header> \n %@ \n </header><body> \n %@ \n </body></html>", css, html];
    [webView loadHTMLString:html baseURL:nil];
    
    RoseAD *adView = [[RoseAD alloc] init];
    adView.frame = CGRectMake(200, 200, 74, 56);
    [self.view addSubview:adView];
    [adView loadRose:url];
}

- (void)demo4 {
    SKForwardObject *forwardObject = [SKForwardObject new];
    [forwardObject resolveThisMethodDynamically];
}

- (void)demo5 {
    [SKNetworkTest testURLProtolWithUrl:@"http://doc.dz11.com/dds/space/folder?sid=99&resId=46895"];
}

- (void)demoBlock {
    SKBlockTest *blockTest = [[SKBlockTest alloc] init];
    [blockTest test];
}

@end
