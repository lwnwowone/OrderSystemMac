//
//  ALTask.m
//  ALThreadPool
//
//  Created by Alanc Liu on 18/12/2016.
//  Copyright © 2016 Alanc Liu. All rights reserved.
//

#import "ALTask.h"
#import "ALBasicToolBox.H"
#import "ALTaskManager.h"
#import "ALActionResultStandardError.h"

@implementation ALTask{
@private dispatch_semaphore_t runningWaitFlag;
}

-(id)init{
    self = [super init];
    self.type = ALExeItemTypeTask;
    runningWaitFlag = dispatch_semaphore_create(0);
    return self;
}

-(id)initWithTaskBlock:(void(^)())taskBlock andFinishBlock:(void(^)(ALActionResult *executedResult))finishBlock{
    self = [self init];
    self.taskBlock = taskBlock;
    self.finishBlock = finishBlock;
    return self;
}

-(void)run{
    dispatch_queue_t runningQueue = dispatch_queue_create("singleTask", DISPATCH_QUEUE_SERIAL);
    dispatch_async(runningQueue, ^{
        [super run];
        [self.taskBlock invoke];
        dispatch_semaphore_signal(runningWaitFlag);
    });
    dispatch_semaphore_wait(runningWaitFlag, DISPATCH_TIME_FOREVER);
}

-(void)cancel{
    [super cancel];
    dispatch_semaphore_signal(runningWaitFlag);
}

-(void)itemTimeout{
    [super itemTimeout];
    dispatch_semaphore_signal(runningWaitFlag);
}

#pragma static method

+(void)runNoneReturnDataTaskWithActionBlock:(ALActionResult *(^)())actionBLock andCallback:(void(^)(ALActionResult *))callback{
    __block ALActionResult *apiResult = [ALActionResult new];
    ALTask *task = [[ALTask alloc] initWithTaskBlock:^{
        apiResult = actionBLock();
    } andFinishBlock:^(ALActionResult *taskResult) {
        if(!taskResult.result){
            [apiResult copyErrorInfoFrom:taskResult];
        }
        if(callback){
            callback([apiResult copy]);
        }
        apiResult = nil;
    }];
    [ALTaskManager runExeItem:task];
}

+(void)runOneReturnDataTaskWithActionBlock:(ALActionResultWithData *(^)())actionBLock andCallback:(void(^)(ALActionResultWithData *))callback{
    __block ALActionResultWithData *apiResult = [ALActionResultWithData new];
    ALTask *task = [[ALTask alloc] initWithTaskBlock:^{
        apiResult = actionBLock();
    } andFinishBlock:^(ALActionResult *taskResult) {
        if(!taskResult.result){
            [apiResult copyErrorInfoFrom:taskResult];
        }
        if(callback){
            callback([apiResult copy]);
        }
        apiResult = nil;
    }];
    [ALTaskManager runExeItem:task];
}

+(void)runNonoReturnDataTaskOnCurrentThreadWithActionBlock:(ALActionResult *(^)())actionBLock andCallback:(void(^)(ALActionResult *))callback{
    __block ALActionResult *apiResult = [ALActionResult new];
    ALTask *task = [[ALTask alloc] initWithTaskBlock:^{
        apiResult = actionBLock();
    } andFinishBlock:^(ALActionResult *taskResult) {
        if(!taskResult.result){
            [apiResult copyErrorInfoFrom:taskResult];
        }
        if(callback){
            callback([apiResult copy]);
        }
        apiResult = nil;
    }];
    [ALTaskManager runExeItem:task inQueue:ALThreadTypeCurrent];
}

@end
