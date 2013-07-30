//
//  LVISlideContentController.m
//  LVISlideContentController
//
//  Created by Luke Van In on 2013/07/23.
//  Copyright (c) 2013 Luke Van In. All rights reserved.
//

#import "LVISlideMenuController.h"

#define defaultSideViewSize 260
#define defaultSnapThreshold 60

typedef enum {
    centerViewState,
    leftViewState,
    rightViewState
} ViewStateEnum;


@interface UIResponder (FirstResponder)

+ (id)currentFirstResponder;
- (void)findFirstResponder:(id)sender;

@end

static __weak id currentFirstResponder;

@implementation UIResponder (FirstResponder)

+ (id)currentFirstResponder {
    currentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    return currentFirstResponder;
}

- (void)findFirstResponder:(id)sender {
    currentFirstResponder = self;
}

@end

@interface LVISlideMenuController ()

@property (nonatomic, assign, readonly) ViewStateEnum viewState;
@property (nonatomic, assign) CGPoint panOffset;
@property (nonatomic, assign, readonly) CGFloat edgeInset;
@property (nonatomic, strong) UIButton * mainButton;

@end

@implementation LVISlideMenuController

@synthesize mainView = _mainView;
@synthesize leftView = _leftView;
@synthesize rightView = _rightView;

- (void)showLeftView:(BOOL)animated
{
    [self setViewState:leftViewState animated:animated];
}

- (void)showMainView:(BOOL)animated
{
    [self setViewState:centerViewState animated:animated];
}

- (void)showRightView:(BOOL)animated
{
    [self setViewState:rightViewState animated:animated];
}

- (void)toggleLeftView:(BOOL)animated
{
    if (self.viewState == leftViewState) {
        [self setViewState:centerViewState animated:YES];
    }
    else
    {
        [self setViewState:leftViewState animated:YES];
    }
}

- (void)toggleRightView:(BOOL)animated
{
    if (self.viewState == rightViewState) {
        [self setViewState:centerViewState animated:YES];
    }
    else
    {
        [self setViewState:rightViewState animated:YES];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _viewState = centerViewState;
        self.sideViewSize = defaultSideViewSize;
        self.snapThreshold = defaultSnapThreshold;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.frame = self.view.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rightView.autoresizesSubviews = YES;
    self.rightView.backgroundColor = [UIColor blackColor];
    self.rightView.opaque = YES;
    self.rightView.frame = self.view.bounds;
    
    self.leftView.autoresizesSubviews = YES;
    self.leftView.backgroundColor = [UIColor blackColor];
    self.leftView.opaque = YES;
    self.leftView.frame = self.view.bounds;
    
    self.mainView.autoresizesSubviews = YES;
    self.mainView.backgroundColor = [UIColor blackColor];
    self.mainView.opaque = YES;
    self.mainView.frame = self.view.bounds;
    [self.mainView addSubview:self.mainButton];
    
    [self.view addSubview:self.mainView];
    [self updateLayout];
    [self updateViewStateAnimated:NO];
    
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mainViewPanned:)];
    [self.mainView addGestureRecognizer:panGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateLayout];
    [self updateViewStateAnimated:NO];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateLayout];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateLayout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateLayout
{
    CGRect mainViewFrame = self.mainView.frame;
    mainViewFrame.size = self.view.bounds.size;
    self.mainView.frame = mainViewFrame;
    self.mainViewController.view.frame = CGRectMake(0, 0, mainViewFrame.size.width, mainViewFrame.size.height);
    
    CGRect leftViewFrame = self.leftView.frame;
    leftViewFrame = CGRectMake(0, 0, defaultSideViewSize, self.view.bounds.size.height);
    self.leftView.frame = leftViewFrame;
    self.leftViewController.view.frame = CGRectMake(0, 0, leftViewFrame.size.width, leftViewFrame.size.height);
    
    CGRect rightViewFrame = self.rightView.frame;
    rightViewFrame = CGRectMake(self.edgeInset, 0, defaultSideViewSize, self.view.bounds.size.height);
    self.rightView.frame = rightViewFrame;
    self.rightViewController.view.frame = CGRectMake(0, 0, rightViewFrame.size.width, rightViewFrame.size.height);
    
    self.mainButton.frame = self.view.bounds;
//    [self updateViewStateAnimated:NO];
}

