//
//  UIView+SS_Add.h
//  SSAlertView
//
//  Created by yangsq on 2020/1/13.
//  Copyright © 2020 yangsq. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SS_Add)

@property (nonatomic, assign) CGFloat ss_x;
@property (nonatomic, assign) CGFloat ss_y;
@property (nonatomic, assign) CGFloat ss_w;
@property (nonatomic, assign) CGFloat ss_h;
@property (nonatomic, assign) CGFloat ss_centerX;
@property (nonatomic, assign) CGFloat ss_centerY;
@property (nonatomic, assign) CGSize ss_size;
@property (nonatomic, assign) CGPoint ss_origin;
@property (nonatomic, assign) CGPoint ss_center;
@end

NS_ASSUME_NONNULL_END
