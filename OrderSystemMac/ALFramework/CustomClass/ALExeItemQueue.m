//
//  ALExeItemQueue.m
//  ALFramework
//
//  Created by AlancLiu on 01/09/2017.
//  Copyright © 2017 Alanc. All rights reserved.
//

#import "ALExeItemQueue.h"

@implementation ALExeItemQueue

-(bool)containsItem:(NSString *)itemID{
    bool result = false;
    for (int i = 0 ; i < operationArray.count ; i++) {
        ALExeItem *tItem = [operationArray objectAtIndex:i];
        NSString *tID = tItem.ID;
        if([tID isEqualToString:itemID]){
            result = true;
            break;
        }
    }
    return result;
}

-(ALExeItem *)getItemByID:(NSString *)itemID{
    ALExeItem *result = nil;
    for (int i = 0 ; i < operationArray.count ; i++) {
        ALExeItem *tItem = [operationArray objectAtIndex:i];
        NSString *tID = tItem.ID;
        if([tID isEqualToString:itemID]){
            result = tItem;
            break;
        }
    }
    return result;
}

-(ALExeItem *)exportItemByID:(NSString *)itemID{
    ALExeItem *result = [self getItemByID:itemID];
    if(result)
        [operationArray removeObject:result];
    return result;
}

@end
