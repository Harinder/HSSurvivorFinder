//
//  HSStatusBar.h
//  Messigify
//
//  Created by Harinder Singh on 3/10/13.
//  Copyright (c) 2013 iHSApps. All rights reserved.
//

#import "HSStatusBar.h"

#import <QuartzCore/QuartzCore.h>

#define ROTATION_ANIMATION_DURATION [UIApplication sharedApplication].statusBarOrientationAnimationDuration
#define STATUS_BAR_HEIGHT CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
#define STATUS_BAR_WIDTH CGRectGetWidth([UIApplication sharedApplication].statusBarFrame)
#define STATUS_BAR_ORIENTATION [UIApplication sharedApplication].statusBarOrientation
#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

#define TEXT_LABEL_FONT [UIFont boldSystemFontOfSize:12]

@interface HSStatusBar ()

- (void)animatateview:(UIView *)view show:(BOOL)show completion:(HSStatusBarBasicBlock)completion;

- (void)animatateview:(UIView *)view
    withAnimationType:(HSStatusBarAnimationType)animationType
                 show:(BOOL)show
           completion:(HSStatusBarBasicBlock)completion;

- (void)fromTopAnimatateview:(UIView *)view show:(BOOL)show completion:(HSStatusBarBasicBlock)completion;

- (void)fadeAnimatateview:(UIView *)view show:(BOOL)show completion:(HSStatusBarBasicBlock)completion;

- (void)initializeToDefaultState;

- (void)rotateStatusBarWithFrame:(NSValue *)frameValue;

- (void)rotateStatusBarAnimatedWithFrame:(NSValue *)frameValue;

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle;

@end

@implementation HSStatusBar

@synthesize activityView = _activityView;
@synthesize textLabel    = _textLabel;
@synthesize animation    = _animation;
@synthesize actionBlock  = _actionBlock;
@synthesize contentView  = _contentView;


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+ (HSStatusBar *)shared {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}


- (id)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.animation = HSStatusBarAnimationTypeFade;
        
        BOOL isPortrait = UIDeviceOrientationIsPortrait(STATUS_BAR_ORIENTATION);
        CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
        CGFloat statusBarHeight = (isPortrait) ? statusBarFrame.size.height : statusBarFrame.size.width;
        CGFloat statusBarWidth = (isPortrait) ? statusBarFrame.size.width : statusBarFrame.size.height;
        
        self.frame = CGRectMake(0, 0, statusBarWidth, statusBarHeight);
        
        _contentView = [[UIView alloc] initWithFrame:self.frame];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.contentView];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityView.frame = CGRectMake((statusBarWidth / 2) - (10 * 5), 4, statusBarHeight - 4 * 2, statusBarHeight - 4 * 2);
        self.activityView.hidesWhenStopped = YES;
        
        if ([self.activityView respondsToSelector:@selector(setColor:)]) { // IOS5 or greater
            [self.activityView.layer setValue:@0.7f forKeyPath:@"transform.scale"];
        }
        
        [self.contentView addSubview:self.activityView];
        
            
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabel.frame = CGRectMake(CGRectGetWidth(self.activityView.frame) + 10,
                                          0,
                                          statusBarWidth - (CGRectGetWidth(self.activityView.frame) * 2) - (10 * 2),
                                          statusBarHeight);
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = TEXT_LABEL_FONT;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.textLabel];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPressOnView:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willRotateScreen:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification object:nil];
        
        self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self initializeToDefaultState];
    }
    
    return self;
}



#pragma mark -
#pragma mark Public

- (void)showWithMessage:(NSString *)message animated:(BOOL)animated {
    [self showWithMessage:message loading:NO animated:animated];
}

- (void)showLoadingWithMessage:(NSString *)message animated:(BOOL)animated {
    [self showWithMessage:message loading:YES animated:animated];
}


