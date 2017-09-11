//
//  OrderSystemHttpClient.m
//  DAE
//
//  Created by AlancLiu on 04/07/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import "ALConfig.h"
#import "OrderSystemHttpClient.h"
#import "ServicesEnvironment.h"
#import "NSString+ALExtension.h"



@implementation OrderSystemHttpClient

-(id)initWith:(NSString*)FunctionStr{
    self = [super init];
    self.contentType = DEFAULT_ALHTTP_CONTENT_TYPE;
    self.url = [self getUrlBy:FunctionStr];
    return self;
}

-(ALActionResultWithData*)doRequestUsing:(ALHttpMethod)method with:(NSDictionary*)params{
    return [self doRequestUsing:method with:params andHeader:nil];
}

-(ALActionResultWithData*)doRequestUsing:(ALHttpMethod)method with:(NSDictionary*)params andHeader:(NSDictionary *)header{
    ALActionResultWithData *funcResult = [ALActionResultWithData new];
    
    //生成请求头
    NSMutableDictionary *headerDic = [[self getDAEHttpHeader] mutableCopy];
    if(header){
        for (NSString *key in header) {
            [headerDic setValue:header[key] forKey:key];
        }
    }
    
    ALHttpRequest *alHttpRequest = [[ALHttpRequest alloc] initWithUrl:_url];
    alHttpRequest.contentType = self.contentType;
    funcResult = [alHttpRequest doRequestUsing:method with:params with:headerDic];
    
    NSString *statusCode = funcResult.extraData;
    NSString *logString = [NSString stringWithFormat:@"----------------------http request began----------------------\n"];
    logString = [logString stringByAppendingString:[NSString stringWithFormat:@"API path = %@\n",self.url]];
    if(HTTP_PARAMETER_OUTPUT_MODE){
        logString = [logString stringByAppendingString:[NSString stringWithFormat:@"request headers = %@\n",header]];
        logString = [logString stringByAppendingString:[NSString stringWithFormat:@"request parameter = %@\n",params]];
    }
    else{
        logString = [logString stringByAppendingString:[NSString stringWithFormat:@"request headers = %@\n",header.allKeys]];
        logString = [logString stringByAppendingString:[NSString stringWithFormat:@"request parameter = %@\n",params.allKeys]];
    }
    logString = [logString stringByAppendingString:@"----------------------http result----------------------\n"];
    logString = [logString stringByAppendingString:[NSString stringWithFormat:@"API result status is : %@\n",statusCode]];
    logString = [logString stringByAppendingString:[NSString stringWithFormat:@"%@\n",funcResult.data]];
    logString = [logString stringByAppendingString:@"----------------------http requeset eneded----------------------\n"];
    LOG_DEBUG(logString);
    
    if(statusCode && ![[statusCode substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"2"] && ![funcResult.errorCode isEqualToString:@"-ALE9998"]){
        funcResult.result = false;
        NSString *errorCode = [ALJsonHelper getJsonValueFromJsonString:funcResult.data andKey:@"error"].data;
        NSString *errorMessage = [ALJsonHelper getJsonValueFromJsonString:funcResult.data andKey:@"errorMessage"].data;
        funcResult.errorCode = errorCode;
        funcResult.errorMessage = errorMessage;
    }
    
    return funcResult;
}

-(NSDictionary *)getDAEHttpHeader{
    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] init];
    if(_needToken && [[ServicesEnvironment getToken] hasValue])
        [headerDic setObject:[ServicesEnvironment getToken] forKey:@"token"];
    else if(![[ServicesEnvironment getToken] hasValue] && _needToken){
        LOG_ERROR(@"!!!!!!!!!! ServicesEnvironment.Token is empty !!!!!!!!!!");
    }
    return headerDic;
}

-(NSString*)getUrlBy:(NSString*)functionStr{
    return [NSString stringWithFormat:@"%@/%@",[ServicesEnvironment serviceAPIAddress],functionStr];
}

+(ALActionResult *)runNoTokenAPIWithAPIAddress:(NSString *)apiAddress
                                 andParameters:(NSDictionary *)parameters
                              andRequestMethod:(ALHttpMethod)requestMethod{
    return [OrderSystemHttpClient runAPIWithAPIAddress:apiAddress andNeedToken:false andContentType:DEFAULT_ALHTTP_CONTENT_TYPE andHeaders:nil andParameters:parameters andRequestMethod:requestMethod andSucceededHandleBlock:nil];
}

+(ALActionResult *)runNoTokenAPIWithAPIAddress:(NSString *)apiAddress
                                 andParameters:(NSDictionary *)parameters
                              andRequestMethod:(ALHttpMethod)requestMethod
                                    andHeaders:(NSDictionary *)headers{
    return [OrderSystemHttpClient runAPIWithAPIAddress:apiAddress andNeedToken:false andContentType:DEFAULT_ALHTTP_CONTENT_TYPE andHeaders:headers andParameters:parameters andRequestMethod:requestMethod andSucceededHandleBlock:nil];
}

