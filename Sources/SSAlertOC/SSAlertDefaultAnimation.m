//
//  SSAlertDefaultAnimation.m
//  SSAlertView
//
//  Created by yangsq on 2020/1/14.
//  Copyright © 2020 yangsq. All rights reserved.
//

#import "SSAlertDefaultAnimation.h"
#import "SSAlertView.h"
#import "UIView+SS_Add.h"

@interface SSAlertDefaultAnimation ()
@property (nonatomic, assign) SSAlertDefaultAnimationState animationState;
@property (nonatomic, weak) SSAlertView *animationView;
@end

@implementation SSAlertDefaultAnimation
- (instancetype)initWithState:(SSAlertDefaultAnimationState)state {
    if (self = [super init]) {
        self.animationState = state;
        self.duration = 0.3;
    }
    return self;
}
- (NSTimeInterval)animationDuration {
    return self.duration;
}

- (void)showAnimationOfAnimationView:(SSAlertView *)animationView viewSize:(CGSize)viewSize animation:(BOOL)animation completion:(void (^ _Nullable)(BOOL))completion{
    self.animationView = animationView;
    animationView.alpha = 1;
    animationView.ss_size = viewSize;
    if (self.animationState == SSAlertDefaultAnimationBottomState) {
        animationView.ss_centerX  = animationView.superview.ss_w / 2.0 + self.centeroffset.x;
        animationView.ss_y = animationView.superview.ss_h + self.centeroffset.y;
        [self springAnimationMethod:animation animations:^{
            animationView.transform = CGAffineTransformMakeTranslation(0, - animationView.ss_h);
            animationView.backgroundMask.alpha = 1;
         } completion:completion];
    }
    if (self.animationState == SSAlertDefaultAnimationTopState) {
        animationView.ss_centerX  = animationView.superview.ss_w / 2.0 + self.centeroffset.x;
        animationView.ss_y = - animationView.ss_h + self.centeroffset.y;
        [self animationMethod:animation animations:^{
            animationView.transform = CGAffineTransformMakeTranslation(0, animationView.ss_h);
            animationView.backgroundMask.alpha = 1;
        } completion:completion];
    }
    
    if (self.animationState == SSAlertDefaultAnimationLeftState) {
        animationView.ss_centerY  = animationView.superview.ss_h / 2.0 + self.centeroffset.y;
        animationView.ss_x =  - animationView.ss_w + self.centeroffset.x;
        [self animationMethod:animation animations:^{
            animationView.transform = CGAffineTransformMakeTranslation(animationView.ss_w, 0);
            animationView.backgroundMask.alpha = 1;
        } completion:completion];
    }
    
    if (self.animationState == SSAlertDefaultAnimationRightState) {
        animationView.ss_centerY  = animationView.superview.ss_h / 2.0 + self.centeroffset.y;
        animationView.ss_x = animationView.superview.ss_w + self.centeroffset.x;

        [self animationMethod:animation animations:^{
             animationView.transform = CGAffineTransformMakeTranslation(- animationView.ss_w, 0);
            animationView.backgroundMask.alpha = 1;

        } completion:completion];
    }
    
    if (self.animationState == SSAlertDefaultAnimationCenterState) {
        animationView.alpha = 0;
        animationView.ss_centerX = animationView.superview.ss_w / 2.0 + self.centeroffset.x;
        animationView.ss_centerY = animationView.superview.ss_h / 2.0 + self.centeroffset.y;
        animationView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        [self animationMethod:animation animations:^{
            animationView.alpha = 1;
            animationView.transform = CGAffineTransformIdentity;
            animationView.backgroundMask.alpha = 1;

        } completion:completion];

    }
    
}

