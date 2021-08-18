//
//  SSAlertView+Extention.m
//  SSAlertView
//
//  Created by yangsq on 2020/1/14.
//  Copyright © 2020 yangsq. All rights reserved.
//

#import "SSAlertView+Extention.h"


@implementation SSAlertView (Extention)
+ (instancetype)alertViewWithType:(SSAlertActionType)type
                            title:(NSString * __nullable)title
                          message:(NSString * __nullable)message
                     cancelButton:(NSString * __nullable)cancelButton
                     otherButtons:(NSArray <NSString *> * __nullable)otherButtons
                           onView:(UIView *)onView
                      clickAction:(void(^ __nullable)(NSInteger index))clickAction

{
    NSMutableArray *actionArray = @[].mutableCopy;
    SSAlertAction *cancelAction = nil;
    if (type == SSAlertActionAlertType) {
        if (cancelButton.length) {
            cancelAction = [[SSAlertAction alloc]initWithType: type];
            cancelAction.title = cancelButton;
            [actionArray addObject:cancelAction];
        }
        [otherButtons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           SSAlertAction *action= [[SSAlertAction alloc]initWithType: type];
           action.title = obj;
           [actionArray addObject:action];
            [action setAddAction:^{
                if (clickAction) {
                    clickAction(cancelButton.length ? (idx + 1) : idx);
                }
            }];
        }];
    }
    
    if (type == SSAlertActionSheetType) {
        [otherButtons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           SSAlertAction *action= [[SSAlertAction alloc]initWithType: type];
           action.title = obj;
           [actionArray addObject:action];
            [action setAddAction:^{
                if (clickAction) {
                    clickAction(cancelButton.length ? (idx + 1) : idx);
                }
            }];
        }];
        
        if (cancelButton.length) {
            cancelAction = [[SSAlertAction alloc]initWithType: type];
            cancelAction.title = cancelButton;
            [actionArray addObject:cancelAction];
        }
    }
    
    
    SSAlertCommonView *customView =[[SSAlertCommonView alloc]initWithTitle:title
                                                                   message:message
                                                                  viewType:type
                                                                   actions:actionArray];
    customView.backgroundColor = UIColor.whiteColor;
    SSAlertView *alertView = [[SSAlertView alloc]initWithCustomView:customView
                                                                         onView:onView
                                                            masktype:SSAlertBackgroundMaskTypeBlack];
    SSAlertDefaultAnimation *animation = [[SSAlertDefaultAnimation alloc]initWithState:type == SSAlertActionAlertType ? SSAlertDefaultAnimationCenterState : SSAlertDefaultAnimationBottomState];
    alertView.animation = animation;
    alertView.canTouchMaskHide = NO;
    if (type == SSAlertActionAlertType) {
        alertView.layer.cornerRadius = 10.0f;
        alertView.clipsToBounds = YES;
    }
    __weak typeof(SSAlertView *) weakAlertView = alertView;
    [cancelAction setAddAction:^{
        __strong typeof(SSAlertView *) strongAlertView = weakAlertView;
        [strongAlertView hide:YES];
        if (clickAction) {
            clickAction(0);
        }
        
    }];
    
    return alertView;
}



+ (instancetype)modalAlertViewWithType:(SSAlertActionType)type
                                 title:(NSString * __nullable)title
                               message:(NSString * __nullable)message
                          cancelButton:(NSString * __nullable)cancelButton
                          otherButtons:(NSArray <NSString *> * __nullable)otherButtons
                        fromController:(UIViewController *)fromController
         navigationViewControllerClass:(Class)navigationViewControllerClass
                           clickAction:(void(^ __nullable)(NSInteger index))clickAction
{
    NSMutableArray *actionArray = @[].mutableCopy;
    SSAlertAction *cancelAction = nil;
    if (type == SSAlertActionAlertType) {
        if (cancelButton.length) {
            cancelAction = [[SSAlertAction alloc]initWithType: type];
            cancelAction.title = cancelButton;
            [actionArray addObject:cancelAction];
        }
        [otherButtons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           SSAlertAction *action= [[SSAlertAction alloc]initWithType: type];
           action.title = obj;
           [actionArray addObject:action];
            [action setAddAction:^{
                if (clickAction) {
                    clickAction(cancelButton.length ? (idx + 1) : idx);
                }
            }];
        }];
    }
    
    if (type == SSAlertActionSheetType) {
        [otherButtons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           SSAlertAction *action= [[SSAlertAction alloc]initWithType: type];
           action.title = obj;
           [actionArray addObject:action];
            [action setAddAction:^{
                if (clickAction) {
                    clickAction(cancelButton.length ? (idx + 1) : idx);
                }
            }];
        }];
        
        if (cancelButton.length) {
            cancelAction = [[SSAlertAction alloc]initWithType: type];
            cancelAction.title = cancelButton;
            [actionArray addObject:cancelAction];
        }
    }
    
    
    SSAlertCommonView *customView =[[SSAlertCommonView alloc]initWithTitle:title
                                                                   message:message
                                                                  viewType:type
                                                                   actions:actionArray];
    customView.backgroundColor = UIColor.whiteColor;
    SSAlertView *alertView = [[SSAlertView alloc]initWithCustomView:customView
                                                                         fromViewController:fromController navigationControllerClass:navigationViewControllerClass masktype:SSAlertBackgroundMaskTypeBlack];
    SSAlertDefaultAnimation *animation = [[SSAlertDefaultAnimation alloc]initWithState: type == SSAlertActionAlertType ? SSAlertDefaultAnimationCenterState : SSAlertDefaultAnimationBottomState];
    alertView.animation = animation;
    alertView.canTouchMaskHide = NO;
    if (type == SSAlertActionAlertType) {
        alertView.layer.cornerRadius = 10.0f;
        alertView.clipsToBounds = YES;
    }
    __weak typeof(SSAlertView *) weakAlertView = alertView;
    [cancelAction setAddAction:^{
        __strong typeof(SSAlertView *) strongAlertView = weakAlertView;
        [strongAlertView hide:YES];
        if (clickAction) {
            clickAction(0);
        }
        
    }];
    
    return alertView;
}


@end
