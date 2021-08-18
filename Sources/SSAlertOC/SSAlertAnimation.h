//
//  SSAlertAnimation.h
//  SSAlertView
//
//  Created by yangsq on 2020/1/13.
//  Copyright © 2020 yangsq. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SSAlertView;

@protocol SSAlertAnimation <NSObject>

- (NSTimeInterval)animationDuration;

- (void)showAnimationOfAnimationView:(SSAlertView *_Nullable)animationView
                            viewSize:(CGSize)viewSize
                           animation:(BOOL)animation
                          completion:(void(^ _Nullable)(BOOL finished))completion;

- (void)hideAnimationOfAnimationView:(SSAlertView *_Nullable)animationView
                            viewSize:(CGSize)viewSize
                           animation:(BOOL)animation
                          completion:(BOOL (^ _Nullable)(BOOL finished))completion;

- (void)refreshAnimationOfAnimationView:(SSAlertView *_Nullable)animationView
                            viewSize:(CGSize)viewSize
                           animation:(BOOL)animation
                          completion:(void(^ _Nullable)(BOOL finished))completion;

- (CGFloat)panToDimissTransilatePoint:(CGPoint)point panViewFrame:(CGRect)frame;
@end
