//
//  ALExeItemQueue.h
//  ALFramework
//
//  Created by AlancLiu on 01/09/2017.
//  Copyright © 2017 Alanc. All rights reserved.
//

#import "ALQueue.h"
#import "ALExeItem.h"

@interface ALExeItemQueue : ALQueue

-(bool)containsItem:(NSString *)itemID;
-(ALExeItem *)getItemByID:(NSString *)itemID;
-(ALExeItem *)exportItemByID:(NSString *)itemID;

@end
