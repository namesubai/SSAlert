//
//  SSDefaultAlertAnimation.h
//  SSAlertView
//
//  Created by yangsq on 2020/1/14.
//  Copyright © 2020 yangsq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSAlertAnimation.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

///四种呈现的方式
typedef NS_ENUM(NSInteger,SSAlertDefaultAnimationState) {
    ///重顶部开始呈现
    SSAlertDefaultAnimationTopState,
    ///从左边开始呈现
    SSAlertDefaultAnimationLeftState,
    ///从底部开始呈现
    SSAlertDefaultAnimationBottomState,
    ///从右边开始呈现
    SSAlertDefaultAnimationRightState,
    ///中心位置呈现
    SSAlertDefaultAnimationCenterState,
};

@interface SSAlertDefaultAnimation : NSObject <SSAlertAnimation>
///view相对中心点的偏移量
@property (nonatomic, assign) CGPoint centeroffset;
@property (nonatomic, assign) NSTimeInterval duration;

///初始化方法
- (instancetype)initWithState:(SSAlertDefaultAnimationState)state;
- (void)setCenteroffset:(CGPoint)centeroffset
               duration:(NSTimeInterval)duration
              animation:(BOOL)animation
             completion:(void(^ __nullable)(BOOL finished))completion;

@end

NS_ASSUME_NONNULL_END
