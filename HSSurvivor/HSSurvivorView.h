//
//  HSSurvivorView.h
//  HSSurvivor
//
//  Created by Harinder Singh on 6/1/13.
//  Copyright (c) 2013 Harinder Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSSurvivorViewDelegate <NSObject>
-(void)didTapFindSurvivorButton:(UIButton *)sender;
@end

@interface HSSurvivorView : UIView <UITextFieldDelegate>
{
    @private
        id  <HSSurvivorViewDelegate> _delegate;
}
@property (nonatomic, strong, readonly) UITextField * numOfChairsTextField;
@property (nonatomic, strong, readonly) UIButton * findSurvivorButton;

@property (nonatomic, strong) id <HSSurvivorViewDelegate> delegate;

-(void)showProcessingProgress:(BOOL)isProcessingStarted;

-(UILabel *)getNavigationTitleLabelWithText:(NSString *)navTitle;

@end


