//
//  ALDateUitil.h
//  DAE
//
//  Created by 刘文楠 on 6/21/17.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALDateUitil : NSObject

+(NSString*)getCurrentTimestamp;
+(NSString*)getCurrentDate;

+(NSString*)getTimestampFromDate:(NSDate*)date;
+(NSString*)getTimestampFromYear:(int)year Month:(int)month Day:(int)day;

+(NSString*)getDateFromTimestamp:(NSString*)timestamp;
+(NSString*)getFormattedDateFromTimestamp:(NSString*)timestamp andFormat:(NSString *)format;

+(NSDate*)getDateFromYear:(int)year Month:(int)month Day:(int)day;

@end
