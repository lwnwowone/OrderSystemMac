//
//  ALThousandSeparatorUitil.m
//  ALThreadPool
//
//  Created by 刘文楠 on 6/7/17.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import "ALThousandSeparatorUitil.h"
#import "ALBasicToolBox.h"

@interface ALThousandSeparatorUitil()

@property (nonatomic) NSLocale *currentLocale;

@end

static ALThousandSeparatorUitil *defaultInstance;

@implementation ALThousandSeparatorUitil

+(instancetype)sharedInstance{
    if(!defaultInstance){
        defaultInstance = [ALThousandSeparatorUitil new];
        defaultInstance.currentLocale = nil;
    }
    return defaultInstance;
}

-(NSLocale *)getCurrentLocale{
    if(self.currentLocale)
        return self.currentLocale;
    else
        return [NSLocale currentLocale];
}

-(void)resetCurrentLocale{
    self.currentLocale = nil;
}

-(NSString *)currentDot{
    NSDecimalNumber *tmpD = (NSDecimalNumber *)[NSNumber numberWithDouble:1.1];
    NSString *formattedStr = [self getFormattedStringByDecimalValue:tmpD];
    NSString *result = [formattedStr substringWithRange:NSMakeRange(1, 1)];
    return result;
}

-(NSString *)currentSeparator{
    NSDecimalNumber *tmpD = (NSDecimalNumber *)[NSNumber numberWithDouble:1111];
    NSString *formattedStr = [self getFormattedStringByDecimalValue:tmpD];
    NSString *result = [formattedStr substringWithRange:NSMakeRange(1, 1)];
    return result;
}

-(NSString *)getPureNumberStringBySource:(NSString *)aString{
    NSString *result = @"";
    for (int i = 0; i < aString.length ; i++) {
        NSString *tmpStr = [aString substringWithRange:NSMakeRange(i, 1)];
        bool flagForSeparator = [[self currentDot] isEqualToString:tmpStr];
        bool flagForDigital = [ALBasicToolBox isDigital:tmpStr];
        if(flagForSeparator || flagForDigital)
            result =[result stringByAppendingString:tmpStr];
    }
    return result;
}

-(NSString *)getFixedFormattedStringByDecimalValue:(NSDecimalNumber * _Nonnull )aNumber andFixLength:(int)fixLength{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[self getCurrentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundDown];
    [numberFormatter setMaximumFractionDigits:fixLength];
    [numberFormatter setMinimumFractionDigits:fixLength];
    return [numberFormatter stringFromNumber:aNumber];
}

-(NSString *)getNoneFormattedStringByDecimalValue:(NSDecimalNumber * _Nonnull )aNumber andFixLength:(int)fixLength{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[self getCurrentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundDown];
    [numberFormatter setMinimumIntegerDigits:1];
    [numberFormatter setMaximumFractionDigits:fixLength];
    [numberFormatter setMinimumFractionDigits:fixLength];
    return [numberFormatter stringFromNumber:aNumber];
}

-(NSString *)getFormattedStringByDecimalValue:(NSDecimalNumber * _Nonnull )aNumber{
    return [self getFormattedStringByDecimalValue:aNumber andFractionDigits:2];
}

-(NSString *)getFormattedStringByDecimalValue:(NSDecimalNumber * _Nonnull )aNumber andFractionDigits:(int)digits{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[self getCurrentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setRoundingMode:NSNumberFormatterRoundDown];
    [numberFormatter setMaximumFractionDigits:digits];
    return [numberFormatter stringFromNumber:aNumber];
}

-(NSString *)getFormattedStringByDecimalValue:(NSDecimalNumber * _Nonnull )aNumber andFractionDigits:(int)digits andRoundingMode:(NSNumberFormatterRoundingMode)roundingMode{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[self getCurrentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setRoundingMode:roundingMode];
    [numberFormatter setMaximumFractionDigits:digits];
    return [numberFormatter stringFromNumber:aNumber];
}

-(NSString *)getFormattedStringByDecimalValue:(NSDecimalNumber * _Nonnull )aNumber andFiexdDigits:(int)fixLength andRoundingMode:(NSNumberFormatterRoundingMode)roundingMode{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[self getCurrentLocale]];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setRoundingMode:roundingMode];
    [numberFormatter setMaximumFractionDigits:fixLength];
    [numberFormatter setMinimumFractionDigits:fixLength];
    return [numberFormatter stringFromNumber:aNumber];
}

#pragma private methods


@end