- (void)leftMenuButtonTapped
{
    [self toggleLeftView:YES];
}

- (void)rightMenuButtonTapped
{
    [self toggleRightView:YES];
}

- (void)mainViewPanned:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint offset = self.mainView.frame.origin;
        [self beginMainViewPan:offset];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint offset = [gesture translationInView:self.view];
        [self updateMainViewPan:offset];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded) {
        [self endMainViewPan];
    }
}

- (void)beginMainViewPan:(CGPoint)offset
{
    [[UIResponder currentFirstResponder] resignFirstResponder];
    self.panOffset = offset;
    [self updateMainViewPan:CGPointMake(0, 0)];
}

- (void)updateMainViewPan:(CGPoint)offset
{
    CGFloat x = self.panOffset.x + offset.x;
    
    if (!self.leftViewController) {
        x = fminf(x, 0);
    }
    
    if (!self.rightViewController) {
        x = fmaxf(x, 0);
    }
    
    x = fminf(x, self.sideViewSize);
    x = fmaxf(x, -self.sideViewSize);
    
    CGRect frame = self.mainView.frame;
    frame.origin.x = x;
    self.mainView.frame = frame;
    
    if (x < 0) {
        [self showRightView];
    }
    else if (x > 0) {
        [self showLeftView];
    }
    else {
        [self hideSideViews];
    }
}

- (void)endMainViewPan
{
    // FIXME: sliding an open view off the screen should keep the view open (currently slides closed)
    CGRect mainViewFrame = self.mainView.frame;
    CGFloat leftEdge = mainViewFrame.origin.x;
    CGFloat rightEdge = mainViewFrame.origin.x + mainViewFrame.size.width;
    
    CGRect viewBounds = self.mainView.superview.bounds;
    
    CGFloat leftBoundary = 0;
    CGFloat rightBoundary = viewBounds.size.width;
    
    ViewStateEnum state = centerViewState;
    
    if (leftEdge > leftBoundary) {
        CGFloat leftThreshold = self.snapThreshold;
        
        if ((self.viewState != leftViewState) && (leftEdge > leftThreshold)) {
            state = leftViewState;
        }
    }
    else if (rightEdge < rightBoundary) {
        CGFloat rightThreshold = viewBounds.size.width - self.snapThreshold;
        
        if ((self.viewState != rightViewState) && (rightEdge < rightThreshold)) {
            state = rightViewState;
        }
    }
    
    [self setViewState:state animated:YES];
}

- (void)setViewState:(ViewStateEnum)viewState animated:(BOOL)animated
{
    [[UIResponder currentFirstResponder] resignFirstResponder];
    _viewState = viewState;
    [self updateViewStateAnimated:animated];
}

- (void)updateViewStateAnimated:(BOOL)animated
{
    switch (self.viewState) {
        case leftViewState:
            [self showLeftViewState:animated];
            break;
            
        case rightViewState:
            [self showRightViewState:animated];
            break;
            
        case centerViewState:
            [self showCenterViewState:animated];
            break;
            
        default:
            NSLog(@"LVISlideContentController -> Unknown view state -> %@", @(self.viewState));
    }
}

- (void)showLeftViewState:(BOOL)animated
{
    [self updateMainViewButton];
    [self showLeftView];
    
    CGFloat position = self.view.bounds.size.width - self.edgeInset;
    [self moveMainView:position animated:animated completion:nil];
}

- (void)showRightViewState:(BOOL)animated
{
    [self updateMainViewButton];
    [self showRightView];
    
    CGFloat position = -self.mainView.frame.size.width + self.edgeInset;
    [self moveMainView:position animated:animated completion:nil];
}

- (void)showCenterViewState:(BOOL)animated
{
    [self updateMainViewButton];
    
    CGFloat position = 0;
    [self moveMainView:position animated:animated completion:^{
        [self hideSideViews];
    }];
}

- (void)showLeftView
{
    [self.view addSubview:self.leftView];
    [self.rightView removeFromSuperview];
    [self.view sendSubviewToBack:self.leftView];
}