- (void)showWithMessage:(NSString *)message loading:(BOOL)loading animated:(BOOL)animated {
   
        [self initializeToDefaultState];
        self.textLabel.text = message;
    
        CGSize textSize = [message sizeWithFont:[self.textLabel font]];
    
        CGRect statusLabelFrame = self.textLabel.frame;
        statusLabelFrame.size.width = textSize.width;
   
        if (_activityView.isAnimating) {
            statusLabelFrame.origin.x += 10;
        }
    
        _textLabel.frame = statusLabelFrame;
        _textLabel.center = _contentView.center;
    
        CGRect activityFrame = _activityView.frame;
        activityFrame.origin.x = CGRectGetMinX(_textLabel.frame) - 20;
        _activityView.frame = activityFrame;
    
        self.hidden = NO;
   
        if (YES == loading) {
            [self.activityView startAnimating];
        } else {
            [self.activityView stopAnimating];
        }
        
        if (animated) {
            [self animatateview:self.contentView show:YES completion:nil];
        }
   
}


- (void)setMessage:(NSString *)message animated:(BOOL)animated {
    if (animated) {
        [self animatateview:self.textLabel show:NO completion:^{
            self.textLabel.text = message;
            [self animatateview:self.textLabel show:YES completion:nil];
        }];
    } else {
        self.textLabel.text = message;
    }
}


- (void)showActivity:(BOOL)show animated:(BOOL)animated {
    if (show) {
        [self.activityView startAnimating];
    } else if (NO == animated) {
        [self.activityView stopAnimating];
    }
    
    if (animated) {
        [self animatateview:self.activityView show:show completion:^{
            if (NO == show) {
                [self.activityView stopAnimating];
            }
        }];
    } else {
        self.activityView.hidden = !show;
    }
}


- (void)hideAnimated:(BOOL)animated {
    if (animated) {
        [self animatateview:self.contentView show:NO completion:^{
            self.hidden = YES;
        }];
    } else {
        self.hidden = YES;
    }
}


- (void)hideAnimated {
    [self hideAnimated:YES];
}


- (void)hide {
    [self hideAnimated:NO];
}


- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [self.contentView setBackgroundColor:backgroundColor];
}


- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle animated:(BOOL)animated {
    if (animated) {
        [self animatateview:self.contentView show:NO completion:^{
            [self setStatusBarStyle:statusBarStyle];
            [self animatateview:self.contentView show:YES completion:nil];
        }];
    } else {
        [self setStatusBarStyle:statusBarStyle];
    }
} 



#pragma mark -
#pragma mark Class methods

+ (void)showWithMessage:(NSString *)message loading:(BOOL)loading animated:(BOOL)animated {
    [[HSStatusBar shared] showWithMessage:message loading:loading animated:animated];
}

+ (void)showWithMessage:(NSString *)message animated:(BOOL)animated {
    [[HSStatusBar shared] showWithMessage:message animated:animated];
}

+ (void)showLoadingWithMessage:(NSString *)message animated:(BOOL)animated {
    [[HSStatusBar shared] showLoadingWithMessage:message animated:animated];
}

+ (void)setMessage:(NSString *)message animated:(BOOL)animated {
    [[HSStatusBar shared] setMessage:message animated:animated];
}


+ (void)setAnimation:(HSStatusBarAnimationType)animation {
    [[HSStatusBar shared] setAnimation:animation];
}

+ (void)hideAnimated:(BOOL)animated {
    [[HSStatusBar shared] hideAnimated:animated];
}

+ (void)hideAnimated {
    [[HSStatusBar shared] hideAnimated];
}

+ (void)hide {
    [[HSStatusBar shared] hide];
}


+ (void)showActivity:(BOOL)show animated:(BOOL)animated {
    [[HSStatusBar shared] showActivity:show animated:animated];
}


+ (void)setBackgroundColor:(UIColor *)backgroundColor {
    [[HSStatusBar shared] setBackgroundColor:backgroundColor];
}


