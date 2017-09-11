//
//  ALertMessage.h
//  OrderSystemMac
//
//  Created by AlancLiu on 06/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALertMessage : NSObject

+(void)operationFailedWithMessage:(NSString *)message;
+(void)operationFailedWithActionResult:(ALActionResult *)actionResult;

@end
