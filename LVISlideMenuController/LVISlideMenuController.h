//
//  LVISlideContentController.h
//  LVISlideContentController
//
//  Created by Luke Van In on 2013/07/23.
//  Copyright (c) 2013 Luke Van In. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//@class LVISlideContentController;
//
//@protocol LVISlideContentController
//
//- (UIViewController *)mainViewControllerForSlideViewController:(LVISlideContentController *)slideViewController;
//- (UIViewController *)leftViewControllerForSlideViewController:(LVISlideContentController *)slideViewController;
//- (UIViewController *)rightViewControllerForSlideViewController:(LVISlideContentController *)slideViewController;
//
//@optional
//
//- (void)LVISlideViewController:(LVISlideContentController *)viewController willShowMainView:(BOOL)animated;
//- (void)LVISlideViewController:(LVISlideContentController *)viewController didShowMainView:(BOOL)animated;
//
//- (void)canShowLeftViewForLVISlideViewController:(LVISlideContentController *)viewController;
//- (void)LVISlideViewController:(LVISlideContentController *)viewController willShowLeftView:(BOOL)animated;
//- (void)LVISlideViewController:(LVISlideContentController *)viewController didShowLeftView:(BOOL)animated;
//
//- (void)canShowRightViewForLVISlideViewController:(LVISlideContentController *)viewController;
//- (void)LVISlideViewController:(LVISlideContentController *)viewController willShowRightView:(BOOL)animated;
//- (void)LVISlideViewController:(LVISlideContentController *)viewController didShowRightView:(BOOL)animated;
//
//@end

@interface LVISlideMenuController : UIViewController

@property (nonatomic, assign) CGFloat sideViewSize;
@property (nonatomic, assign) CGFloat snapThreshold;

@property (nonatomic, strong, readonly) UIView * mainView;
@property (nonatomic, strong, readonly) UIView * leftView;
@property (nonatomic, strong, readonly) UIView * rightView;

@property (nonatomic, strong) UIViewController * leftViewController;
@property (nonatomic, strong) UIViewController * rightViewController;
@property (nonatomic, strong) UIViewController * mainViewController;

- (void)showMainViewController:(UIViewController *)mainViewController animated:(BOOL)animated;

- (void)showMainView:(BOOL)animated;
- (void)showLeftView:(BOOL)animated;
- (void)showRightView:(BOOL)animated;
- (void)toggleLeftView:(BOOL)animated;
- (void)toggleRightView:(BOOL)animated;

@end
