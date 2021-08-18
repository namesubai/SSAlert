//
//  UIView+SS_Add.m
//  SSAlertView
//
//  Created by yangsq on 2020/1/13.
//  Copyright © 2020 yangsq. All rights reserved.
//

#import "UIView+SS_Add.h"



@implementation UIView (SS_Add)

- (CGSize)ss_size {
    return self.frame.size;
}

- (void)setSs_size:(CGSize)ss_size {
    CGRect frame = self.frame;
    frame.size = ss_size;
    self.frame = frame;
}

- (CGPoint)ss_origin {
    return self.frame.origin;
}
- (void)setSs_origin:(CGPoint)ss_origin {
    CGRect frame = self.frame;
    frame.origin = ss_origin;
    self.frame = frame;
}
- (CGPoint)ss_center {
    return self.center;
}
- (void)setSs_center:(CGPoint)ss_center {
    self.center = ss_center;
}

- (CGFloat)ss_centerX {
    return self.ss_center.x;
}
- (void)setSs_centerX:(CGFloat)ss_centerX {
    CGPoint center = self.ss_center;
    center.x = ss_centerX;
    self.center = center;
}

- (CGFloat)ss_centerY {
    return self.ss_center.y;
}
- (void)setSs_centerY:(CGFloat)ss_centerY {
    CGPoint center = self.ss_center;
    center.y = ss_centerY;
    self.center = center;
}


- (CGFloat)ss_x {
    return CGRectGetMinX(self.frame);
}

- (void)setSs_x:(CGFloat)ss_x {
    CGPoint origin = self.ss_origin;
    origin.x = ss_x;
    self.ss_origin = origin;
}

- (CGFloat)ss_y {
    return CGRectGetMinY(self.frame);
}

- (void)setSs_y:(CGFloat)ss_y {
    CGPoint origin = self.ss_origin;
    origin.y = ss_y;
    self.ss_origin = origin;
}

- (CGFloat)ss_w {
    return CGRectGetWidth(self.frame);
}

- (void)setSs_w:(CGFloat)ss_w {
    CGSize size = self.ss_size;
    size.width = ss_w;
    self.ss_size = size;
}

- (CGFloat)ss_h {
    return CGRectGetHeight(self.frame);
}

- (void)setSs_h:(CGFloat)ss_h {
    CGSize size = self.ss_size;
    size.height = ss_h;
    self.ss_size = size;
}





@end
