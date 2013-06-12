//
//  HSSurvivorView.m
//  HSSurvivor
//
//  Created by Harinder Singh on 6/1/13.
//  Copyright (c) 2013 Harinder Singh. All rights reserved.
//

#import "HSSurvivorView.h"

@interface HSSurvivorView()
{
    UITextField * _numOfChairsTextField;
    UIButton * _findSurvivorButton;
}

@property (nonatomic, strong, readwrite) UITextField * numOfChairsTextField;
@property (nonatomic, strong, readwrite) UIButton * findSurvivorButton;

@end


@implementation HSSurvivorView


@synthesize numOfChairsTextField = _numOfChairsTextField;
@synthesize findSurvivorButton = _findSurvivorButton;

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //Do initial setup here (including UI components)
        [self initialSetup];

    }
    return self;
}

#pragma mark - Custom selectors
-(void)initialSetup
{
    
    
#define kNavigationTitle @"Survivor Finder"
#define kDefaultIntroText  @"This sample app can be used to find the survivor's chair number."
#define kDefaultTitleText  @"Please enter total number of chairs."
#define kDefaultPlaceholderText @"(e.g. 10 or 100)";
    
#define kBackgroundColor [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:227.0/255.0 alpha:1.0]
#define kShadowColor [UIColor colorWithRed:201.0/255.0 green:201.0/255.0 blue:201.0/255.0 alpha:1.0]
    
#define kDefaultX 20
    
        //Creating/initialising UI components
    int y =  10;
    
    int maxWidth  = self.bounds.size.width - (kDefaultX * 2);
    
    //Calcuating size of text
    UIFont * headingFont = [UIFont systemFontOfSize:13.0f];
    CGSize maximumSize = CGSizeMake(maxWidth, [UIScreen mainScreen].bounds.size.height);
    CGSize calculatedSize = [kDefaultIntroText sizeWithFont:headingFont constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];
    
    //Creating header title label
    UILabel* headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDefaultX*2, y, calculatedSize.width, calculatedSize.height)];
    headingLabel.text = kDefaultIntroText;
    headingLabel.numberOfLines = 0;
    headingLabel.font = headingFont;
    headingLabel.shadowColor = [UIColor whiteColor];
    headingLabel.shadowOffset = CGSizeMake(1.0, 0.0);
    headingLabel.textColor = [UIColor grayColor];
    headingLabel.textAlignment = NSTextAlignmentCenter;
    headingLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    headingLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:headingLabel];
    
    y += (headingLabel.bounds.size.height) + kDefaultX;
    
    calculatedSize = [kDefaultTitleText sizeWithFont:headingFont constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];

    
    //Creating title label
    UILabel* headingLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0 , y, [UIScreen mainScreen].bounds.size.width, calculatedSize.height)];
    headingLabel1.text = kDefaultTitleText;
    headingLabel1.numberOfLines = 0;
    headingLabel1.font = [UIFont boldSystemFontOfSize:14.0f];
    headingLabel1.shadowColor = [UIColor whiteColor];
    headingLabel1.shadowOffset = CGSizeMake(1.0, 0.0);
    headingLabel1.textColor = [UIColor darkGrayColor];
    headingLabel1.textAlignment = NSTextAlignmentCenter;
    headingLabel1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    headingLabel1.backgroundColor = [UIColor clearColor];
    [self addSubview:headingLabel1];
    
    y += (headingLabel1.bounds.size.height * 2);

    //create text field to get number of chairs from user
    int heightTextField  = 30;
    
    UITextField * tempTxtField = [[UITextField alloc] initWithFrame:CGRectMake(kDefaultX,y,maxWidth + 20,heightTextField)];
    //tempTxtField.borderStyle = UITextBorderStyleBezel;
    tempTxtField.placeholder = kDefaultPlaceholderText;
    tempTxtField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    tempTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    tempTxtField.keyboardType = UIKeyboardTypeNumberPad;
    tempTxtField.textAlignment = NSTextAlignmentCenter;
    tempTxtField.font = [UIFont boldSystemFontOfSize:20];
    tempTxtField.delegate =  self;
    [self addSubview:tempTxtField];
    self.numOfChairsTextField = tempTxtField;
    
    y += (tempTxtField.bounds.size.height * 2);
    [tempTxtField becomeFirstResponder];
    
    
    
    UIButton * tempfindSurvivorButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [tempfindSurvivorButton setFrame:CGRectMake(kDefaultX, y, maxWidth, 40)];
    [tempfindSurvivorButton setTitle:@"Find Survivor" forState:UIControlStateNormal];
    [tempfindSurvivorButton setEnabled:FALSE];
    [tempfindSurvivorButton addTarget:self action:@selector(findSurvivorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.findSurvivorButton = tempfindSurvivorButton;
    [self addSubview:tempfindSurvivorButton];
    
}
-(void)showProcessingProgress:(BOOL)isProcessingStarted
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:isProcessingStarted];
    self.findSurvivorButton.enabled = !isProcessingStarted;
}

#pragma mark - UITextField Delegates

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    //if nothing has been entered, disable find survivor button, otherwise enable it
    self.findSurvivorButton.enabled = (!newLength) ? FALSE : TRUE;
    return (newLength > 8)? FALSE: TRUE;
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if(textField == self.numOfChairsTextField)
        self.findSurvivorButton.enabled = FALSE;     //disable find survivor button
    
    return TRUE;
}

#pragma maek - delegate methods
-(void)findSurvivorButtonTapped:(UIButton *)sender
{
    SEL didTapFindSurvivorButtonSelector = @selector(didTapFindSurvivorButton:);
    if([self.delegate respondsToSelector:didTapFindSurvivorButtonSelector])
        [self.delegate performSelector:@selector(didTapFindSurvivorButton:) withObject:sender];
}
-(void)dealloc
{
    _delegate = nil;
}

#pragma mark -

-(UILabel *)getNavigationTitleLabelWithText:(NSString *)navTitle
{
    UILabel *navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 44)];
    [navTitleLabel setBackgroundColor:[UIColor clearColor]];
    [navTitleLabel setNumberOfLines:2];
    [navTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [navTitleLabel setContentMode:UIViewContentModeCenter];
    [navTitleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [navTitleLabel setTextColor:[UIColor blackColor]];
    [navTitleLabel setShadowColor:[UIColor whiteColor]];
    [navTitleLabel setShadowOffset:CGSizeMake(0, -1)];
    navTitleLabel.text = navTitle;
    return navTitleLabel;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
