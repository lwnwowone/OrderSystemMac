//
//  ALTask.h
//  ALThreadPool
//
//  Created by Alanc Liu on 18/12/2016.
//  Copyright © 2016 Alanc Liu. All rights reserved.
//

#import "ALExeItem.h"
#import "ALActionResult.h"

@interface ALTask : ALExeItem

-(id)initWithTaskBlock:(void(^)())taskBlock andFinishBlock:(void(^)(ALActionResult * executedResult))finishBlock;

+(void)runNoneReturnDataTaskWithActionBlock:(ALActionResult *(^)())actionBLock andCallback:(void(^)(ALActionResult *))callback;
+(void)runOneReturnDataTaskWithActionBlock:(ALActionResultWithData *(^)())actionBLock andCallback:(void(^)(ALActionResultWithData *))callback;
+(void)runNonoReturnDataTaskOnCurrentThreadWithActionBlock:(ALActionResult *(^)())actionBLock andCallback:(void(^)(ALActionResult *))callback;

@end
