//
//  SSAlertCommonView.m
//  SSAlertView
//
//  Created by yangsq on 2020/1/14.
//  Copyright © 2020 yangsq. All rights reserved.
//

#import "SSAlertCommonView.h"
#import "UIView+SS_Add.h"

#define kAlertViewScreenWidth           [UIScreen mainScreen].bounds.size.width
#define kAlertViewScreenHeight          [UIScreen mainScreen].bounds.size.height
#define kAlertViewMaxWidth              kAlertViewScreenWidth * 0.7
#define kActionSheetViewMaxWidth        kAlertViewScreenWidth


static const CGFloat kAlertViewButtonHeight = 50;
static const CGFloat kActionSheetButtonHeight = 55;

CGFloat kSafeAreaBottomHeight(void) {
    CGFloat bottomHeight = 0;
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
        bottomHeight = mainWindow.safeAreaInsets.bottom;

    }
    
    return bottomHeight;
}

@interface SSAlertAction ()
@property (nonatomic, assign) SSAlertActionType type;

@end

@implementation SSAlertAction
- (instancetype)initWithType:(SSAlertActionType)type {
    self = [super init];
    if (self) {
        self.type = type;
        self.height = type == SSAlertActionAlertType ? kAlertViewButtonHeight : kActionSheetButtonHeight;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithType: SSAlertActionAlertType];
}

@end


@interface SSAlertCommonView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSMutableArray <SSAlertAction *> *actionArray;
@property (nonatomic, strong) NSMutableArray <UIButton *> *buttonArray;
@property (nonatomic, strong) NSMutableArray <UIView *> *lineArray;
@property (nonatomic, assign) SSAlertActionType viewtype;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL hasText;

@end

@implementation SSAlertCommonView

- (id)initWithTitle:(NSString * __nullable)title
            message:(NSString * __nullable)message
           viewType:(SSAlertActionType)viewType
            actions:(NSArray <SSAlertAction *> *)actions {
    
    if (self = [super initWithFrame:CGRectZero]) {
        self.viewtype = viewType;
        self.actionArray = actions.mutableCopy;
        _containerView = [UIView new];
        [self addSubview:_containerView];
        _hasText = false;
        if (title.length) {
            _titleLabel = [UILabel new];
            _titleLabel.font = [UIFont systemFontOfSize:16];
            _titleLabel.numberOfLines = 0;
            _titleLabel.textAlignment = NSTextAlignmentCenter;
            _titleLabel.text = title;
            [_containerView addSubview:_titleLabel];
            _hasText = true;
        }
        
        if (message.length) {
            _messageLabel = [UILabel new];
            _messageLabel.font = [UIFont systemFontOfSize:14];
            _messageLabel.numberOfLines = 0;
            _messageLabel.textAlignment = NSTextAlignmentCenter;
            _messageLabel.text = message;
            [_containerView addSubview:_messageLabel];
            _hasText = true;
        }
        
        
        if (actions.count) {
            _buttonView = [[UIView alloc]init];
            [self addSubview:_buttonView];
            
            _buttonArray = @[].mutableCopy;
            _lineArray = @[].mutableCopy;

            [actions enumerateObjectsUsingBlock:^(SSAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                [button setTitle:obj.title forState:UIControlStateNormal];
                [button setBackgroundColor:self.backgroundColor];
                if (obj.backgroundColor != nil) {
                    button.backgroundColor = obj.backgroundColor;
                }
                button.titleLabel.font = obj.titleFont;
                [button setTitleColor:obj.titleColor forState:UIControlStateNormal];
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                [_buttonView addSubview:button];
                [_buttonArray addObject:button];
                BOOL isAddLineView = false;
                if (viewType == SSAlertActionSheetType) {
                    if (_hasText) {
                        isAddLineView = true;
                    } else {
                        if (idx != actions.count - 1) {
                            isAddLineView = true;
                        }
                    }
                } else {
                    if (actions.count > 2) {
                        if (_hasText) {
                            isAddLineView = true;
                        } else {
                            if (idx != actions.count - 1) {
                                isAddLineView = true;
                            }
                        }
                    } else {
                        if (actions.count == 1) {
                            if (_hasText) {
                                isAddLineView = true;
                            } 
                        } else {
                            if (_hasText) {
                                isAddLineView = true;
                            } else {
                                if (idx != actions.count - 1) {
                                    isAddLineView = true;
                                }
                            }
                        }
                    }
                    
                   
                }
                if (isAddLineView) {
                    UIView *lineView = UIView.new;
                    lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
                    [_buttonView addSubview:lineView];
                    [_lineArray addObject:lineView];
                }
            }];
            
        }
        

        [self refreshFrame];
    }
    
    return self;
}