- (void)refreshAnimationOfAnimationView:(SSAlertView *_Nullable)animationView
                            viewSize:(CGSize)viewSize
                           animation:(BOOL)animation
                             completion:(void(^ _Nullable)(BOOL finished))completion { self.animationView = animationView;
    animationView.alpha = 1;
    animationView.ss_size = viewSize;
    if (self.animationState == SSAlertDefaultAnimationBottomState) {
        animationView.ss_centerX  = animationView.superview.ss_w / 2.0 + self.centeroffset.x;
        [self springAnimationMethod:animation animations:^{
            animationView.ss_y = animationView.superview.ss_h - viewSize.height - self.centeroffset.y;
         } completion:completion];
    }
    if (self.animationState == SSAlertDefaultAnimationTopState) {
        animationView.ss_centerX  = animationView.superview.ss_w / 2.0 + self.centeroffset.x;
        [self animationMethod:animation animations:^{
            animationView.ss_y = self.centeroffset.y;
        } completion:completion];
    }
    
    if (self.animationState == SSAlertDefaultAnimationLeftState) {
        animationView.ss_centerY = animationView.superview.ss_h / 2.0 + self.centeroffset.y;
        [self animationMethod:animation animations:^{
            animationView.ss_x =  self.centeroffset.x;
        } completion:completion];
    }
    
    if (self.animationState == SSAlertDefaultAnimationRightState) {
        animationView.ss_centerY = animationView.superview.ss_h / 2.0 + self.centeroffset.y;

        [self animationMethod:animation animations:^{
            animationView.ss_x = animationView.superview.ss_w - viewSize.width + self.centeroffset.x;

        } completion:completion];
    }
    
    if (self.animationState == SSAlertDefaultAnimationCenterState) {
        animationView.alpha = 0;
        animationView.ss_centerX = animationView.superview.ss_w / 2.0 + self.centeroffset.x;
        animationView.ss_centerY = animationView.superview.ss_h / 2.0 + self.centeroffset.y;
        animationView.transform = CGAffineTransformMakeScale(1.5, 1.5);
        [self animationMethod:animation animations:^{
            animationView.alpha = 1;
            animationView.transform = CGAffineTransformIdentity;

        } completion:completion];

    }
}

- (void)hideAnimationOfAnimationView:(SSAlertView *)animationView viewSize:(CGSize)viewSize animation:(BOOL)animation completion:(BOOL (^ _Nullable)(BOOL finished))completion{
    __block SSAlertView *view = animationView;
    [self animationMethod:animation animations:^{
        if (self.animationState == SSAlertDefaultAnimationCenterState) {
            view.alpha = 0;
        }else {
            view.transform = CGAffineTransformIdentity;
        }
        view.backgroundMask.alpha = 0;

    } completion:^(BOOL finished) {
        BOOL isCancel = !completion? :completion(finished);
        
        if (finished && !isCancel) {
            [view removeFromSuperview];
            [view.backgroundMask removeFromSuperview];
            view = nil;
        }
    }];
}

- (CGFloat)panToDimissTransilatePoint:(CGPoint)point panViewFrame:(CGRect)frame {
    CGFloat progress = 0.0;
    switch (self.animationState) {
        case SSAlertDefaultAnimationTopState:
            if (point.y <= 0) {
                progress = fabs(point.y / frame.size.height);
            }
            
            break;
            
        case SSAlertDefaultAnimationBottomState:
            if (point.y >= 0) {
                progress = fabs(point.y / frame.size.height);
            }
            
            break;
            
        case SSAlertDefaultAnimationLeftState:
            if (point.x <= 0) {
                progress = fabs(point.x / frame.size.width);
            }
            
            break;
            
        case SSAlertDefaultAnimationRightState:
            if (point.x >= 0) {
                progress = fabs(point.x / frame.size.width);
            }
            
            break;
        case SSAlertDefaultAnimationCenterState:
            progress = fabs(point.y / frame.size.height);
            break;
            
        default:
            break;
    }
    return  progress;
}


- (void)animationMethod:(BOOL)animation
              animations:(void(^ __nullable)(void))animations
              completion:(void(^ __nullable)(BOOL finished))completion {
    if (!animation) {
        !animations? :animations();
        !completion? :completion(YES);
    }else {
        [UIView animateWithDuration:[self animationDuration]
                         animations:animations
                         completion:completion];
    }
}

- (void)springAnimationMethod:(BOOL)animation
                   animations:(void(^ __nullable)(void))animations
                   completion:(void(^ __nullable)(BOOL finished))completion {
    if (!animation) {
        !animations? :animations();
        !completion? :completion(YES);
    }else {
        [UIView animateWithDuration:[self animationDuration]
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionTransitionNone
                         animations:animations
                         completion:completion];
     
    }
}

- (void)setCenteroffset:(CGPoint)centeroffset
               duration:(NSTimeInterval)duration
              animation:(BOOL)animation
             completion:(void(^ __nullable)(BOOL finished))completion{
    self.duration = duration;
    [self animationMethod:animation animations:^{
        self.animationView.transform = CGAffineTransformMakeTranslation(centeroffset.x, centeroffset.y);

    } completion:completion];
}

@end



