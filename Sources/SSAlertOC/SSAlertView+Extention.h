//
//  SSAlertView+Extention.h
//  SSAlertView
//
//  Created by yangsq on 2020/1/14.
//  Copyright © 2020 yangsq. All rights reserved.
//



#import "SSAlertView.h"
#import "SSAlertCommonView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SSAlertView (Extention)
+ (instancetype)alertViewWithType:(SSAlertActionType)type
                            title:(NSString * __nullable)title
                          message:(NSString * __nullable)message
                     cancelButton:(NSString * __nullable)cancelButton
                     otherButtons:(NSArray <NSString *> * __nullable)otherButtons
                           onView:(UIView *)onView
                      clickAction:(void(^ __nullable)(NSInteger index))clickAction;

+ (instancetype)modalAlertViewWithType:(SSAlertActionType)type
                                 title:(NSString * __nullable)title
                               message:(NSString * __nullable)message
                          cancelButton:(NSString * __nullable)cancelButton
                          otherButtons:(NSArray <NSString *> * __nullable)otherButtons
                        fromController:(UIViewController *)fromController
         navigationViewControllerClass:(Class)navigationViewControllerClass
                           clickAction:(void(^ __nullable)(NSInteger index))clickAction;

@end

NS_ASSUME_NONNULL_END
