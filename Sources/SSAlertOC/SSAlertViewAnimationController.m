//
//  SSAlertViewAnimationController.m
//  HiNovel
//
//  Created by yangsq on 2020/8/21.
//

#import "SSAlertViewAnimationController.h"
#import "SSAlertView.h"

@interface SSAlertViewAnimationController ()
@property(nonatomic, assign) BOOL isDismiss;
@end
@implementation SSAlertViewAnimationController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.isDismiss) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    [super dismissViewControllerAnimated:flag completion:completion];
    self.isDismiss = YES;
}

@end
