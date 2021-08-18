//
//  SSAlertViewPresentAnimation.m
//  HiNovel
//
//  Created by yangsq on 2020/8/21.
//

#import "SSAlertViewPresentAnimation.h"

@interface SSCustomInteractiveAnimation : UIPercentDrivenInteractiveTransition
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;
- (id)initWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;
@property (nonatomic, copy) CGFloat(^panDimissAnimation)(CGPoint point, CGRect panViewFrame);

@end

@implementation SSCustomInteractiveAnimation
- (id)initWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (self = [super init]) {
        self.panGestureRecognizer = panGestureRecognizer;
        [panGestureRecognizer addTarget:self action:@selector(panAction:)];
    }
    return  self;
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:pan.view];
    CGFloat progress = self.panDimissAnimation(point, pan.view.frame);
    if (pan.state == UIGestureRecognizerStateChanged) {
        [self updateInteractiveTransition:progress];
    }
    if (pan.state == UIGestureRecognizerStateCancelled) {
        [self cancelInteractiveTransition];
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        if (progress > 0.4) {
            [self finishInteractiveTransition];
        } else {
            [self cancelInteractiveTransition];
        }
    }
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    [super startInteractiveTransition:transitionContext];
}

- (void)dealloc
{
    [self.panGestureRecognizer removeTarget:self action:@selector(panAction:)];
}

@end


@interface SSAlertViewPresentAnimation () <UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) id <UIViewControllerContextTransitioning>transitionContext;
@property (nonatomic, weak) UINavigationController *nav;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, weak) UIView *animationView;

@end

@implementation SSAlertViewPresentAnimation
- (id)initWithNavigationViewController:(UINavigationController *)nav animationView:(UIView *)animationView {
    return [self initWithNavigationViewController:nav animationView: animationView showPanDimissGestrue:NO];
}

- (id)initWithNavigationViewController:(UINavigationController *)nav
                         animationView:(UIView *)animationView
                  showPanDimissGestrue:(BOOL)showPanDimissGestrue
{
    if (self = [super init]) {
        self.nav = nav;
        self.animationView = animationView;
        if (showPanDimissGestrue) {
            UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]init];
            panGestureRecognizer.maximumNumberOfTouches = 1;
            [animationView addGestureRecognizer:panGestureRecognizer];
            [panGestureRecognizer addTarget:self action:@selector(panAction:)];
        }
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.duration = 0.35;
    }
    return self;
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.panGestureRecognizer = pan;
        __weak typeof(self) weakSelf = self;
        [self.nav.viewControllers[0] dismissViewControllerAnimated:YES completion:^{
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.panGestureRecognizer = nil;
        }];
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    if (self.panGestureRecognizer) {
        SSCustomInteractiveAnimation * interactiveAnimation = [[SSCustomInteractiveAnimation alloc]initWithPanGestureRecognizer:self.panGestureRecognizer];
        interactiveAnimation.panDimissAnimation = self.panDimissAnimation;
        return interactiveAnimation;
    }
    return  nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (self.panGestureRecognizer) {
        SSCustomInteractiveAnimation * interactiveAnimation = [[SSCustomInteractiveAnimation alloc]initWithPanGestureRecognizer:self.panGestureRecognizer];
        interactiveAnimation.panDimissAnimation = self.panDimissAnimation;
        return interactiveAnimation;
    }
    return  nil;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    UIViewController *fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    BOOL isPresenting = (toVC.presentingViewController == fromVC);
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    }
    if (isPresenting) {
        [containerView addSubview:toView];
        !self.showAnimation? :self.showAnimation();
        
    }else {
        [containerView insertSubview:toView belowSubview:fromView];
        !self.hideAnimation? :self.hideAnimation();
    }


}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animationEnded:(BOOL)transitionCompleted {
    if (transitionCompleted) {
        if (self.transitionContext.interactive) {
            !self.endCompletedAnimation? :self.endCompletedAnimation();
        }
    }
}

- (BOOL)setCompleteTransitionIsHide:(BOOL)isHide {
    BOOL wasCancelled = [self.transitionContext transitionWasCancelled];
    if (!wasCancelled) {
        if (isHide) {
            for (UIView *view in self.transitionContext.containerView.subviews) {
                [view removeFromSuperview];
            }
        }
        
    }
    
    [self.transitionContext completeTransition:!wasCancelled];
    return  wasCancelled;
}

- (void)dealloc
{
    
}

@end
