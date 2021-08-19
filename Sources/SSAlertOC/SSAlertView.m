//
//  SSAlertCustomView.m
//  SSAlertView
//
//  Created by yangsq on 2020/1/13.
//  Copyright © 2020 yangsq. All rights reserved.
//

#import "SSAlertView.h"
#import "UIView+SS_Add.h"
#import "SSAlertViewAnimationController.h"
#import "SSAlertViewPresentAnimation.h"

@interface SSAlertView()
@property (nonatomic, weak) UIView *customView;
@property (nonatomic, weak) UIView *onView;
@property (nonatomic, strong) UIButton *backgroundMaskButton;
///遮罩类型
@property (nonatomic, assign) SSAlertBackgroundMaskType masktype;

@property (nonatomic, weak) UIViewController *fromViewController;

@property (nonatomic, weak) UINavigationController *navigationController;

@property (nonatomic, weak) UIViewController *toViewContrller;

@property (nonatomic, strong) SSAlertViewPresentAnimation *presentAnimation;

@property (nonatomic, assign) BOOL showPanDimissGestrue;

@property (nonatomic, copy) void(^hideCompletion)(void);


@end

@implementation SSAlertView

- (id)initWithCustomView:(UIView *)customView
                  onView:(nonnull UIView *)onView{
    return [self initWithCustomView:customView onView:onView masktype:SSAlertBackgroundMaskTypeNone];
}

- (id)initWithCustomView:(UIView *)customView
                  onView:(UIView *)onView
                masktype:(SSAlertBackgroundMaskType)masktype {
    if (self = [super initWithFrame:CGRectZero]) {
        if (onView) {
            self.customView = customView;
            self.onView = onView;
            self.masktype = masktype;
            [self setupViews];
        }
    }
    
    return self;
}



- (id)initWithCustomView:(UIView *)customView
      fromViewController:(UIViewController *)fromViewController
navigationControllerClass:(Class)navigationControllerClass
                masktype:(SSAlertBackgroundMaskType)masktype
{
    return [self initWithCustomView:customView fromViewController:fromViewController navigationControllerClass:navigationControllerClass masktype:masktype canPanDimiss:NO];
}

- (id)initWithCustomView:(UIView *)customView
      fromViewController:(UIViewController *)fromViewController
navigationControllerClass:(Class)navigationControllerClass
                masktype:(SSAlertBackgroundMaskType)masktype canPanDimiss:(BOOL)showPanDimissGestrue {
    if (self = [super initWithFrame:CGRectZero]) {
        if (fromViewController) {
            self.customView = customView;
            self.fromViewController = fromViewController;
            self.masktype = masktype;
            self.showPanDimissGestrue = showPanDimissGestrue;
            SSAlertViewAnimationController *animationVC = [[SSAlertViewAnimationController alloc]init];
            UIViewController * superVC = [self superViewController:customView];
            if (superVC != nil) {
                [animationVC addChildViewController:superVC];
                [superVC didMoveToParentViewController:animationVC];
            }
            UINavigationController *nav = [(UINavigationController *)[navigationControllerClass alloc]initWithRootViewController:animationVC];
            nav.modalPresentationStyle = UIModalPresentationCustom;
            self.navigationController = nav;
            SSAlertViewPresentAnimation *vc_animation = [[SSAlertViewPresentAnimation alloc]initWithNavigationViewController:self.navigationController animationView:customView showPanDimissGestrue:showPanDimissGestrue];
            self.navigationController.transitioningDelegate = vc_animation;
            self.navigationController.modalPresentationCapturesStatusBarAppearance = YES; //接管状态栏设置
            self.presentAnimation = vc_animation;
            self.toViewContrller = animationVC;
            self.onView = animationVC.view;
            [self setupViews];
           
        }
    }
    
    return self;
}

