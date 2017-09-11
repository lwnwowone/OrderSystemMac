//
//  ALTaskGroup.m
//  ALFramework
//
//  Created by AlancLiu on 22/08/2017.
//  Copyright © 2017 Alanc. All rights reserved.
//

#import "ALTaskGroup.h"
#import "ALTaskManager.h"

@implementation ALTaskGroup

-(id)init{
    self = [super init];
    self.type = ALExeItemTypeTaskGroup;
    return self;
}

-(void)run{
    [super run];
    
    dispatch_queue_t runningQueue = dispatch_queue_create("groupQueue", DISPATCH_QUEUE_CONCURRENT);
    self.runningState = true;
    for(ALTask *tTask in self.taskList) {
        dispatch_async(runningQueue, ^{
            if(self.isCanceled || self.isTimeout){
                dispatch_semaphore_signal(runningWaitFlag);
            }
            [tTask run];
            if(self.isCanceled || self.isTimeout){
                dispatch_semaphore_signal(runningWaitFlag);
            }
            [tTask completesucceedfully];
            self.startTaskIndex++;
            if(self.startTaskIndex == self.taskList.count)
                dispatch_semaphore_signal(runningWaitFlag);
        });
    }
    dispatch_semaphore_wait(runningWaitFlag, DISPATCH_TIME_FOREVER);
    self.runningState = false;
}

-(dispatch_queue_t)generateGCDQueue{
    return dispatch_queue_create("groupQueue", DISPATCH_QUEUE_CONCURRENT);
}

+(ALExeItem *)runTwoTasksWithActionOne:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block1 andActionTwo:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block2 andCallback:(void(^)(ALActionResult *funcResult))callback{
    __block NSMutableArray<ALActionResult *> *resultArray = [NSMutableArray new];
    [resultArray addObject:[ALActionResult new]];
    
    __block ALActionResult *apiResult = [ALActionResult new];
    __block ALTask *task1;
    __block ALTask *task2;
    
    ALTaskGroup *group = [[ALTaskGroup alloc] initWithFinishBlock:^(ALActionResult *groupResult) {
        task1 = nil;
        task2 = nil;
        apiResult = nil;
        
        [[resultArray objectAtIndex:0] copyErrorInfoFrom:groupResult];
        
        ALActionResult *returnResult = [ALActionResult new];
        if([resultArray objectAtIndex:0].result && [resultArray objectAtIndex:1].result && [resultArray objectAtIndex:2].result){
            returnResult.result = true;
        }
        else{
            if(![resultArray objectAtIndex:0].result)
                [returnResult copyErrorInfoFrom:[resultArray objectAtIndex:0]];
            else if(![resultArray objectAtIndex:1].result)
                [returnResult copyErrorInfoFrom:[resultArray objectAtIndex:1]];
            else if(![resultArray objectAtIndex:2].result)
                [returnResult copyErrorInfoFrom:[resultArray objectAtIndex:2]];
        }
        returnResult.extraData = [resultArray copy];
        if(callback)
            callback(returnResult);
        
        resultArray = nil;
    }];
    
    task1 = [[ALTask alloc] initWithTaskBlock:^{
        apiResult = block1(@[task1,task2]);
    } andFinishBlock:^(ALActionResult *taskResult) {
        if(!taskResult.result){
            [apiResult copyErrorInfoFrom:taskResult];
        }
        [resultArray addObject:[apiResult copy]];
    }];
    
    task2 = [[ALTask alloc] initWithTaskBlock:^{
        apiResult = block2(@[task1,task2]);
    } andFinishBlock:^(ALActionResult *taskResult) {
        if(!taskResult.result){
            [apiResult copyErrorInfoFrom:taskResult];
        }
        [resultArray addObject:[apiResult copy]];
    }];
    
    [group addTask:task1];
    [group addTask:task2];
    [ALTaskManager runExeItem:group];
    
    return group;
}

+(ALExeItem *)runThreeTasksWithActionOne:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block1 andActionTwo:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block2 andActionThree:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block3 andCallback:(void(^)(ALActionResult *funcResult))callback{
    __block NSMutableArray<ALActionResult *> *resultArray = [NSMutableArray new];
    [resultArray addObject:[ALActionResult new]];
    
    __block ALActionResult *apiResult = [ALActionResult new];
    __block ALTask *task1;
    __block ALTask *task2;
    __block ALTask *task3;
    
    ALTaskGroup *group = [[ALTaskGroup alloc] initWithFinishBlock:^(ALActionResult *groupResult) {
        task1 = nil;
        task2 = nil;
        task3 = nil;
        apiResult = nil;
        
        [[resultArray objectAtIndex:0] copyErrorInfoFrom:groupResult];
        
        ALActionResult *returnResult = [ALActionResult new];
        if([resultArray objectAtIndex:0].result && [resultArray objectAtIndex:1].result && [resultArray objectAtIndex:2].result && [resultArray objectAtIndex:3].result){
            returnResult.result = true;
        }
        else{
            if(![resultArray objectAtIndex:0].result)
                [returnResult copyErrorInfoFrom:[resultArray objectAtIndex:0]];
            else if(![resultArray objectAtIndex:1].result)
                [returnResult copyErrorInfoFrom:[resultArray objectAtIndex:1]];
            else if(![resultArray objectAtIndex:2].result)
                [returnResult copyErrorInfoFrom:[resultArray objectAtIndex:2]];
            else if(![resultArray objectAtIndex:3].result)
                [returnResult copyErrorInfoFrom:[resultArray objectAtIndex:3]];
        }
        returnResult.extraData = [resultArray copy];
        if(callback)
            callback(returnResult);
        
        resultArray = nil;
    }];
    
    task1 = [[ALTask alloc] initWithTaskBlock:^{
        apiResult = block1(@[task1,task2,task3]);
    } andFinishBlock:^(ALActionResult *taskResult) {
        if(!taskResult.result){
            [apiResult copyErrorInfoFrom:taskResult];
        }
        [resultArray addObject:[apiResult copy]];
    }];
    
    task2 = [[ALTask alloc] initWithTaskBlock:^{
        apiResult = block2(@[task1,task2,task3]);
    } andFinishBlock:^(ALActionResult *taskResult) {
        if(!taskResult.result){
            [apiResult copyErrorInfoFrom:taskResult];
        }
        [resultArray addObject:[apiResult copy]];
    }];
    
    task3 = [[ALTask alloc] initWithTaskBlock:^{
        apiResult = block3(@[task1,task2,task3]);
    } andFinishBlock:^(ALActionResult *taskResult) {
        if(!taskResult.result){
            [apiResult copyErrorInfoFrom:taskResult];
        }
        [resultArray addObject:[apiResult copy]];
    }];
    
    [group addTask:task1];
    [group addTask:task2];
    [group addTask:task3];
    [ALTaskManager runExeItem:group];
    
    return group;
}

@end
