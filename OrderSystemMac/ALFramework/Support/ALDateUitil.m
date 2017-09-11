//
//  ALDateUitil.m
//  DAE
//
//  Created by 刘文楠 on 6/21/17.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import "ALDateUitil.h"

@implementation ALDateUitil

+(NSString*)getCurrentTimestamp{
    NSString * result = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    result = [NSString stringWithFormat:@"%llu",[result longLongValue]];
    return result;
}

+(NSString*)getCurrentDate{
    return [ALDateUitil getFormattedDateFromTimestamp:[ALDateUitil getCurrentTimestamp] andFormat:@"yyyy.MM.dd HH:mm:ss"];
}

+(NSString*)getTimestampFromDate:(NSDate*)date{
    NSString * result = [NSString stringWithFormat:@"%f",[date timeIntervalSince1970]];
    result = [NSString stringWithFormat:@"%llu",[result longLongValue]];
    return result;
}

+(NSString*)getTimestampFromYear:(int)year Month:(int)month Day:(int)day{
    NSDate *date = [ALDateUitil getDateFromYear:year Month:month Day:day];
    return [ALDateUitil getTimestampFromDate:date];
}

+(NSString*)getDateFromTimestamp:(NSString*)timestamp{
    return [ALDateUitil getFormattedDateFromTimestamp:timestamp andFormat:@"yyyy.MM.dd HH:mm"];
}

+(NSString*)getFormattedDateFromTimestamp:(NSString*)timestamp andFormat:(NSString *)format{
    NSString * timeStampString = timestamp;
    NSTimeInterval interval = [timeStampString longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    NSString *result = [formatter stringFromDate:date];
    return result;
}

+(NSDate*)getDateFromYear:(int)year Month:(int)month Day:(int)day{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [NSString stringWithFormat:@"%d-%d-%d",year,month,day];
    NSDate *result = [dateFormat dateFromString:dateString];
    return result;
}

@end
