//
//  LogHelper.mm
//  ALThreadPool
//
//  Created by Alanc Liu on 23/03/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import "ALLogHelper.h"
#import "ALDateUitil.h"

#define PRINT_LEVEL 4
#define LOG_TABLE_NAME @"LogTable"

@implementation ALLogHelper

+(void)writeLogWithType:(ALLogType)type andMessage:(NSString*)content{
    
    ALLogMeta *logMeta = [ALLogMeta new];
    
    logMeta.type = type;
    logMeta.message = content;
    
    if(type <= PRINT_LEVEL)
        NSLog(@"LogHelper(%@) : %@",[self getDescriptionFromType:type],content);
}

#pragma private method

+(NSString *)getDescriptionFromType:(ALLogType)type{
    long judgeNumber = (long)type;
    if(1 == judgeNumber){
        return @"Error";
    }
    else if(2 == judgeNumber){
        return @"Basic";
    }
    else if(3 == judgeNumber){
        return @"Debug";
    }
    else if(4 == judgeNumber){
        return @"Info";
    }
    else
        return @"Unknow";
}

@end
