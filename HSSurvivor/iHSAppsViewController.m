//
//  iHSAppsViewController.m
//  HSSurvivor
//
//  Created by Harinder Singh on 11/19/12.
//  Copyright (c) 2012 Harinder Singh. All rights reserved.
//

#import "iHSAppsViewController.h"
#import "HSSurvivorManager.h"
#import "HSSurvivorView.h"

#import <QuartzCore/QuartzCore.h>

#define kNavigationTitle @"Survivor Finder"
#define kBackgroundColor [UIColor colorWithRed:230.0/255.0f green:230.0/255.0f  blue:230.0/255.0f  alpha:1];

//#define kShadowColor [UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1.0]

@interface iHSAppsViewController()<HSSurvivorViewDelegate>
{
    HSSurvivorView * _survivorView;
}

@property(nonatomic, strong) HSSurvivorView * survivorView;

@end

@implementation iHSAppsViewController

@synthesize survivorView = _survivorView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    //Initial UI setup of controller
    [self initialSetup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark

-(void)initialSetup
{
    self.view.backgroundColor = kBackgroundColor;
    self.navigationController.navigationBar.tintColor = kBackgroundColor;
    _survivorView = [[HSSurvivorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _survivorView.delegate = self;
    [self.view addSubview:_survivorView];
    
    UILabel * titleLabel =  (UILabel *)[_survivorView getNavigationTitleLabelWithText:@"Survivor Finder"];
    self.navigationItem.titleView = titleLabel;
    
    [self setRoundedCornersOfViewController];
}


#pragma mark - HSSurvivorView Delegate
-(void)didTapFindSurvivorButton:(UIButton *)sender
{
    NSNumber * chairsCount = @([self.survivorView.numOfChairsTextField.text longLongValue]);

 /***********  Class Method example **********
    [HSSurvivorManager calculateSurvivorFromNumberOfChairs:chairsCount withCompletionBlock:^(NSNumber *result, NSError *error) {
        __weak iHSAppsViewController * unretainedSelf = self;
       
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (!error) {
                [unretainedSelf showAlertWithTitle:nil message:[NSString stringWithFormat:@"Survivor's chair number is %d", [result integerValue]]];
            }
            else //This wont happen, but incase if happen, show error alert to user.
                [unretainedSelf showAlertWithTitle:[error domain] message:[error localizedDescription]];
            
            [unretainedSelf showProcessingProgress:FALSE];
        });
    }];
*/
    

/*********** Instance Method example *************/

    HSSurvivorManager * _survivorManager = [[HSSurvivorManager alloc] init];
    _survivorManager.numberOfChairs = chairsCount;
    
    __weak iHSAppsViewController * weakSelf = self;
    
    [_survivorManager findSurvivorWithCompletionBlock:^(NSNumber *result, NSError *error) {
         iHSAppsViewController * strongSelf = weakSelf;

                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if (!error) {
                        [strongSelf showAlertWithTitle:nil message:[NSString stringWithFormat:@"Survivor's chair number is %d", [result integerValue]]];
                    }
                    else //This wont happen, but incase if happen, show error alert to user.
                        [strongSelf showAlertWithTitle:[error domain] message:[error localizedDescription]];
                    
                    [strongSelf.survivorView showProcessingProgress:FALSE];
                });

    }];

}

-(void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alertView show];
}
//this should be actually in base class or category, to ensure reusablility.
-(void)setRoundedCornersOfViewController
{
    
    //Round upper corners of Navigation bar
    CALayer *navLayer = [self.navigationController navigationBar].layer;
    [navLayer setShouldRasterize:NO];
    
    
    //Round
    CGRect bounds = navLayer.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    
    
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    [navLayer addSublayer:maskLayer];
    navLayer.mask = maskLayer;
    
    
    
    //Round bottom corners of UIViewController's view
    CALayer *viewLayer = [self view].layer;
    [viewLayer setShouldRasterize:NO];
    
    
    //Round
    CGRect viewBounds = self.view.bounds;
    //viewBounds.size.height += 10.0f;    // reserving enough room for the shadow
    UIBezierPath * viewMaskPath = [UIBezierPath bezierPathWithRoundedRect:viewBounds
                                                        byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                              cornerRadii:CGSizeMake(10.0, 10.0)];
    
    
    
    CAShapeLayer * viewMaskLayer = [CAShapeLayer layer];
    viewMaskLayer.frame = bounds;
    viewMaskLayer.path = viewMaskPath.CGPath;
    
    [viewLayer addSublayer:viewMaskLayer];
    viewLayer.mask = viewMaskLayer;
    
}

@end
