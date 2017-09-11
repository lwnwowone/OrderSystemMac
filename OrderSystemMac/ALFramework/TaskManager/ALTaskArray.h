//
//  ALTaskGroup.h
//  ALThreadPool
//
//  Created by Alanc Liu on 23/03/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import "ALExeItem.h"
#import "ALTask.h"
#import "ALActionResult.h"

@interface ALTaskArray : ALExeItem{
    @protected dispatch_semaphore_t runningWaitFlag;
}

@property int startTaskIndex;
@property int runningState;

@property (nonatomic) NSMutableArray *taskList;

-(id)initWithFinishBlock:(void(^)(ALActionResult*))finishBlock;
-(void)addTask:(ALTask *)task;

#pragma to be override

+(ALExeItem *)runTwoTasksWithActionOne:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block1
                        andActionTwo:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block2
                         andCallback:(void(^)(ALActionResult *funcResult))callback;

+(ALExeItem *)runThreeTasksWithActionOne:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block1
                          andActionTwo:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block2
                        andActionThree:(ALActionResult *(^)(NSArray<ALTask *> *taskGroup))block3
                           andCallback:(void(^)(ALActionResult *funcResult))callback;

@end
