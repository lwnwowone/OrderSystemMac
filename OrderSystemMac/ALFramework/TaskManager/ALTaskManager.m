//
//  ALThreadManager.m
//  ALThreadPool
//
//  Created by Alanc Liu on 18/12/2016.
//  Copyright © 2016 Alanc Liu. All rights reserved.
//

#import "ALTaskManager.h"
#import "ALActionResultStandardError.h"
#import "ALExeItemQueue.h"
#import "ALCommonMacros.h"
#import "ALExeItem.h"
#import "ALLogHelper.h"

@interface ALTaskManager()

@end

@implementation ALTaskManager{
    
@private bool isRunning;
    
@private ALExeItemQueue *mainQueue;
@private ALExeItemQueue *backgroundQueue;

@private ALExeItem *currentRunningItem;
    
@private dispatch_queue_t mainGCDQueue;
@private dispatch_queue_t backgroundGCDQueue;
    
@private NSMutableArray* moveToBackgroundList;
    
}

static ALTaskManager *staticManager;

+(void)runExeItem:(ALExeItem *)item{
    [[ALTaskManager defaultManager] addExeItem:item intoQueue:ALThreadTypeOperation];
}

+(void)runExeItem:(ALExeItem *)item inQueue:(ALThreadType)type{
    [[ALTaskManager defaultManager] addExeItem:item intoQueue:type];
}

+(bool)cancelExeItemByID:(NSString *)itemID{
    ALTaskManager *instance = [ALTaskManager defaultManager];
    bool canCancel = false;
    
    if([instance->currentRunningItem.ID isEqualToString:itemID]){
        NSLog(@"Trying to cancel current task");
        [instance->currentRunningItem cancel];
        canCancel = true;
    }
    else{
        if([instance->mainQueue containsItem:itemID]){
            canCancel = true;
            [[instance->mainQueue getItemByID:itemID] cancel];
        }
        else if([instance->backgroundQueue containsItem:itemID]){
            canCancel = true;
            [[instance->backgroundQueue getItemByID:itemID] cancel];
        }
    }
    
    if(!canCancel){
        LOG_DEBUG(@"Cannot cancel ALExeItem, the item is no exists");
    }
    
    return canCancel;
}

+(bool)moveExeItemIntoBackgroundQueueByID:(NSString*)itemID{
    ALTaskManager *instance = [ALTaskManager defaultManager];
    bool canMove = [instance->mainQueue containsItem:itemID];
    
    if(canMove)
        [instance->backgroundQueue enqueue:[instance->mainQueue exportItemByID:itemID]];
    else{
        LOG_DEBUG(@"Cannot move ALExeItem to background queue, the item is no exists in main queue");
    }

    
    return canMove;
}

+(bool)moveExeItemIntoMainQueueByID:(NSString*)itemID{
    ALTaskManager *instance = [ALTaskManager defaultManager];
    bool canMove = [instance->backgroundQueue containsItem:itemID];
    
    if(canMove)
        [instance->mainQueue enqueue:[instance->backgroundQueue exportItemByID:itemID]];
    else{
        LOG_DEBUG(@"Cannot move ALExeItem to background queue, the item is no exists in main queue");
    }
    
    
    return canMove;
}


#pragma private methods

+(ALTaskManager *)defaultManager
{
    if(nil == staticManager)
        staticManager = [[ALTaskManager alloc] init];
    return staticManager;
}

-(id)init
{
    self = [super init];
    
    moveToBackgroundList = [[NSMutableArray alloc] init];

    mainQueue = [ALExeItemQueue new];
    backgroundQueue = [ALExeItemQueue new];

    mainGCDQueue = dispatch_queue_create("mainQueue", DISPATCH_QUEUE_SERIAL);
    backgroundGCDQueue = dispatch_queue_create("backgroundQueue", DISPATCH_QUEUE_SERIAL);
    
    __TO_WEAK_SELF;
    mainQueue.objectEnqueue = ^{
        __TO_STRONG_SELF;
        [self runTasks];
    };
    
    return self;
}

-(void)clearOperationList{
    
}

-(void)addExeItem:(ALExeItem *)item intoQueue:(ALThreadType)type{
    if(ALThreadTypeOperation == type){
        [mainQueue enqueue:item];
    }
    else if(ALThreadTypeBackground == type){
        [backgroundQueue enqueue:item];
    }
    else{
        LOG_ERROR(@"Cannot add ALExeItem into queue, the type is incorrect");
    }
}

-(void)runTasks{
    if(isRunning)
        return;
    
    [self doRunningTasks];
}

-(void)runTasksWithoutCheckingState{
    [self doRunningTasks];
}

-(void)doRunningTasks{
    isRunning = true;
    if(mainQueue.count > 0){
        [self runExeItem:[mainQueue dequeue] InQueue:mainGCDQueue];
    }
    else if(backgroundQueue.count > 0){
        [self runExeItem:[backgroundQueue dequeue] InQueue:backgroundGCDQueue];
    }
    else
        NSLog(@"All tasks have been finished");
}

-(void)runExeItem:(ALExeItem *)item InQueue:(dispatch_queue_t)queue{
    dispatch_async(queue, ^{
        [self runExeObject:item];
        [self exeItemFinished];
    });
}

-(void)runExeObject:(ALExeItem *)item{
    currentRunningItem = item;
    [self runExeTaskObjectWithoutSettingRunningFlag:item];
    currentRunningItem = nil;
}

-(void)runExeTaskObjectWithoutSettingRunningFlag:(ALExeItem *)item{
    if(item.isCanceled){
        [item cancel];
    }
    else{
        [item run];
        if(item.isCanceled)
            [item cancel];
        else
            [item completesucceedfully];
    }
}

-(void)exeItemFinished{
    if(mainQueue.count > 0 || backgroundQueue.count > 0)
        [self doRunningTasks];
    else{
        isRunning = false;
    }
}

@end