- (void)setLineColor:(UIColor *)lineColor {
    [_lineArray enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = lineColor;
    }];
}

- (void)setLineEdgeInsets:(UIEdgeInsets)lineEdgeInsets {
    _lineEdgeInsets = lineEdgeInsets;
    [self refreshFrame];
}

- (void)refreshFrame {
    CGFloat space = 15;
    CGFloat viewMaxWidth = self.viewtype == SSAlertActionAlertType? kAlertViewMaxWidth:kActionSheetViewMaxWidth;
    CGFloat height = 0, width = viewMaxWidth,containerWidth = viewMaxWidth - space * 2;
    CGFloat originY = 0;
    
    CGFloat cotainerOriginY = 0;
    if (self.titleLabel) {
        CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(containerWidth, MAXFLOAT)];
        self.titleLabel.ss_origin = CGPointMake(0,cotainerOriginY);
        self.titleLabel.ss_size = CGSizeMake(containerWidth, titleSize.height);
        height += titleSize.height + space;
        cotainerOriginY += space + titleSize.height;
        originY = space;
    }
    if (self.messageLabel) {
        CGSize messageSize = [self.messageLabel sizeThatFits:CGSizeMake(containerWidth, MAXFLOAT)];
        self.messageLabel.ss_origin = CGPointMake(0, cotainerOriginY);
        self.messageLabel.ss_size = CGSizeMake(containerWidth, messageSize.height);;
        height += messageSize.height + space;
        originY = space;
    }
    
    self.containerView.ss_origin = CGPointMake(space, originY);
    self.containerView.ss_size = CGSizeMake(containerWidth, height);
    originY += height;

    
    if (self.buttonArray.count) {
        CGFloat buttonSpace = 0.5;
        CGFloat button_total_height = 0;
        __block CGFloat buttonTopY = 0;
        
        if (self.viewtype == SSAlertActionSheetType) {
            [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SSAlertAction *action = self.actionArray[idx];
                if (self.lineArray.count == self.buttonArray.count) {
                    UIView *lineview = [_lineArray objectAtIndex:idx];
                    lineview.frame = CGRectMake(_lineEdgeInsets.left, buttonTopY, width - _lineEdgeInsets.left - _lineEdgeInsets.right, buttonSpace);
                    buttonTopY += buttonSpace;
                }
                
                if (self.lineArray.count == self.buttonArray.count - 1) {
                    if (idx < self.lineArray.count) {
                        UIView *lineview = [_lineArray objectAtIndex:idx];
                        lineview.frame = CGRectMake(_lineEdgeInsets.left, buttonTopY + action.height, width - _lineEdgeInsets.left - _lineEdgeInsets.right, buttonSpace);
                        buttonTopY += buttonSpace;
                    }
                }
                
                if (idx == self.buttonArray.count - 1) {
                    obj.ss_size = CGSizeMake(width, action.height + kSafeAreaBottomHeight());
                    obj.titleEdgeInsets = UIEdgeInsetsMake(-kSafeAreaBottomHeight(), 0, 0, 0);
                }else {
                    obj.ss_size = CGSizeMake(width, action.height);
                }
                obj.ss_origin = CGPointMake(0, buttonTopY);
                buttonTopY += obj.ss_h;
             }];
           
            button_total_height = buttonTopY;
        }
        
        if (self.viewtype == SSAlertActionAlertType) {
            if (self.buttonArray.count > 2) {
                [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    SSAlertAction *action = self.actionArray[idx];
                    if (self.lineArray.count == self.buttonArray.count) {
                        UIView *lineview = [_lineArray objectAtIndex:idx];
                        lineview.frame = CGRectMake(_lineEdgeInsets.left, buttonTopY, width - _lineEdgeInsets.left - _lineEdgeInsets.right, buttonSpace);
                        buttonTopY += buttonSpace;
                    }
                    
                    if (self.lineArray.count == self.buttonArray.count - 1) {
                        if (idx < self.lineArray.count) {
                            UIView *lineview = [_lineArray objectAtIndex:idx];
                            lineview.frame = CGRectMake(_lineEdgeInsets.left, buttonTopY + action.height, width - _lineEdgeInsets.left - _lineEdgeInsets.right, buttonSpace);
                            buttonTopY += buttonSpace;
                        }
                        
                    }
                    
                    obj.ss_origin = CGPointMake(0, buttonTopY);
                    obj.ss_size = CGSizeMake(width, action.height);
                    buttonTopY += obj.ss_h;
                }];
                button_total_height = buttonTopY;

            } else {
                if (self.buttonArray.count == 1) {
                    UIView *button = self.buttonArray.firstObject;
                    SSAlertAction *action = self.actionArray.firstObject;
                    if (self.lineArray.count > 0) {
                        UIView *lineview = self.lineArray.firstObject;
                        lineview.frame = CGRectMake(_lineEdgeInsets.left, buttonTopY, width - _lineEdgeInsets.left - _lineEdgeInsets.right, buttonSpace);
                        buttonTopY += buttonSpace;
                    }
                    
                    button.ss_origin = CGPointMake(0, buttonTopY);
                    button.ss_size = CGSizeMake(width, action.height);
                    button_total_height = buttonTopY;
                } else {
                    UIView *button1 = self.buttonArray.firstObject;
                    UIView *button2 = self.buttonArray.lastObject;
                    SSAlertAction *action1 = self.actionArray.firstObject;
                    SSAlertAction *action2 = self.actionArray.lastObject;
                    CGFloat maxButtonHeight = MAX(action1.height, action2.height);
                    if (self.hasText) {
                        UIView *lineview1 = _lineArray.firstObject;
                        lineview1.frame = CGRectMake(0, buttonTopY, width, buttonSpace);
                        buttonTopY += buttonSpace;
                    }
                    
                    button1.ss_origin = CGPointMake(0, buttonTopY);
                    button1.ss_size = CGSizeMake(width/2.0 - buttonSpace/2.0, maxButtonHeight);
                    button2.ss_origin = CGPointMake(button1.ss_w + buttonSpace, buttonTopY);
                    button2.ss_size = CGSizeMake(width/2.0 - buttonSpace/2.0, maxButtonHeight);
                    
                    UIView *lineview2 = _lineArray.lastObject;
                    lineview2.frame = CGRectMake(CGRectGetMaxX(button1.frame), buttonSpace, buttonSpace, button1.ss_h);
                    buttonTopY += maxButtonHeight;
                }
                button_total_height = buttonTopY;

            }
        }
   
        _buttonView.ss_origin = CGPointMake(0, originY);
        _buttonView.ss_size = CGSizeMake(width, button_total_height);
        height += button_total_height + (originY > 0 ? space : 0);
        
    }
    
    self.ss_size = CGSizeMake(width, height);
}


- (void)layoutSubviews {
    [super layoutSubviews];
  
}


- (void)buttonAction:(UIButton *)button {
    NSInteger index = [self.buttonArray indexOfObject:button];
    SSAlertAction *action = [self.actionArray objectAtIndex:index];
    if (action.addAction) {
        action.addAction();
    }
}



@end
