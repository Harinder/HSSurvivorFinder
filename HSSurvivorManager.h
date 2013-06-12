//
//  HSSurvivorManager.h
//  HSSurvivor
//
//  Created by Harinder Singh on 6/4/12.
//  Copyright (c) 2012 Harinder Singh. All rights reserved.
//


/****************************
 
 @abstract  App to find Survivor's chair
  
 @discussion
 This class can be used to find the survivor, a typical coding problem.
 
 The Problem
 ===========

 You are in a room with a circle of N chairs. The chairs are numbered sequentially from 1 to N.
 
 At some point in time, the person in chair #1 will be asked to leave. The person in chair #2 will be skipped, 
 and the person in chair #3 will be asked to leave. This pattern of skipping one person and asking the next to 
 leave will keep going around the circle until there is one person left the survivor.
 
 The given N as input provided by the user. The user should be able to:
 
 1) Specify N
 2) Calculate the survivor number
 3) Specify a new N, and obtain a new survivor number, and so on.
 
 ********************************/



#import <Foundation/Foundation.h>


typedef void (^HSSurvivorCompletionBlock)(NSNumber * result, NSError *error);

@interface HSSurvivorManager : NSObject
{
    @private
        NSNumber * _numberOfChairs;

}

@property (nonatomic, strong) NSNumber * numberOfChairs;


/**
 
 @abstract  Instance method to calculate survivior
 
 @param block to be excuted, once completed (HSSurvivorCompletionBlock)
 
 @discussion 
    This method can be used to calculate the survivor, based on the total number of chairs. 
    numberOfChairs must be set before sending message to this message
    A completion block will be passed also for callback.
    Processing will be done asynchronously
 
 **/

-(void)findSurvivorWithCompletionBlock:(HSSurvivorCompletionBlock)block;



/**

 @abstract  Class method to calculate survivior  
 
 @param chairsCount: Total number of chairs (NSNumber)
 @param block to be excuted, once completed (HSSurvivorCompletionBlock)
 
 @discussion 
    This is convinient class method can be used to calculate the survivor, based on the total number of chairs. 
    A completion block will be passed also for callback. Processing will be done asynchronously.

**/

+(void)calculateSurvivorFromNumberOfChairs:(NSNumber *)chairsCount withCompletionBlock:(HSSurvivorCompletionBlock)block;


/**
 
 @abstract  Validate number of chairs
 
 @param numberOfChairs: Total number of chairs (NSNumber)
 
 @discussion
 This is  class method to validate if number of chairs provided by user is accurate.
 
 **/

+(BOOL)isValidNumberOfChairs:(NSNumber *)numberOfChairs;


@end
