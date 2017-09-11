//
//  ALThousandSeparatorUitil.h
//  ALThreadPool
//
//  Created by 刘文楠 on 6/7/17.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALThousandSeparatorUitil : NSObject

+(instancetype)sharedInstance;

-(NSLocale *)getCurrentLocale;
-(void)setCurrentLocale:(NSLocale *)aLocale;
-(void)resetCurrentLocale;

-(NSString *)currentDot;
-(NSString *)currentSeparator;

-(NSString *)getPureNumberStringBySource:(NSString *)aString;

-(NSString *)getFixedFormattedStringByDecimalValue:(NSDecimalNumber *)aNumber andFixLength:(int)fixLength;
-(NSString *)getNoneFormattedStringByDecimalValue:(NSDecimalNumber * _Nonnull )aNumber andFixLength:(int)fixLength;
-(NSString *)getFormattedStringByDecimalValue:(NSDecimalNumber * _Nonnull )aNumber andFiexdDigits:(int)fixLength andRoundingMode:(NSNumberFormatterRoundingMode)roundingMode;

-(NSString *)getFormattedStringByDecimalValue:(NSDecimalNumber *)aNumber;
-(NSString *)getFormattedStringByDecimalValue:(NSDecimalNumber *)aNumber andFractionDigits:(int)digits;
-(NSString *)getFormattedStringByDecimalValue:(NSDecimalNumber *)aNumber andFractionDigits:(int)digits andRoundingMode:(NSNumberFormatterRoundingMode)roundingMode;

@end
