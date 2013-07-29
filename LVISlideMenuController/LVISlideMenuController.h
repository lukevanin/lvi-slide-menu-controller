//
//  LVISlideContentController.h
//  LVISlideContentController
//
//  Created by Luke Van In on 2013/07/23.
//  Copyright (c) 2013 Luke Van In. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LVISlideMenuController : UIViewController

@property (nonatomic, assign) CGFloat sideViewSize;
@property (nonatomic, assign) CGFloat snapThreshold;

@property (nonatomic, strong) UIView * mainView;
@property (nonatomic, strong) UIView * leftView;
@property (nonatomic, strong) UIView * rightView;

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
