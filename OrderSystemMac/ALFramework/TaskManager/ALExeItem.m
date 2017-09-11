//
//  ALExeItem.m
//  Pods
//
//  Created by AlancLiu on 29/08/2017.
//
//

#import "ALExeItem.h"
#import "ALBasicToolBox.h"
#import "ALActionResultStandardError.h"
#import "ALCommonMacros.h"

@implementation ALExeItem

-(id)init{
    self = [super init];
    self.hasExecutedCallback = false;
    self.timeout = nextItemTimeout;
    nextItemTimeout = DEFAULT_TIMEOUT;
    self.ID = [ALBasicToolBox newGUID];
    self.executedResult = [ALActionResult new];
    self.isCanceled = false;
    return self;
}

-(void)complete{
    if(self.hasExecutedCallback)
        return;
    
    if(self.finishBlock){
        self.hasExecutedCallback = true;
        if(self.finishBlock)
            self.finishBlock(_executedResult);
    }
}

-(void)cancel{
    self.isCanceled = true;
    [ALActionResultStandardError taskCanceledError:_executedResult];
    [self complete];
}

-(void)itemTimeout{
    self.isTimeout = true;
    [ALActionResultStandardError timeoutError:_executedResult];
    [self complete];
}

-(void)completesucceedfully{
    self.executedResult.result = true;
    [self complete];
}

-(void)run{
    __weak typeof(self) weakself = self;
    [ALBasicToolBox runFunctionInMainThread:^{
        [weakself itemTimeout];
    } WithDelay:self.timeout];
}

+(void)setNextItemTimeout:(int)nextTimeout{
    nextItemTimeout = nextTimeout;
}

@end