+(ALActionResult *)runNoTokenAPIWithAPIAddress:(NSString *)apiAddress
                                   andParameters:(NSDictionary *)parameters
                                andRequestMethod:(ALHttpMethod)requestMethod
                         andSucceededHandleBlock:(ALActionResult *(^)(ALActionResultWithData<NSString *> *httpResult))handleBlock{
    return [OrderSystemHttpClient runAPIWithAPIAddress:apiAddress andNeedToken:false andContentType:DEFAULT_ALHTTP_CONTENT_TYPE andHeaders:nil andParameters:parameters andRequestMethod:requestMethod andSucceededHandleBlock:handleBlock];
}

+(ALActionResult *)runNoTokenAPIWithAPIAddress:(NSString *)apiAddress
                                   andParameters:(NSDictionary *)parameters
                                andRequestMethod:(ALHttpMethod)requestMethod
                                      andHeaders:(NSDictionary *)headers
                         andSucceededHandleBlock:(ALActionResult *(^)(ALActionResultWithData<NSString *> *httpResult))handleBlock{
    return [OrderSystemHttpClient runAPIWithAPIAddress:apiAddress andNeedToken:false andContentType:DEFAULT_ALHTTP_CONTENT_TYPE andHeaders:headers andParameters:parameters andRequestMethod:requestMethod andSucceededHandleBlock:handleBlock];
}

+(ALActionResult *)runNeedTokenAPIWithAPIAddress:(NSString *)apiAddress
                       andParameters:(NSDictionary *)parameters
                    andRequestMethod:(ALHttpMethod)requestMethod
             andSucceededHandleBlock:(ALActionResult *(^)(ALActionResultWithData<NSString *> *httpResult))handleBlock{
    return [OrderSystemHttpClient runAPIWithAPIAddress:apiAddress andNeedToken:true andContentType:DEFAULT_ALHTTP_CONTENT_TYPE andHeaders:nil andParameters:parameters andRequestMethod:requestMethod andSucceededHandleBlock:handleBlock];
}

+(ALActionResult *)runNeedTokenAPIWithAPIAddress:(NSString *)apiAddress
                                   andParameters:(NSDictionary *)parameters
                                andRequestMethod:(ALHttpMethod)requestMethod
                                      andHeaders:(NSDictionary *)headers
                         andSucceededHandleBlock:(ALActionResult *(^)(ALActionResultWithData<NSString *> *httpResult))handleBlock{
    return [OrderSystemHttpClient runAPIWithAPIAddress:apiAddress andNeedToken:true andContentType:DEFAULT_ALHTTP_CONTENT_TYPE andHeaders:headers andParameters:parameters andRequestMethod:requestMethod andSucceededHandleBlock:handleBlock];
}

+(ALActionResult *)runNeedTokenAPIWithAPIAddress:(NSString *)apiAddress
                                   andParameters:(NSDictionary *)parameters
                                andRequestMethod:(ALHttpMethod)requestMethod{
    return [OrderSystemHttpClient runAPIWithAPIAddress:apiAddress andNeedToken:true andContentType:DEFAULT_ALHTTP_CONTENT_TYPE andHeaders:nil andParameters:parameters andRequestMethod:requestMethod andSucceededHandleBlock:nil];
}

+(ALActionResult *)runNeedTokenAPIWithAPIAddress:(NSString *)apiAddress
                                   andParameters:(NSDictionary *)parameters
                                andRequestMethod:(ALHttpMethod)requestMethod
                                      andHeaders:(NSDictionary *)headers{
    return [OrderSystemHttpClient runAPIWithAPIAddress:apiAddress andNeedToken:true andContentType:DEFAULT_ALHTTP_CONTENT_TYPE andHeaders:headers andParameters:parameters andRequestMethod:requestMethod andSucceededHandleBlock:nil];
}

+(ALActionResult *)runAPIWithAPIAddress:(NSString *)apiAddress
                        andNeedToken:(bool)needToken
                      andContentType:(ALHttpContentType)contentType
                          andHeaders:(NSDictionary *)headers
                       andParameters:(NSDictionary *)parameters
                    andRequestMethod:(ALHttpMethod)requestMethod
             andSucceededHandleBlock:(ALActionResult *(^)(ALActionResultWithData<NSString *> *httpResult))handleBlock{
    ALActionResult *funcResult = nil;

    OrderSystemHttpClient *client = [[OrderSystemHttpClient alloc] initWith:apiAddress];
    client.contentType = contentType;
    client.needToken = needToken;
    
    LOG_INFO([NSString stringWithFormat:@"%@ API method bagan", apiAddress]);
    ALActionResultWithData<NSString *> *httpResult = [client doRequestUsing:requestMethod with:parameters andHeader:headers];
    if(httpResult.result){
        @try {
            if(handleBlock){
                ALActionResult *tmpResult = handleBlock(httpResult);
                if(tmpResult)
                    funcResult = [tmpResult copy];
                else
                    funcResult = [httpResult copy];
            }
            else
                funcResult = [httpResult copy];
        }
        @catch (NSException *exception) {
            LOG_ERROR(exception.reason);
            funcResult = [ALActionResult new];
            [funcResult internalError];
        }
    }
    else{
        funcResult = [ALActionResult new];
        [funcResult copyErrorInfoFrom:httpResult];
    }
    LOG_INFO([NSString stringWithFormat:@"%@ API method finished", apiAddress]);
    return funcResult;
}

@end
