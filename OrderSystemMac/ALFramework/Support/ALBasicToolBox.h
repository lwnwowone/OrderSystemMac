//
//  BasicToolBox.h
//  ALThreadPool
//
//  Created by Alanc Liu on 22/03/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBasicToolBox : NSObject

+(void)runFunctionInMainThread:(void(^)())action;
+(void)runFunctionInMainThread:(void(^)())action WithDelay:(int)delay;

+(NSString *)newGUID;
+(NSString *)currentTimeStamp;
+(NSString *)deviceID;

+(bool)isDigital:(NSString *)aStr;

@end
