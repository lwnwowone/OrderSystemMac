//
//  LogHelper.h
//  ALThreadPool
//
//  Created by Alanc Liu on 23/03/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import "ALLogMeta.h"

#define LOG_INFO(...) [ALLogHelper writeLogWithType:ALLogTypeInfo andMessage:__VA_ARGS__]
#define LOG_DEBUG(...) [ALLogHelper writeLogWithType:ALLogTypeDebug andMessage:__VA_ARGS__]
#define LOG_BASIC_INFO(...) [ALLogHelper writeLogWithType:ALLogTypeBasicInfo andMessage:__VA_ARGS__]
#define LOG_ERROR(...) [ALLogHelper writeLogWithType:ALLogTypeError andMessage:__VA_ARGS__]

@interface ALLogHelper : NSObject

+(void)writeLogWithType:(ALLogType)type andMessage:(NSString*)content;

+(NSString *)getDescriptionFromType:(ALLogType)type;

+(NSString *)logDBPath;
+(NSString *)logTableName;

@end
