//
//  RoseAD.m
//  XADLibrary
//
//  Created by edgarcheng on 2018/9/10.
//  Copyright © 2018年 edgarcheng. All rights reserved.
//

#import "RoseAD.h"

@interface RoseAD () <UIWebViewDelegate>



@end

@implementation RoseAD

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        //self.backgroundColor = [UIColor redColor];
        
        self.ratioW = 0;
        self.userInteractionEnabled = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContainer:) name:@"resizeContainer" object:nil];
        _adDuration = 10;
        _roseExposureUrlArray = [[NSMutableArray alloc] init];
        _roseCmurlArray = [[NSMutableArray alloc] init];
        [self createWebview];
        [self addSubview:_webview];
    }
    return self;
}

- (void)layoutSubviews {
    self.webview.frame = self.bounds;
}

- (UIWebView*)createWebview
{
    _webview = [[UIWebView alloc] init];
    _webview.backgroundColor = [UIColor clearColor];
    _webview.opaque = NO;
//    _webview.scalesPageToFit = YES;
//    _webview.scrollView.bounces = NO;
//    _webview.scrollView.clipsToBounds = NO;
//    _webview.clipsToBounds = NO;
    _webview.scrollView.scrollEnabled = NO;
//    _webview.userInteractionEnabled = NO;
//    _webview.paginationMode = UIWebPaginationModeUnpaginated;
    _webview.delegate = self;
    
    //“广告”
    _adLabel = [[UILabel alloc] init];
    [_adLabel setText:@"广告"];
    [_adLabel setTextColor:[self colorWithHex:0xc1c1c1]];
    [_adLabel setAdjustsFontSizeToFitWidth:YES];
    [_adLabel setTextAlignment:NSTextAlignmentLeft];
    [_webview addSubview:_adLabel];
    return _webview;
}


- (UIColor *)colorWithHex:(long)hexColor
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (int)reSizeAndPos:(int)xRatio yPos:(int)yRatio  width:(int)widthRatio height:(int)heightRatio pWidth:(int)pWidth pHeight:(int)pHeight isLayout:(Boolean)isLayout
{
    if (isLayout && [self isHidden]) {
        return -1;
    }
    if (![self isHidden] && _currentXRatio == xRatio && _currentYRatio == yRatio && _currentWRatio == widthRatio && _currentHRatio == heightRatio && _currentParentW == pWidth && _currentParentH == pHeight) {
        // no need to refresh the view
        return -1;
    }
    _currentXRatio = xRatio;
    _currentYRatio = yRatio;
    _currentWRatio = widthRatio;
    _currentHRatio = heightRatio;
    _currentParentW = pWidth;
    _currentParentH = pHeight;
    
    float xRatioF = (float)(_currentXRatio * 0.01);
    float yRatioF = (float)(_currentYRatio * 0.01);
    float wRatioF = (float)(_currentWRatio * 0.01);
    float hRatioF = (float)(_currentHRatio * 0.01);
    int x = pWidth * xRatioF;
    int y = pHeight * yRatioF;
    int width = pWidth * wRatioF;
    int height = pHeight * hRatioF;
    _viewShift = _currentParentW;
    if (xRatioF < 0.5) {
        _viewShift = - _viewShift;
    }
    CGFloat xPositionDiff = _viewShift;
    if (isLayout){
        xPositionDiff = 0;
    }
    [self setFrame:CGRectMake(x, y, width, height)];
    CGSize size = self.frame.size;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [_webview setFrame:rect];
    
    CGFloat adHeight = (CGFloat)(size.height * 0.1);
    CGFloat heightSize = (CGFloat)(adHeight * 0.9);
    CGFloat adWith = size.width * 0.5;
    [_adLabel setFrame:CGRectMake(0, size.height-adHeight, adWith, adHeight)];
    [_adLabel setFont:[UIFont systemFontOfSize:(heightSize)]];
    return 1;
}

