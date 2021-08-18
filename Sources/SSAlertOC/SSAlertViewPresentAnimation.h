//
//  SSAlertViewPresentAnimation.h
//  HiNovel
//
//  Created by yangsq on 2020/8/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSAlertViewPresentAnimation : NSObject <UIViewControllerTransitioningDelegate>
@property (nonatomic, copy) void(^showAnimation)(void);
@property (nonatomic, copy) void(^hideAnimation)(void);
@property (nonatomic, copy) void(^endCompletedAnimation)(void);
@property (nonatomic, copy) CGFloat(^panDimissAnimation)(CGPoint point, CGRect panViewFrame);
@property (nonatomic, assign) NSTimeInterval duration;
- (id)initWithNavigationViewController:(UINavigationController *)nav
                         animationView:(UIView *)animationView;
- (id)initWithNavigationViewController:(UINavigationController *)nav
                         animationView:(UIView *)animationView
                  showPanDimissGestrue:(BOOL)showPanDimissGestrue;

- (BOOL)setCompleteTransitionIsHide:(BOOL)isHide;
@end

NS_ASSUME_NONNULL_END
