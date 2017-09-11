//
//  ALTaskChain.m
//  ALThreadPool
//
//  Created by Alanc Liu on 25/05/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import "ALTaskChain.h"
#import "ALTaskManager.h"

@implementation ALTaskChain

-(id)init{
    self = [super init];
    self.type = ALExeItemTypeTaskChain;
    return self;
}

-(void)run{
    [super run];
    
    dispatch_queue_t runningQueue = dispatch_queue_create("chainQueue", DISPATCH_QUEUE_SERIAL);
    self.runningState = true;
    dispatch_async(runningQueue, ^{
        for(ALTask *tTask in self.taskList) {
            if(self.isCanceled || self.isTimeout){
                break;
            }
            [tTask run];
            if(self.isCanceled || self.isTimeout){
                break;
            }
            [tTask completesucceedfully];
            self.startTaskIndex++;
            if(self.startTaskIndex == self.taskList.count)
                dispatch_semaphore_signal(runningWaitFlag);
        }
    });
    dispatch_semaphore_wait(runningWaitFlag, DISPATCH_TIME_FOREVER);
    self.runningState = false;
}

-(dispatch_queue_t)generateGCDQueue{
    return dispatch_queue_create("chainQueue", DISPATCH_QUEUE_SERIAL);;
}

+(ALExeItem *)runTwoTasksWithActionOne:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block1 andActionTwo:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block2 andCallback:(void(^)(ALActionResult *funcResult))callback{
    __block NSMutableArray<ALActionResult *> *resultArray = [NSMutableArray new];
    [resultArray addObject:[ALActionResult new]];
    
    __block ALActionResult *apiResult = [ALActionResult new];
    __block ALTask *task1;
    __block ALTask *task2;
    
    ALTaskChain *chain = [[ALTaskChain alloc] initWithFinishBlock:^(ALActionResult *groupResult) {
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
            [ALTaskManager cancelExeItemByID:task2.ID];
        }
        [resultArray addObject:[apiResult copy]];
        
        if(!apiResult.result)
            [ALTaskManager cancelExeItemByID:task2.ID];
    }];
    
    task2 = [[ALTask alloc] initWithTaskBlock:^{
        apiResult = block2(@[task1,task2]);
    } andFinishBlock:^(ALActionResult *taskResult) {
        if(!taskResult.result){
            [apiResult copyErrorInfoFrom:taskResult];
        }
        [resultArray addObject:[apiResult copy]];
        
        task1 = nil;
        task2 = nil;
        apiResult = nil;
    }];
    
    [chain addTask:task1];
    [chain addTask:task2];
    [ALTaskManager runExeItem:chain];
    
    return chain;
}

+(ALExeItem *)runThreeTasksWithActionOne:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block1 andActionTwo:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block2 andActionThree:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block3 andCallback:(void(^)(ALActionResult *funcResult))callback{
    __block NSMutableArray<ALActionResult *> *resultArray = [NSMutableArray new];
    [resultArray addObject:[ALActionResult new]];
    
    __block ALActionResult *apiResult = [ALActionResult new];
    __block ALTask *task1;
    __block ALTask *task2;
    __block ALTask *task3;
    
    ALTaskChain *chain = [[ALTaskChain alloc] initWithFinishBlock:^(ALActionResult *groupResult) {
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
            [ALTaskManager cancelExeItemByID:task2.ID];
            [ALTaskManager cancelExeItemByID:task3.ID];
        }
        [resultArray addObject:[apiResult copy]];
        if(!apiResult.result)
            [ALTaskManager cancelExeItemByID:task2.ID];
    }];
    
    task2 = [[ALTask alloc] initWithTaskBlock:^{
        apiResult = block2(@[task1,task2,task3]);
    } andFinishBlock:^(ALActionResult *taskResult) {
        if(!taskResult.result){
            [apiResult copyErrorInfoFrom:taskResult];
            [ALTaskManager cancelExeItemByID:task3.ID];
        }
        [resultArray addObject:[apiResult copy]];
        if(!apiResult.result)
            [ALTaskManager cancelExeItemByID:task3.ID];
    }];
    
    task3 = [[ALTask alloc] initWithTaskBlock:^{
        apiResult = block3(@[task1,task2,task3]);
    } andFinishBlock:^(ALActionResult *taskResult) {
        if(!taskResult.result){
            [apiResult copyErrorInfoFrom:taskResult];
        }
        [resultArray addObject:[apiResult copy]];
        
        task1 = nil;
        task2 = nil;
        task3 = nil;
        apiResult = nil;
    }];
    
    [chain addTask:task1];
    [chain addTask:task2];
    [chain addTask:task3];
    [ALTaskManager runExeItem:chain];
    
    return chain;
}

@end