- (void)httpRequest:(NSString*)urlStr method:(NSString*)httpMethod timout:(int)timeout completionHandler:(void(^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler
{
    __block NSURL* url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:timeout];
    [request setHTTPMethod:httpMethod];
    NSURLSession* sharedSession = nil;
    if ([urlStr containsString:@"https"]) {
        sharedSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:(id)self delegateQueue:[NSOperationQueue mainQueue]];
    } else {
        sharedSession = [NSURLSession sharedSession];
    }
    NSURLSessionDataTask* dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(data,response,error);
        }
    }];
    [dataTask resume];
}

- (void)loadRose:(NSString *)urlStr
{
//    [self httpRequest:urlStr method:@"GET" timout:30 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//        long retCode = (long)[httpResponse statusCode];
//        if (retCode == 200) {
//            UIImage* image = [UIImage imageWithData:data];
//            CGFloat fixelW = CGImageGetWidth(image.CGImage);
//            CGFloat fixelH = CGImageGetHeight(image.CGImage);
//            self.ratioW = fixelW/fixelH;
//            CGRect rect = self.frame;
//            rect.size.width = self.ratioW * rect.size.height;
//            self.frame = rect;
//            CGSize size = self.frame.size;
//            CGRect webRect = CGRectMake(0, 0, size.width, size.height);
//            [_webview setFrame:webRect];
//            [_webview loadData:(NSData*)data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//            [self showRose];
//        }
//    }];
    
    NSString *html= [NSString stringWithFormat:@"<img src=%@ alt="" />",urlStr];
    NSString *css = @"<style type=\"text/css\"> img {\n"
    "width:100%;\n"
    "height:auto;\n"
    "}\n"
    "</style>\n";
    html = [NSString stringWithFormat:@"<html><header> \n %@ \n </header><body> \n %@ \n </body></html>", css, html];
    [_webview loadHTMLString:html baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self showRose];
}

- (void)showRose
{
    if([self isHidden]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setHidden:NO];
//            [UIView animateWithDuration:1.5 animations:^{
//                self.transform = CGAffineTransformTranslate(self.transform, -_viewShift,0);
//            }];
            [self simpleLayerRotation];
            NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:self.adDuration target:self selector:@selector(hideRose) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        });
    }
}
- (void)changeContainer:(NSNotification*)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self isHidden]){
            int width = [self superview].frame.size.width;
            int height = [self superview].frame.size.height;
            if (width > 0 && height > 0){
                int ret = [self reSizeAndPos:_currentXRatio yPos:_currentYRatio width:_currentWRatio height:_currentHRatio pWidth:width pHeight:height isLayout:YES];
                CGRect rect = self.frame;
                rect.size.width = self.ratioW * rect.size.height;
                self.frame = rect;
                CGSize size = rect.size;
                CGRect webRect = CGRectMake(0, 0, size.width, size.height);
                [_webview.scrollView setContentSize:size];
                [_webview.scrollView setFrame:webRect];
                [_webview setFrame:webRect];
            }
        }
    });
}

- (void)simpleLayerRotation
{
    CABasicAnimation* basicAnimation;
    basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    basicAnimation.fromValue = [NSNumber numberWithFloat:M_PI_2];
    basicAnimation.toValue = [NSNumber numberWithFloat:M_2_PI];
    basicAnimation.duration = 1;
    basicAnimation.cumulative = NO;
    basicAnimation.repeatCount = 1;
    basicAnimation.fillMode = kCAFillModeForwards;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.delegate = self;
    [_webview.layer addAnimation:basicAnimation forKey:@"rotationAnimation"];
}

- (void)hideRose
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![self isHidden]){
            [UIView animateWithDuration:1.5 animations:^{
                //self.transform = CGAffineTransformTranslate(self.transform, _viewShift,0);
            } completion:^(BOOL finished) {
                [_webview loadHTMLString:@"" baseURL:nil];
                [self setHidden:YES];
                [self removeFromSuperview];
            }];
        }
    });
}


- (void)cleanCacheAndCookie{
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]){
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

@end
