//
//  ALTaskArray.m
//  ALThreadPool
//
//  Created by Alanc Liu on 23/03/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import "ALTaskArray.h"
#import "ALBasicToolBox.h"
#import "ALTaskManager.h"
#import "ALActionResultStandardError.h"

@implementation ALTaskArray

-(id)init{
    self = [super init];
    runningWaitFlag = dispatch_semaphore_create(0);
    self.startTaskIndex = 0;
    self.runningState = -1;
    self.taskList = [NSMutableArray new];
    
    return self;
}

-(id)initWithFinishBlock:(void(^)(ALActionResult*))finishBlock{
    self = [self init];
    self.finishBlock = finishBlock;
    return self;
}

-(void)addTask:(ALTask *)task{
    [self.taskList addObject:task];
}

-(void)cancel{
    [super cancel];
    dispatch_semaphore_signal(runningWaitFlag);
}

-(void)itemTimeout{
    [super itemTimeout];
    dispatch_semaphore_signal(runningWaitFlag);
}

@end
