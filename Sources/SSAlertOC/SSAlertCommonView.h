//
//  SSAlertCommonView.h
//  SSAlertView
//
//  Created by yangsq on 2020/1/14.
//  Copyright © 2020 yangsq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SSAlertActionType) {
    SSAlertActionAlertType,
    SSAlertActionSheetType,
};


@interface SSAlertAction : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign, readonly) SSAlertActionType type;
@property (nonatomic, copy) void(^addAction)(void);
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(SSAlertActionType)type NS_DESIGNATED_INITIALIZER;
@end


@interface SSAlertCommonView : UIView
- (id)initWithTitle:(NSString * __nullable)title
            message:(NSString * __nullable)message
           viewType:(SSAlertActionType)viewType
            actions:(NSArray <SSAlertAction *> *)actions;
@property (nonatomic, strong) UIColor  *lineColor;
@property (nonatomic, assign) UIEdgeInsets lineEdgeInsets;

@end

NS_ASSUME_NONNULL_END
