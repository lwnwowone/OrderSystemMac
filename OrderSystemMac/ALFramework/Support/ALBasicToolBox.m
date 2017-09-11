//
//  BasicToolBox.m
//  ALThreadPool
//
//  Created by Alanc Liu on 22/03/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import "ALBasicToolBox.h"

@implementation ALBasicToolBox

+(void)runFunctionInMainThread:(void(^)())action WithDelay:(int)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [action invoke];
    });
}

+(void)runFunctionInMainThread:(void(^)())action{
    dispatch_async(dispatch_get_main_queue(), ^{
        [action invoke];
    });
}

+(NSString *)newGUID{
    NSString *UUID = [[NSUUID UUID] UUIDString];
    return UUID;
}

+(NSString *)currentTimeStamp{
    NSDate* data = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval ti = [data timeIntervalSince1970];
    NSString *tmpStr = [NSString stringWithFormat:@"%f", ti];
    NSArray *tmpArray = [tmpStr componentsSeparatedByString:@"."];
    return [tmpArray objectAtIndex:0];
}

+(NSString *)deviceID{
    NSString *result = [[NSUserDefaults standardUserDefaults] stringForKey:@"DeviceID"];
    if(!result){
        result = [[ALBasicToolBox newGUID] stringByAppendingString:[ALBasicToolBox currentTimeStamp]];
        [[NSUserDefaults standardUserDefaults] setValue:result forKey:@"DeviceID"];
    }
    return result;
}

+(bool)isDigital:(NSString *)aStr{
    NSString *expression = @"^[0-9]+$";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:aStr
                                                        options:0
                                                          range:NSMakeRange(0, aStr.length)];
    return numberOfMatches > 0;
}

@end