- (void)showRightView
{
    [self.view addSubview:self.rightView];
    [self.leftView removeFromSuperview];
    [self.view sendSubviewToBack:self.rightView];
}

- (void)hideSideViews
{
    [self.leftView removeFromSuperview];
    [self.rightView removeFromSuperview];
}

- (void)moveMainView:(CGFloat)position animated:(BOOL)animated completion:(void (^)(void))completion
{
    CGRect frame = self.mainView.frame;
    frame.origin.x = position;
    
    CGFloat duration = animated ? 0.25 : 0.0;
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.mainView.frame = frame;
                     }
                     completion:^(BOOL completed) {
                         if (completed && completion) {
                             completion();
                         }
                     }];
}

- (CGFloat)edgeInset
{
    return self.view.bounds.size.width - self.sideViewSize;
}

- (void)showMainViewController:(UIViewController *)mainViewController animated:(BOOL)animated
{
    self.mainViewController = mainViewController;
    [self setViewState:centerViewState animated:animated];
}

- (void)setMainViewController:(UIViewController *)mainViewController
{
    if (mainViewController == _mainViewController) {
        return;
    }
    
    if (_mainViewController) {
        [_mainViewController removeFromParentViewController];
        [_mainViewController.view removeFromSuperview];
    }
    
    _mainViewController = mainViewController;
    
    if (_mainViewController) {
        [self addChildViewController:_mainViewController];
        [self.mainView addSubview:_mainViewController.view];
    }
    
    [self updateLayout];
    [self updateMainViewButton];
}

- (void)setLeftViewController:(UIViewController *)leftViewController
{
    if (leftViewController == _leftViewController) {
        return;
    }
    
    if (_leftViewController) {
        [_leftViewController removeFromParentViewController];
        [_leftViewController.view removeFromSuperview];
    }
    
    _leftViewController = leftViewController;
    
    if (_leftViewController) {
        [self addChildViewController:leftViewController];
        [self.leftView addSubview:leftViewController.view];
    }
    
    [self updateLayout];
}

- (void)setRightViewController:(UIViewController *)rightViewController
{
    if (rightViewController == _rightViewController) {
        return;
    }
    
    if (_rightViewController) {
        [_rightViewController removeFromParentViewController];
        [_rightViewController.view removeFromSuperview];
    }
    
    _rightViewController = rightViewController;
    
    if (_rightViewController) {
        [self addChildViewController:rightViewController];
        [self.rightView addSubview:rightViewController.view];
    }
    
    [self updateLayout];
}

- (void)updateMainViewButton
{
    if (self.viewState == centerViewState) {
        [self hideMainButton];
    }
    else {
        [self showMainButton];
    }
}

- (void)showMainButton
{
    [self.mainView addSubview:self.mainButton];
    self.mainButton.frame = self.view.bounds;
    [self.mainView bringSubviewToFront:self.mainButton];
}

- (void)hideMainButton
{
    [self.mainButton removeFromSuperview];
}

- (UIButton *)mainButton
{
    if (_mainButton) {
        return _mainButton;
    }
    
    _mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _mainButton.frame = CGRectMake(0, 0, 320, 568);
    _mainButton.backgroundColor = [UIColor clearColor];
//    _mainButton.backgroundColor = [UIColor magentaColor];
    _mainButton.opaque = NO;
    _mainButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_mainButton addTarget:self action:@selector(selectMainView) forControlEvents:UIControlEventTouchUpInside];
    return _mainButton;
}

- (void)selectMainView
{
    [self showMainView:YES];
}

- (UIView *)mainView
{
    if (_mainView) {
        return _mainView;
    }
    
    _mainView = [[UIView alloc] initWithFrame:self.view.bounds];
    return _mainView;
}

- (UIView *)leftView
{
    if (_leftView) {
        return _leftView;
    }
    
    _leftView = [[UIView alloc] initWithFrame:self.view.bounds];
    return _leftView;
}

- (UIView *)rightView
{
    if (_rightView) {
        return _rightView;
    }
    
    _rightView = [[UIView alloc] initWithFrame:self.view.bounds];
    return _rightView;
}

@end
