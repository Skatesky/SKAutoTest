//
//  RoseAD.h
//  XADLibrary
//
//  Created by edgarcheng on 2018/9/10.
//  Copyright © 2018年 edgarcheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoseAD : UIView

@property(nonatomic,strong) UIWebView* webview;
@property(nonatomic) int lastAdId;
@property(nonatomic) NSString* sceneType;
@property(nonatomic) float ratioW;

@property(nonatomic) UILabel* adLabel;   //show '广告'

@property(nonatomic) int currentParentW;
@property(nonatomic) int currentParentH;
@property(nonatomic) int currentWRatio;
@property(nonatomic) int currentHRatio;
@property(nonatomic) int currentXRatio;
@property(nonatomic) int currentYRatio;
@property(nonatomic) float adDuration;
@property(nonatomic) float viewShift;

@property(nonatomic) int reqRoseHeight;
@property(nonatomic) int reqRoseWidth;

@property(nonatomic) NSString* roseIconUrlStr;
@property(nonatomic) NSString* roseCUrlStr;
@property(nonatomic) NSString* roseBidid;
@property(atomic) NSMutableArray* roseExposureUrlArray;
@property(atomic) NSMutableArray* roseCmurlArray;
@property(atomic,copy) NSDictionary* roseDictionary;
@property(atomic,copy) NSDictionary* roseBidDic;

- (int)reSizeAndPos:(int)xRatio yPos:(int)yRatio  width:(int)widthRatio height:(int)heightRatio pWidth:(int)pWidth pHeight:(int)pHeight isLayout:(Boolean)isLayout;

- (void)loadRose:(NSString*)urlStr;
- (void)showRose;
- (void)hideRose;

@end