+ (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle animated:(BOOL)animated {
    [[HSStatusBar shared] setStatusBarStyle:statusBarStyle animated:animated];
}


+ (void)setActionBlock:(HSStatusBarBasicBlock)actionBlock {
    [[HSStatusBar shared] setActionBlock:actionBlock];
}


#pragma mark -
#pragma mark Gesture recognizer

- (void)didPressOnView:(UIGestureRecognizer *)gestureRecognizer {
    if (nil != _actionBlock) {
        _actionBlock();
    }
}


#pragma mark -
#pragma mark Rotation

- (void)willRotateScreen:(NSNotification *)notification {
    NSValue *frameValue = [notification.userInfo valueForKey:UIApplicationStatusBarFrameUserInfoKey];
    
    if (NO == self.hidden) {
        [self rotateStatusBarAnimatedWithFrame:frameValue];
    } else {
        [self rotateStatusBarWithFrame:frameValue];
    }
}


#pragma mark -
#pragma mark Private


- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    if (UIStatusBarStyleBlackOpaque == statusBarStyle ||
        UIStatusBarStyleBlackTranslucent == statusBarStyle ||
        IS_IPAD) {
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"status-bar-pattern-black.jpg"]]];
        self.textLabel.textColor = [UIColor whiteColor];
        [self.activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        
    } else {
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"status-bar-pattern-default.jpg"]]];
        self.textLabel.textColor = [UIColor colorWithRed:17/255.0f green:17/255.0f blue:17/255.0f alpha:1];
        [self.activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    }
}




////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)rotateStatusBarAnimatedWithFrame:(NSValue *)frameValue {
    [UIView animateWithDuration:ROTATION_ANIMATION_DURATION animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self rotateStatusBarWithFrame:frameValue];
        [UIView animateWithDuration:ROTATION_ANIMATION_DURATION animations:^{
            self.alpha = 1;
        }];
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)rotateStatusBarWithFrame:(NSValue *)frameValue {
    CGRect frame = [frameValue CGRectValue];
    UIInterfaceOrientation orientation = STATUS_BAR_ORIENTATION;
    
    if (UIDeviceOrientationPortrait == orientation) {
        self.transform = CGAffineTransformIdentity;
    } else if (UIDeviceOrientationPortraitUpsideDown == orientation) {
        self.transform = CGAffineTransformMakeRotation(M_PI);
    } else if (UIDeviceOrientationLandscapeRight == orientation) {
        self.transform = CGAffineTransformMakeRotation(M_PI * (-90.0f) / 180.0f);
    } else {
        self.transform = CGAffineTransformMakeRotation(M_PI * 90.0f / 180.0f);
    }
    
    self.frame = frame;
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)animatateview:(UIView *)view show:(BOOL)show completion:(HSStatusBarBasicBlock)completion {
    [self animatateview:view withAnimationType:self.animation show:show completion:completion];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)animatateview:(UIView *)view
    withAnimationType:(HSStatusBarAnimationType)animationType
                 show:(BOOL)show
           completion:(HSStatusBarBasicBlock)completion {
    
    if (HSStatusBarAnimationTypeFade == animationType) {
        [self fadeAnimatateview:view show:show completion:completion];
        
    } else if (HSStatusBarAnimationTypeFromTop == animationType) {
        [self fromTopAnimatateview:view show:show completion:completion];
        
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)fadeAnimatateview:(UIView *)view show:(BOOL)show completion:(HSStatusBarBasicBlock)completion {
    if (show) {
        view.alpha = 0;
        view.hidden = NO;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.alpha = (show) ? 1 : 0;
    } completion:^(BOOL finished) {
        if (NO == show) {
            view.hidden = YES;
            view.alpha = 1;
        }
        
        if (nil != completion)
            completion();
    }];
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)fromTopAnimatateview:(UIView *)view show:(BOOL)show completion:(HSStatusBarBasicBlock)completion {
    __block CGRect frame = view.frame;
    CGFloat previousY = view.frame.origin.y;
    
    if (show) {
        view.hidden = NO;
        view.alpha = 0;
        frame.origin.y = -CGRectGetHeight(self.frame);
        view.frame = frame;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        frame.origin.y += (show ? 1 : -1) * CGRectGetHeight(self.frame);
        view.frame = frame;
        view.alpha = (show) ? 1 : 0;
    } completion:^(BOOL finished) {
        if (NO == show) {
            frame.origin.y = previousY;
            view.frame = frame;
            view.hidden = YES;
            view.alpha = 1;
        }
        
        if (nil != completion)
            completion();
    }];  
}


////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)initializeToDefaultState {
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    [self rotateStatusBarWithFrame:[NSValue valueWithCGRect:statusBarFrame]];
    
    [self setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
}


@end
