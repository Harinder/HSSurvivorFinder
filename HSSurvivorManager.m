//
//  HSSurvivorManager.m
//  HSSurvivor
//
//  Created by Harinder Singh on 6/4/12.
//  Copyright (c) 2012 Harinder Singh. All rights reserved.
//

#import "HSSurvivorManager.h"
#import "HSStatusBar.h"
#import <mach/mach_time.h>

@interface HSSurvivorManager()
{
    @private
        uint64_t start;
        NSString *processName; //Name of process (optional)
}
//This method will return an array of NSNumber objects, based on max items
+(NSMutableArray *)getItemsArray:(NSNumber *)maxItems;

@end

@implementation HSSurvivorManager

@synthesize numberOfChairs = _numberOfChairs;

#pragma mark - Public methods

+ (HSSurvivorManager *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

+(void)calculateSurvivorFromNumberOfChairs:(NSNumber *)chairsCount withCompletionBlock:(HSSurvivorCompletionBlock)block
{
    HSSurvivorManager * oSurvivor = [HSSurvivorManager sharedInstance];
    oSurvivor.numberOfChairs = chairsCount;
    [oSurvivor findSurvivorWithCompletionBlock:block];
    
}

-(void)findSurvivorWithCompletionBlock:(HSSurvivorCompletionBlock)block
{
    if(![HSSurvivorManager isValidNumberOfChairs:_numberOfChairs]) {
        NSError *error = [NSError errorWithDomain:@"Error!" code:1
                                         userInfo:[NSDictionary dictionaryWithObject:@"Please enter valid number of chairs" forKey:NSLocalizedDescriptionKey]];
        block(nil, error);

        return;
    }
    else if (self->_numberOfChairs.integerValue == 1) {
        block(@(1), nil);
        return;
    }
    
    [HSStatusBar showWithMessage:@"Finding survivor's chair..." loading:YES animated:YES];
    
    __weak HSSurvivorManager * weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul), ^{
        
        [self startCalculatingProcessTime:@"findSurvivior"];

         HSSurvivorManager * _strongSelf = weakSelf;
        
         NSArray * arrChairs = [NSArray arrayWithArray:[HSSurvivorManager getItemsArray:_strongSelf->_numberOfChairs]];
        
         BOOL isRemovable = YES;
        
         NSNumber * survivorChairNumber =  @((findSurvivor(arrChairs,!isRemovable) + 1));
        
         if([survivorChairNumber integerValue])
            block(survivorChairNumber, nil);
         else
         {
            NSError *error = [NSError errorWithDomain:@"SurvivorNotFoundError" code:2
                                             userInfo:[NSDictionary dictionaryWithObject:@"Couldn't find survivor's chair." forKey:NSLocalizedDescriptionKey]];
            block(nil, error);
         }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [HSStatusBar hideAnimated:YES];

        });
        [self stopCalculatingProcessTime];
    });
}

+(BOOL)isValidNumberOfChairs:(NSNumber *)numberOfChairs
{
    return (numberOfChairs.integerValue > 0)?YES: NO;
}


#pragma mark - Private 

+(NSArray *)getItemsArray:(NSNumber *)maxItems
{
    NSMutableArray * arrItems = [NSMutableArray array];
    
    uint i = 0;
    
    //Adding elements in array
    while (i < [maxItems longValue]) {
        [arrItems addObject:@(i)]; i++;
    }
    
    return arrItems;
}

int (^findSurvivor)(NSArray *, BOOL) = ^(NSArray * arrChairs, BOOL isRemovable) {
    
    __block BOOL _isRemovable = isRemovable;
    
    __weak NSMutableArray * arrItemsTemp = [NSMutableArray array];
    
    //  if only one left in array, return it. Survivor is found
    if(arrChairs.count == 1)
        return [[arrChairs objectAtIndex:0] integerValue];
    
    
    [arrChairs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if (_isRemovable) //If removeable, add element in new array, and set isRemoveable = false
        {
            [arrItemsTemp addObject:[arrChairs objectAtIndex:idx]];
            _isRemovable = !_isRemovable;
        }
        else //else, set isRemoveable = true for every next element
            _isRemovable = !_isRemovable;
        
    }];
    
    return findSurvivor(arrItemsTemp, _isRemovable);
};


-(void)startCalculatingProcessTime:(NSString *)_processName
{
    start = mach_absolute_time();
    if((![_processName  isKindOfClass:[NSNull class]]) && ([_processName isKindOfClass:[NSString class]]))
    {
        processName = _processName;
    }
    
}
-(void)stopCalculatingProcessTime
{
    uint64_t end = mach_absolute_time();
    uint64_t elapsed = end - start;
    
    mach_timebase_info_data_t info;
    if (mach_timebase_info (&info) != KERN_SUCCESS) {
        printf ("mach_timebase_info failed\n");
    }
    
    uint64_t nanosecs = elapsed * info.numer / info.denom;
    uint64_t millisecs = nanosecs / 1000000;
    
    if((![processName  isKindOfClass:[NSNull class]]) && ([processName isKindOfClass:[NSString class]])) {
        NSLog(@"Process NAME \"%@\" TIME: %llu millisecond",[processName uppercaseString],millisecs);
    }
    else {
        NSLog(@"Process Time: %llu millisecond", millisecs);
    }
}
@end
