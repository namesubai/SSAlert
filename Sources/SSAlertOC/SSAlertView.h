//
//  SSAlertView.h
//  SSAlertView
//
//  Created by yangsq on 2020/1/13.
//  Copyright © 2020 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSAlertDefaultAnimation.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,SSAlertBackgroundMaskType) {
    SSAlertBackgroundMaskTypeNone, //默认没有遮罩
    SSAlertBackgroundMaskTypeClear, //透明遮罩
    SSAlertBackgroundMaskTypeBlack, //黑色遮罩
};

@interface SSAlertView : UIView
/// customView 的内间距
@property (nonatomic, assign) UIEdgeInsets customEdgeInsets;
/// 展示和隐藏动画设置
@property (nonatomic, strong) id <SSAlertAnimation> animation;
/// 遮罩视图
@property (nonatomic, strong, readonly) UIView *backgroundMask;
/// 是否点击遮罩隐藏，默认点击会隐藏
@property (nonatomic, assign) BOOL canTouchMaskHide;
/// 模态视图弹窗才有
@property (nonatomic, strong, readonly) UINavigationController *navigationController;


/// 初始化（普通视图弹窗）
- (id)initWithCustomView:(UIView *)customView
                  onView:(UIView *)onView;
- (id)initWithCustomView:(UIView *)customView
                  onView:(UIView *)onView
                masktype:(SSAlertBackgroundMaskType)masktype;

/// 初始化（模态视图弹窗）
- (id)initWithCustomView:(UIView *)customView
      fromViewController:(UIViewController *)fromViewController
navigationControllerClass:(Class)navigationControllerClass
                masktype:(SSAlertBackgroundMaskType)masktype;
- (id)initWithCustomView:(UIView *)customView
      fromViewController:(UIViewController *)fromViewController
navigationControllerClass:(Class)navigationControllerClass
                masktype:(SSAlertBackgroundMaskType)masktype
            canPanDimiss:(BOOL)showPanDimissGestrue;
/// 展示和隐藏
- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;


/// 当customView的大小变化，可以重新刷新动画的位置
- (void)refreshFrame:(BOOL)animation;

/// 隐藏动画完成回调
- (void)observeHideCompletion:(void(^)(void))hideCompletion;
@end


NS_ASSUME_NONNULL_END
