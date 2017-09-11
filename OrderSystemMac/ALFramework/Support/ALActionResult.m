//
//  ActionResult.m
//  ALThreadPool
//
//  Created by Alanc Liu on 22/03/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import "ALActionResult.h"
#import "ALActionResultStandardError.h"

@implementation ALActionResult

-(id)init{
    self = [super init];
    _result = NO;
    _errorCode = @"";
    _errorMessage = @"";
    return self;
}

-(ALActionResult *)copy{
    ALActionResult *newResult = [ALActionResult new];
    newResult.result = self.result;
    newResult.errorCode = self.errorCode;
    newResult.errorMessage = self.errorMessage;
    return newResult;
}

-(void)copyErrorInfoFrom:(ALActionResult *)theResult{
    self.result = theResult.result;
    self.errorCode = theResult.errorCode;
    self.errorMessage = theResult.errorMessage;
}

-(void)internalError{
    [ALActionResultStandardError applicationError:self];
}

@end

@implementation ALActionResultWithData

-(id)init
{
    self = [super init];
    _data = nil;
    return self;
}

-(ALActionResultWithData *)copy{
    ALActionResultWithData *newResult = [ALActionResultWithData new];
    newResult.result = self.result;
    newResult.errorCode = self.errorCode;
    newResult.errorMessage = self.errorMessage;
    newResult.data = self.data;
    return newResult;
}

@end

@implementation ALActionResultWith2Data

-(id)init
{
    self = [super init];
    _data2 = nil;
    return self;
}

-(ALActionResultWith2Data *)copy{
    ALActionResultWith2Data *newResult = [ALActionResultWith2Data new];
    newResult.result = self.result;
    newResult.errorCode = self.errorCode;
    newResult.errorMessage = self.errorMessage;
    newResult.data = self.data;
    newResult.data2 = self.data2;
    return newResult;
}

@end

@implementation ALActionResultWith3Data

-(id)init
{
    self = [super init];
    _data3 = nil;
    return self;
}

-(ALActionResultWith3Data *)copy{
    ALActionResultWith3Data *newResult = [ALActionResultWith3Data new];
    newResult.result = self.result;
    newResult.errorCode = self.errorCode;
    newResult.errorMessage = self.errorMessage;
    newResult.data = self.data;
    newResult.data2 = self.data2;
    newResult.data3 = self.data3;
    return newResult;
}

@end
