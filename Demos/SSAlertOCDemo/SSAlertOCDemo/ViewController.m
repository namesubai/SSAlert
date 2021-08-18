//
//  ViewController.m
//  SSAlertOCDemo
//
//  Created by yangsq on 2021/8/12.
//

#import "ViewController.h"
#import <SSAlert/SSAlert.h>
#import <Masonry/Masonry.h>



@interface CustomView : UIView

@end

@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.yellowColor;
        self.frame = CGRectMake(0, 0, 200, 200);
        UILabel *label1 = [[UILabel alloc]init];
        label1.text = @"frame布局挣开";
        [self addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@50);
            make.centerX.equalTo(self);
        }];
    }
    return self;
}

@end


@interface AutoLayoutCustomView : UIView

@end

@implementation AutoLayoutCustomView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.yellowColor;
        UILabel *label1 = [[UILabel alloc]init];
        label1.text = @"自动布局挣开";
        label1.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
            make.width.height.equalTo(@200).priorityHigh();
        }];

    }
    return self;
}
@end

@interface ViewController ()
@property(nonatomic, strong) NSArray<NSString *> *titles;
@property(nonatomic, strong) NSArray<NSString *> *actions;
@property(nonatomic, assign) BOOL isModalPresent;
@property(nonatomic, assign) BOOL isAutoLayoutCustom;
@property(nonatomic, strong) SSAlertView *alertView;
@property(nonatomic, strong) UIView *customView;
@property(nonatomic, strong) UILabel *sizeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"SSAlertOCDemo";

    self.titles = @[@"From Top",
                    @"From Bottom",
                    @"From Left",
                    @"From Right",
                    @"From Center",
                    @"自定义alert，类似系统UIAlertView",
                    @"自定义ActionSheet，类似系统ActionSheet",
                    @"使用自带的SSAlertCommonView自定义"];
    self.actions = @[NSStringFromSelector(@selector(fromTop)),
                     NSStringFromSelector(@selector(fromBottom)),
                     NSStringFromSelector(@selector(fromLeft)),
                     NSStringFromSelector(@selector(fromRight)),
                     NSStringFromSelector(@selector(fromCenter)),
                     NSStringFromSelector(@selector(commonAlertView)),
                     NSStringFromSelector(@selector(commonActionSheet)),
                     NSStringFromSelector(@selector(customAlertCommonView))];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle: @"Settings" style:UIBarButtonItemStylePlain target:self action:@selector(showSettingView)];
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(self.actions[indexPath.row])];
#pragma clang diagnostic pop
}


- (void)fromTop {
    [self showAlertView:SSAlertDefaultAnimationTopState];
}

- (void)fromBottom {
    [self showAlertView:SSAlertDefaultAnimationBottomState];
}

- (void)fromLeft {
    [self showAlertView:SSAlertDefaultAnimationLeftState];
}

- (void)fromRight {
    [self showAlertView:SSAlertDefaultAnimationRightState];
}

- (void)fromCenter {
    [self showAlertView:SSAlertDefaultAnimationCenterState];
}


- (void)commonAlertView {
    if (self.isModalPresent) {
        SSAlertView *alertView = [SSAlertView modalAlertViewWithType: SSAlertActionAlertType title:@"自定义Alert弹窗" message:@"自带自定义Alert弹窗，类似系统的UIAlertView" cancelButton:@"取消" otherButtons:@[@"确定"] fromController:self navigationViewControllerClass:UINavigationController.class clickAction:^(NSInteger index) {
            NSLog(@"%ld", (long)index);
        }];
        
        [alertView show: true];
    } else {
        SSAlertView *alertView = [SSAlertView alertViewWithType: SSAlertActionAlertType title:@"自定义Alert弹窗" message:@"自带自定义Alert弹窗，类似系统的UIAlertView" cancelButton:@"取消" otherButtons:@[@"确定"] onView:self.navigationController.view clickAction:^(NSInteger index) {
            NSLog(@"%ld", (long)index);
        }];
        [alertView show: true];
    }
    
}

- (void)customAlertCommonView {
    SSAlertAction *action1 = [[SSAlertAction alloc]initWithType:SSAlertActionSheetType];
    action1.height = 80;
    action1.title = @"自定义Action1";
    action1.titleColor = UIColor.redColor;
    action1.titleFont = [UIFont systemFontOfSize:18];
    action1.backgroundColor = UIColor.yellowColor;
    [action1 setAddAction:^{
        NSLog(@"点击了Action1");
    }];
    
    SSAlertAction *action2 = [[SSAlertAction alloc]initWithType:SSAlertActionSheetType];
    action2.height = 40;
    action2.title = @"自定义Action2";
    action2.titleColor = UIColor.yellowColor;
    action2.titleFont = [UIFont systemFontOfSize:22];
    action2.backgroundColor = UIColor.redColor;
    [action2 setAddAction:^{
        NSLog(@"点击了Action2");
    }];
    SSAlertCommonView *commonView = [[SSAlertCommonView alloc]initWithTitle: @"标题自定义SSAlertCommonView" message: @"文本文本文本文本文本文本" viewType: SSAlertActionSheetType actions:@[action1, action2]];
    commonView.backgroundColor = UIColor.whiteColor;
    SSAlertView *alertView = [[SSAlertView alloc]initWithCustomView:commonView onView:self.navigationController.view masktype:SSAlertBackgroundMaskTypeBlack];
    SSAlertDefaultAnimation *animation = [[SSAlertDefaultAnimation alloc]initWithState: SSAlertDefaultAnimationBottomState];
    alertView.animation = animation;
    [alertView show: true];
}

