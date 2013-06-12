//
//  HSStatusBar.h
//  Messigify
//
//  Created by Harinder Singh on 3/10/13.
//  Copyright (c) 2013 iHSApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HSStatusBar;

typedef void (^HSStatusBarBasicBlock)(void);

typedef enum {
    HSStatusBarAnimationTypeNone, /* No animation */
    HSStatusBarAnimationTypeFromTop, /* Element appear from top */
    HSStatusBarAnimationTypeFade /* Element appear with alpha transition */
} HSStatusBarAnimationType;


@interface HSStatusBar : UIWindow {

}


@property (nonatomic, readonly) UIView *contentView;

@property (nonatomic, readonly) UILabel *textLabel; 

@property (nonatomic, readonly) UIActivityIndicatorView *activityView;

@property (nonatomic, assign) HSStatusBarAnimationType animation;

/**
 Block that will be execute if user press the overlay
 */
@property (nonatomic, copy) HSStatusBarBasicBlock actionBlock;

+ (HSStatusBar *)shared;

/**
 Show the overlay on the status bar with a message
 
 @param message Message that will appear on the label
 @param loading Show an activity view
 @param animated Show with an animation
 */
- (void)showWithMessage:(NSString *)message loading:(BOOL)loading animated:(BOOL)animated;

/**
 Show the overlay on the status bar with a message
 
 @param message Message that will appear on the label
 @param animated Show with an animation
 */
- (void)showWithMessage:(NSString *)message animated:(BOOL)animated;

/**
 Show the overlay on the status bar with a message and activity view
 
 @param message Message that will appear on the label
 @param animated Show with an animation
 */
- (void)showLoadingWithMessage:(NSString *)message animated:(BOOL)animated;

/**
 Change the text message
 
 @param message Message that will appear on the label
 @param animated Show the message with an animation
 */
- (void)setMessage:(NSString *)message animated:(BOOL)animated;

/**
 Hide the overlay from status bar
 
 @param animated Hide with an animation
 */
- (void)hideAnimated:(BOOL)animated;

/**
 Hide the overlay from status bar with an animation
 */
- (void)hideAnimated;

/**
 Hide the overlay from status bar without animation
 */
- (void)hide;


/**
 Show the activity view
 
 @param show Show or hide activity
 @param animated Show or hide with an animation
 */
- (void)showActivity:(BOOL)show animated:(BOOL)animated;

/**
 Change the background color from overlay
 
 @param backgroundColor Background color from overlay
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor;

/**
 Change overlay style
 
 @param statusBarStyle @see UIStatusBarStyle
 @param animated Animate status bar style change
 */
- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle animated:(BOOL)animated;

/* Class methods */

+ (void)showWithMessage:(NSString *)message loading:(BOOL)loading animated:(BOOL)animated;

+ (void)showWithMessage:(NSString *)message animated:(BOOL)animated;

+ (void)showLoadingWithMessage:(NSString *)message animated:(BOOL)animated;

+ (void)setMessage:(NSString *)message animated:(BOOL)animated;

+ (void)hideAnimated:(BOOL)animated;

+ (void)hideAnimated;

+ (void)hide;

+ (void)setAnimation:(HSStatusBarAnimationType)animation;

+ (void)showActivity:(BOOL)show animated:(BOOL)animated;

+ (void)setBackgroundColor:(UIColor *)backgroundColor;

+ (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle animated:(BOOL)animated;

+ (void)setActionBlock:(HSStatusBarBasicBlock)actionBlock;


@end
