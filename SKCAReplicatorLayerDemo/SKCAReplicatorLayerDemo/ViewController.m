//
//  ViewController.m
//  SKCAReplicatorLayerDemo
//
//  Created by zhanghuabing on 2018/10/12.
//  Copyright © 2018年 zhb. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) CAReplicatorLayer *replicatorLayer;
@property (strong, nonatomic) CAShapeLayer *activityLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"透明度动画-opacity";
    self.view.backgroundColor = [UIColor colorWithRed:190.f/255.f green:243.f/255.f blue:253.f/255.f alpha:1];
    [self addLayer];
    [self addActivityLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[[self alphaAnimation],[self activityScaleAnimation]];
    group.duration = 1.f;
    group.repeatCount = HUGE;
    [self.activityLayer addAnimation:group forKey:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addLayer {
    self.replicatorLayer = [[CAReplicatorLayer alloc] init];
    self.replicatorLayer.frame = CGRectMake(100, 100, 300, 300);
    self.replicatorLayer.position = self.view.center;
    self.replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:self.replicatorLayer];
}

- (void)addActivityLayer {
    self.activityLayer = [[CAShapeLayer alloc] init];
    
    //使用贝塞尔曲线绘制矩形路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.view.center.x, self.view.center.y/2)];
    [path addLineToPoint:CGPointMake(self.view.center.x + 20, self.view.center.y/2)];
    [path addLineToPoint:CGPointMake(self.view.center.x + 10, self.view.center.y/2 + 20)];
    [path addLineToPoint:CGPointMake(self.view.center.x - 10 , self.view.center.y/2 + 20)];
    [path closePath];
    self.activityLayer.fillColor = [UIColor whiteColor].CGColor;
    self.activityLayer.path = path.CGPath;
    //设置图层不可见
    self.activityLayer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    
    [self.replicatorLayer addSublayer:self.activityLayer];
    
    //复制的图层数为三个
    self.replicatorLayer.instanceCount = 3;
    //设置每个复制图层延迟时间
    self.replicatorLayer.instanceDelay = 1.f / 3.f;
    //设置每个图层之间的偏移
    self.replicatorLayer.instanceTransform = CATransform3DMakeTranslation(35, 0, 0);
}

- (CABasicAnimation *)alphaAnimation{
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.fromValue = @1.0;
    alpha.toValue = @0.01;
    alpha.duration = 1.f;
    return alpha;
}

- (CABasicAnimation *)activityScaleAnimation{
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.toValue = @1;
    scale.fromValue = @1;
    return scale;
}

@end
