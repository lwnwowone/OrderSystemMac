//
//  ALThreadManager.h
//  ALThreadPool
//
//  Created by Alanc Liu on 18/12/2016.
//  Copyright © 2016 Alanc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALTask.h"
#import "ALTaskGroup.h"
#import "ALTaskChain.h"

typedef enum{
    ALThreadTypeOperation = 0,
    ALThreadTypeBackground = 1,
    ALThreadTypeCurrent = 2
}ALThreadType;

@interface ALTaskManager : NSObject

+(void)runExeItem:(ALExeItem *)item;
+(void)runExeItem:(ALExeItem *)item inQueue:(ALThreadType)type;

+(bool)cancelExeItemByID:(NSString*)itemID;
+(bool)moveExeItemIntoBackgroundQueueByID:(NSString*)itemID;
+(bool)moveExeItemIntoMainQueueByID:(NSString*)itemID;

@end