- (void)commonActionSheet {
    if (self.isModalPresent) {
        SSAlertView *alertView = [SSAlertView modalAlertViewWithType:SSAlertActionSheetType title:@"自定义ActionSheet弹窗" message:@"自带自定义ActionSheet弹窗，类似系统的ActionSheet" cancelButton:@"取消" otherButtons:@[@"action1", @"action2", @"action3", @"action4"] fromController:self navigationViewControllerClass:UINavigationController.class clickAction:^(NSInteger index) {
            NSLog(@"%ld", (long)index);
        }];
        [alertView show: true];
    } else {
        SSAlertView *alertView = [SSAlertView alertViewWithType:SSAlertActionSheetType title:@"自定义ActionSheet弹窗" message:@"自带自定义ActionSheet弹窗，类似系统的ActionSheet" cancelButton:@"取消" otherButtons:@[@"action1", @"action2", @"action3", @"action4"] onView:self.navigationController.view clickAction:^(NSInteger index) {
            NSLog(@"%ld", (long)index);
        }];
        [alertView show: true];
    }
    
}

- (void)modalPresentSwitch:(UISwitch *)s {
    self.isModalPresent = s.on;
}

- (void)autolayoutSwitch:(UISwitch *)s {
    self.isAutoLayoutCustom = s.on;
}

- (void)showSettingView {
    UIView *customView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300)];
    customView.backgroundColor = UIColor.yellowColor;
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"模态视图弹窗";
    [customView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(30);
    }];
    
    UISwitch *swith1 = [[UISwitch alloc]init];
    [swith1 setOn:self.isModalPresent];
    [customView addSubview:swith1];
    [swith1 addTarget:self action:@selector(modalPresentSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [swith1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(20);
        make.centerY.equalTo(label1);
    }];
    
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"自动布局custom";
    [customView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.equalTo(label1.mas_bottom).offset(15);
    }];
    
    UISwitch *swith2 = [[UISwitch alloc]init];
    [swith2 setOn:self.isAutoLayoutCustom];
    [swith2 addTarget:self action:@selector(autolayoutSwitch:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:swith2];
    [swith2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(20);
        make.centerY.equalTo(label2);
    }];
    
    SSAlertView * alertView = [[SSAlertView alloc]initWithCustomView:customView onView:self.view masktype:SSAlertBackgroundMaskTypeBlack];
    SSAlertDefaultAnimation *animation = [[SSAlertDefaultAnimation alloc]initWithState:SSAlertDefaultAnimationBottomState];
    alertView.animation = animation;
    [alertView show: true];
}


- (void)showAlertView:(SSAlertDefaultAnimationState)type {
    
    UIView * customView = [CustomView new];
    if (self.isAutoLayoutCustom) {
        customView = [[AutoLayoutCustomView alloc]init];
    }
    
    if (self.isModalPresent) {
        UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [pushButton setTitle: @"push" forState:UIControlStateNormal];
        [pushButton addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:pushButton];
        [pushButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(customView);
        }];
        _alertView = [[SSAlertView alloc]initWithCustomView:customView
                                               fromViewController:self
                                        navigationControllerClass:UINavigationController.class
                                                         masktype: SSAlertBackgroundMaskTypeBlack
                                                     canPanDimiss:true];
        
    } else {
        _alertView = [[SSAlertView alloc]initWithCustomView:customView onView:self.navigationController.view masktype:SSAlertBackgroundMaskTypeBlack];
    }
    
    _sizeLabel = [UILabel new];
    _sizeLabel.text = @"200";
    [customView addSubview:_sizeLabel];
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
    }];
    
    UISlider *slider = [[UISlider alloc]init];
    slider.minimumValue = 200;
    slider.maximumValue = self.view.frame.size.width;
    [customView addSubview:slider];
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sizeLabel.mas_bottom).offset(15);
        make.bottom.offset(-40);
        make.left.offset(20);
        make.right.offset(-20).priorityLow();
        make.height.offset(20).priorityLow();
    }];
    
    self.customView = customView;
    SSAlertDefaultAnimation *animation = [[SSAlertDefaultAnimation alloc]initWithState:type];
    _alertView.animation = animation;
    [_alertView show: true];
    
}

- (void)sliderAction: (UISlider *)slider {
    _sizeLabel.text = [NSString stringWithFormat:@"%f", slider.value];
    self.customView.ss_w = slider.value;
    self.customView.ss_h = slider.value;
    [self.alertView refreshFrame: false];
}

- (void)pushAction {
    [_alertView.navigationController pushViewController:[ViewController new] animated:true];
}

@end


