//
//  ALJsonHelper.m
//  ALThreadPool
//
//  Created by Alanc Liu on 26/05/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import "ALJsonHelper.h"
#import "ALLogHelper.h"

@implementation ALJsonHelper

+(ALActionResultWithData<NSString *> *)getJsonStringFromJsonObject:(id)jDic{
    ALActionResultWithData *funcResult = [ALActionResultWithData new];

    if(!jDic){
        funcResult.data = @"";
        funcResult.result = true;
    }
    else{
        @try {
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jDic options:0 error:nil];
            funcResult.data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            funcResult.result = true;
        } @catch (NSException *exception) {
            LOG_ERROR([NSString stringWithFormat:@"getJsonStringFromDictionary method failed, reason is %@",exception.reason]);
            [funcResult internalError];
        }
    }
    
    return funcResult;
}

+(ALActionResultWithData *)getJsonObjectFromJsonString:(NSString *)jsonStr{
    ALActionResultWithData *funcResult = [ALActionResultWithData new];
    @try {
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        funcResult = [ALJsonHelper getJsonObjectFromJsonData:jsonData];
        funcResult.result = true;
    }
    @catch (NSException *exception) {
        LOG_ERROR([NSString stringWithFormat:@"loadJsonDicFromJsonString method failed, reason is %@",exception.reason]);
        [funcResult internalError];
    }
    return funcResult;
}

+(ALActionResultWithData *)getJsonValueFromJsonString:(NSString *)jStr andKey:(NSString *)key{
    ALActionResultWithData *funcResult = [ALActionResultWithData new];
    @try {
        NSData *jsonData = [jStr dataUsingEncoding:NSUTF8StringEncoding];
        ALActionResultWithData *loadResult = [ALJsonHelper getJsonObjectFromJsonData:jsonData];
        if(loadResult.result && [loadResult.data isKindOfClass:[NSDictionary class]]){
            NSDictionary *jsonDic = (NSDictionary *)loadResult.data;
            id retrunData = jsonDic[key];
            funcResult.data = retrunData == [NSNull null] ? nil : retrunData;
            funcResult.result = true;
        }
        else
            [funcResult copyErrorInfoFrom:loadResult];
    }
    @catch (NSException *exception) {
        LOG_ERROR([NSString stringWithFormat:@"getJsonValueFromJsonString method failed, reason is %@",exception.reason]);
        [funcResult internalError];
    }
    return funcResult;
}

+(ALActionResultWithData *)getJsonObjectFromFile:(NSString *)jsonFilePath{
    ALActionResultWithData *funcResult = [ALActionResultWithData new];
    @try {
        NSData *jsonData = [[NSData alloc]initWithContentsOfFile:jsonFilePath];
        funcResult = [ALJsonHelper getJsonObjectFromJsonData:jsonData];
        funcResult.result = true;
    }
    @catch (NSException *exception) {
        LOG_ERROR([NSString stringWithFormat:@"loadJsonDicFromFile method failed, reason is %@",exception.reason]);
        [funcResult internalError];
    }
    return funcResult;
}

+(ALActionResultWithData *)getJsonObjectFromResource:(NSString *)resourceFileName{
    NSString *jsonFilePath = [[NSBundle mainBundle] pathForResource:resourceFileName ofType:@"json"];
    return [ALJsonHelper getJsonObjectFromFile:jsonFilePath];
}

+(ALActionResultWithData *)getJsonValueFromResource:(NSString *)resourceFileName andKey:(NSString *)key{
    ALActionResultWithData *funcResult = [ALActionResultWithData new];
    @try {
        ALActionResultWithData *loadResult = [ALJsonHelper getJsonObjectFromResource:resourceFileName];
        if(loadResult.result && [loadResult.data isKindOfClass:[NSDictionary class]]){
            NSDictionary *jsonDic = (NSDictionary *)loadResult.data;
            id retrunData = jsonDic[key];
            funcResult.data = retrunData == [NSNull null] ? nil : retrunData;
            funcResult.result = true;
        }
        else
            [funcResult copyErrorInfoFrom:loadResult];
    }
    @catch (NSException *exception) {
        LOG_ERROR([NSString stringWithFormat:@"getJsonValueFromResource method failed, reason is %@",exception.reason]);
        [funcResult internalError];
    }
    return funcResult;
}

#pragma private method

+(ALActionResultWithData *)getJsonObjectFromJsonData:(NSData *)jData{
    ALActionResultWithData *funcResult = [ALActionResultWithData new];
    @try {
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jData options:NSJSONReadingAllowFragments error:nil];
        funcResult.data = jsonObject == [NSNull null] ? nil : jsonObject;
        funcResult.result = true;
    }
    @catch (NSException *exception) {
        [funcResult internalError];
        LOG_ERROR([NSString stringWithFormat:@"getJsonValueFromJsonData method failed, reason is %@",exception.reason]);
    }
    return funcResult;
}


@end