- (void)setupViews {
    self.canTouchMaskHide = YES;
    if (self.customView) {
        if (self.masktype != SSAlertBackgroundMaskTypeNone) {
            [self.onView addSubview:self.backgroundMaskButton];
            [self.backgroundMaskButton addTarget:self action:@selector(backgroundMaskAction) forControlEvents:UIControlEventTouchUpInside];
        }
        [self addSubview:self.customView];
        [self.onView addSubview:self];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundMaskButton.frame = CGRectMake(0, 0, self.onView.ss_w, self.onView.ss_h);
    self.customView.ss_x = self.customEdgeInsets.left;
    self.customView.ss_y = self.customEdgeInsets.top;
    self.customView.ss_w = CGRectGetWidth(self.frame) - self.customEdgeInsets.left - self.customEdgeInsets.right;
    self.customView.ss_h = CGRectGetHeight(self.frame) - self.customEdgeInsets.top - self.customEdgeInsets.bottom;
}

- (void)show:(BOOL)animated {
    if (self.navigationController != nil) {
        [self presentView:animated];
    } else {
        [self showView:animated];
    }
}
- (void)hide:(BOOL)animated {
    if (self.navigationController != nil) {
        [self dimissView:animated];
    } else {
        [self hideView:animated];
    }
}

- (void)showView:(BOOL)animation {
    
    if ([self.animation respondsToSelector:@selector(showAnimationOfAnimationView:viewSize:animation: completion:)]) {
        CGSize customViewSize = [self.customView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
        if (!CGSizeEqualToSize(self.customView.ss_size, CGSizeZero)) {
            customViewSize = self.customView.ss_size;
        }
        CGSize size = CGSizeMake(customViewSize.width + self.customEdgeInsets.left + self.customEdgeInsets.right, customViewSize.height + self.customEdgeInsets.top + self.customEdgeInsets.bottom);
        [self.animation showAnimationOfAnimationView:self viewSize:size animation:animation completion:nil];
        
    }
    
}

- (void)hideView:(BOOL)animation {
    if ([self.animation respondsToSelector:@selector(hideAnimationOfAnimationView:viewSize:animation: completion:)]) {
        CGSize customViewSize = [self.customView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
        if (!CGSizeEqualToSize(self.customView.ss_size, CGSizeZero)) {
            customViewSize = self.customView.ss_size;
        }
        CGSize size = CGSizeMake(customViewSize.width + self.customEdgeInsets.left + self.customEdgeInsets.right, customViewSize.height + self.customEdgeInsets.top + self.customEdgeInsets.bottom);
        [self.animation hideAnimationOfAnimationView:self viewSize:size animation:animation completion:^BOOL(BOOL finished) {
            return  NO;
        }];
        if (self.hideCompletion) {
            self.hideCompletion();
        }
    }
    

}

- (void)presentView:(BOOL)animation {
    
    if ([self.animation respondsToSelector:@selector(showAnimationOfAnimationView:viewSize:animation: completion:)]) {
        CGSize customViewSize = [self.customView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
        if (!CGSizeEqualToSize(self.customView.ss_size, CGSizeZero)) {
            customViewSize = self.customView.ss_size;
        }
        CGSize size = CGSizeMake(customViewSize.width + self.customEdgeInsets.left + self.customEdgeInsets.right, customViewSize.height + self.customEdgeInsets.top + self.customEdgeInsets.bottom);
        __weak typeof(self) weakSelf = self;
        [self.presentAnimation setShowAnimation:^{
            __strong typeof (self) strongSelf = weakSelf;
            [strongSelf.animation showAnimationOfAnimationView:strongSelf viewSize:size animation:animation completion:^(BOOL finished) {
                [strongSelf.presentAnimation setCompleteTransitionIsHide:NO];
            }];
        }];
        self.presentAnimation.duration = [self.animation animationDuration];
        ///存在的问题： app当前显示的是弹窗界面，默认presnent出来的视图且modalPresentationStyle不是CurrentContext这这种，这个视图的presentingVC默认根控制器，例如存在tabbarVC的话就是tabbarVC，这个会造成一个问题：当这个视图dimiss的时候，会把所有的presentedVC都dimiss（其实调用dimiss的时候是调用当前视图的presentigngVC去dimiss,遵循随创建随释放）
        /// 这个通过设置 definesPresentationContext = true,modalPresentationStyle = UIModalPresentationOverCurrentContext，这样当前视图的presentigngVC为 self.navigationController,
        /// UIModalPresentationOverCurrentContext和 UIModalPresentationCurrentContext的区别是弹出的界面，前者不会把底部的视图stact移除，后者则会。
        self.navigationController.definesPresentationContext = true;
        self.navigationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.fromViewController presentViewController:self.navigationController animated:animation completion:nil];
        if (_showPanDimissGestrue) {
            [self dimissViewDragToHideAnimation: animation];
        }
    }
    
    
}

- (void)dimissView:(BOOL)animation {
    if ([self.animation respondsToSelector:@selector(hideAnimationOfAnimationView:viewSize:animation: completion:)]) {
          CGSize customViewSize = [self.customView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
          if (!CGSizeEqualToSize(self.customView.ss_size, CGSizeZero)) {
              customViewSize = self.customView.ss_size;
          }
          CGSize size = CGSizeMake(customViewSize.width + self.customEdgeInsets.left + self.customEdgeInsets.right, customViewSize.height + self.customEdgeInsets.top + self.customEdgeInsets.bottom);
        __weak typeof(self) weakSelf = self;
        [self.presentAnimation setHideAnimation:^{
            __strong typeof (self) strongSelf = weakSelf;
            [strongSelf.animation hideAnimationOfAnimationView:strongSelf viewSize:size animation:animation completion:^BOOL(BOOL finished) {
                return  [strongSelf.presentAnimation setCompleteTransitionIsHide:YES];
            }];
        }];
        self.presentAnimation.duration = [self.animation animationDuration];
        [self.toViewContrller dismissViewControllerAnimated:YES completion:^{
            __strong typeof (self) strongSelf = weakSelf;
            if (strongSelf.hideCompletion) {
                strongSelf.hideCompletion();
            }
        }];
    
         
      }
}

- (void)dimissViewDragToHideAnimation:(BOOL)animation {
    if ([self.animation respondsToSelector:@selector(hideAnimationOfAnimationView:viewSize:animation: completion:)]) {
          CGSize customViewSize = [self.customView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
          if (!CGSizeEqualToSize(self.customView.ss_size, CGSizeZero)) {
              customViewSize = self.customView.ss_size;
          }
          CGSize size = CGSizeMake(customViewSize.width + self.customEdgeInsets.left + self.customEdgeInsets.right, customViewSize.height + self.customEdgeInsets.top + self.customEdgeInsets.bottom);
        __weak typeof(self) weakSelf = self;
        [self.presentAnimation setHideAnimation:^{
            __strong typeof (self) strongSelf = weakSelf;
            [strongSelf.animation hideAnimationOfAnimationView:strongSelf viewSize:size animation:animation completion:^BOOL(BOOL finished) {
                return  [strongSelf.presentAnimation setCompleteTransitionIsHide:YES];
            }];
        }];
        self.presentAnimation.duration = [self.animation animationDuration];
        [self.presentAnimation setEndCompletedAnimation:^{
            __strong typeof (self) strongSelf = weakSelf;
            if (strongSelf.hideCompletion) {
                strongSelf.hideCompletion();
            }
        }];
        [self.presentAnimation setPanDimissAnimation:^CGFloat(CGPoint point, CGRect panViewFrame) {
            __strong typeof (self) strongSelf = weakSelf;
            return [strongSelf.animation panToDimissTransilatePoint:point panViewFrame:panViewFrame];
        }];
      }
}

- (void)refreshFrame:(BOOL)animation {
    CGSize customViewSize = [self.customView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
    if (!CGSizeEqualToSize(self.customView.ss_size, CGSizeZero)) {
        customViewSize = self.customView.ss_size;
    }
    CGSize size = CGSizeMake(customViewSize.width + self.customEdgeInsets.left + self.customEdgeInsets.right, customViewSize.height + self.customEdgeInsets.top + self.customEdgeInsets.bottom);
    [self.animation refreshAnimationOfAnimationView:self viewSize:size animation:animation completion:nil];
}


- (void)backgroundMaskAction {
    if (self.canTouchMaskHide) {
        if (self.fromViewController) {
            [self dimissView:YES];
        }else {
            [self hideView:YES];
        }
    }
}

- (UIViewController *)superViewController:(UIView *)view {
    UIResponder * next = view.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass: [UIViewController class]]) {
            return (UIViewController *)next;
        } else {
            next = next.nextResponder;
        }
    }
    return  nil;
}

- (void)observeHideCompletion:(void (^)(void))hideCompletion {
    self.hideCompletion = hideCompletion;
}


#pragma mark - getter


- (UIButton *)backgroundMaskButton {
    if (!_backgroundMaskButton) {
        _backgroundMaskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundMaskButton.alpha = 0;
    }
    
    return _backgroundMaskButton;
}

- (UIView *)backgroundMask {
    if (self.masktype == SSAlertBackgroundMaskTypeNone) {
        return  nil;
    }
    return self.backgroundMaskButton;
}


#pragma mark - setter

- (void)setCustomEdgeInsets:(UIEdgeInsets)customEdgeInsets {
    _customEdgeInsets = customEdgeInsets;
    [self setNeedsLayout];
}

- (void)setMasktype:(SSAlertBackgroundMaskType)masktype {
    _masktype = masktype;
    if (masktype != SSAlertBackgroundMaskTypeNone) {
        if (masktype == SSAlertBackgroundMaskTypeBlack) {
            self.backgroundMaskButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        }
    }
}


- (void)dealloc
{
    self.navigationController = nil;
    self.toViewContrller = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
