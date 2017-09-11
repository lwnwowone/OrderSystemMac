//
//  ALExeItem.h
//  Pods
//
//  Created by AlancLiu on 29/08/2017.
//
//

#import <Foundation/Foundation.h>
#import "ALActionResult.h"

#define DEFAULT_TIMEOUT 9999

typedef NS_ENUM(NSInteger,ALExeItemType){
    ALExeItemTypeTask = 0,
    ALExeItemTypeTaskChain = 1,
    ALExeItemTypeTaskGroup = 2
};

static int nextItemTimeout = DEFAULT_TIMEOUT;

@interface ALExeItem : NSObject

@property (nonatomic) ALExeItemType type;
@property (nonatomic) bool isCanceled;
@property (nonatomic) bool isTimeout;
@property (nonatomic) int timeout;
@property (nonatomic) bool hasExecutedCallback;
@property (nonatomic) NSString *ID;
@property (nonatomic) ALActionResult * executedResult;

-(void)run;

-(void)cancel;
-(void)itemTimeout;

-(void)complete;
-(void)completesucceedfully;

@property (nonatomic) void (^taskBlock)();
@property (nonatomic) void (^finishBlock)(ALActionResult *executedResult);

+(void)setNextItemTimeout:(int)nextTimeout;

@end
