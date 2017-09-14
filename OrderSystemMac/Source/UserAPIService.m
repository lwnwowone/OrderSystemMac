//
//  UserAPIService.m
//  OrderSystem
//
//  Created by AlancLiu on 05/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import "UserAPIService.h"
#import "OrderSystemHttpClient.h"
#import "ServicesEnvironment.h"
#import "UserMeta.h"

@implementation UserAPIService

-(ALActionResultWithData *)registerWith:(NSString *)username
                            andPassword:(NSString *)password{
    NSDictionary *parameters = @{@"username":username,
                                 @"password":password};
    
    return (ALActionResultWithData *)[OrderSystemHttpClient runNoTokenAPIWithAPIAddress:@"register"
                                                                          andParameters:parameters
                                                                       andRequestMethod:ALHttpMethodPost
                                                                andSucceededHandleBlock:^ALActionResult *(ALActionResultWithData<NSString *> *httpResult) {
                                                                    ALActionResultWithData *apiResult = [ALActionResultWithData new];
                                                                    ALActionResultWithData *loadResult = [ALJsonHelper getJsonObjectFromJsonString:httpResult.data];
                                                                    if(loadResult.result && [loadResult.data isKindOfClass:[NSDictionary class]]){
                                                                        NSDictionary *jsonDic = loadResult.data;
                                                                        NSString *token = jsonDic[@"token"];
                                                                        apiResult.data = token;
                                                                        [ServicesEnvironment setToken:token];
                                                                        apiResult.result = true;
                                                                    }
                                                                    else
                                                                        [apiResult copyErrorInfoFrom:loadResult];
                                                                    return apiResult;
                                                                }];
}

-(ALActionResultWithData *)loginWith:(NSString *)username
                         andPassword:(NSString *)password{
    NSDictionary *parameters = @{@"username":username,
                                 @"password":password};
    
    return (ALActionResultWithData *)[OrderSystemHttpClient runNoTokenAPIWithAPIAddress:@"login"
                                                                          andParameters:parameters
                                                                       andRequestMethod:ALHttpMethodPost
                                                                andSucceededHandleBlock:^ALActionResult *(ALActionResultWithData<NSString *> *httpResult) {
                                                                    ALActionResultWithData *apiResult = [ALActionResultWithData new];
                                                                    ALActionResultWithData *loadResult = [ALJsonHelper getJsonObjectFromJsonString:httpResult.data];
                                                                    if(loadResult.result && [loadResult.data isKindOfClass:[NSDictionary class]]){
                                                                        NSDictionary *jsonDic = loadResult.data;
                                                                        NSString *token = jsonDic[@"token"];
                                                                        apiResult.data = token;
                                                                        [ServicesEnvironment setToken:token];
                                                                        apiResult.result = true;
                                                                    }
                                                                    else
                                                                        [apiResult copyErrorInfoFrom:loadResult];
                                                                    return apiResult;
                                                                }];
}

-(ALActionResult *)changePasswordWithOPassword:(NSString *)oPassword
                                andNewPassword:(NSString *)nPassword{
    NSDictionary *parameters = @{@"oPassword":oPassword,
                                 @"nPassword":nPassword};
    
    return [OrderSystemHttpClient runNeedTokenAPIWithAPIAddress:@"password/change"
                                                  andParameters:parameters
                                               andRequestMethod:ALHttpMethodPut];
}

-(ALActionResultWith2Data *)getProfile{
    return (ALActionResultWith2Data *)[OrderSystemHttpClient runNeedTokenAPIWithAPIAddress:@"profile"
                                                                            andParameters:nil
                                                                         andRequestMethod:ALHttpMethodGet
                                                                  andSucceededHandleBlock:^ALActionResult *(ALActionResultWithData<NSString *> *httpResult) {
                                                                      ALActionResultWith2Data *apiResult = [ALActionResultWith2Data new];
                                                                      ALActionResultWithData *loadResult = [ALJsonHelper getJsonObjectFromJsonString:httpResult.data];
                                                                      if(loadResult.result && [loadResult.data isKindOfClass:[NSDictionary class]]){
                                                                          NSDictionary *jsonDic = loadResult.data;
                                                                          UserMeta *meta = [[UserMeta alloc] initWithInfoDic:jsonDic];
                                                                          apiResult.data = meta;
                                                                          apiResult.data2 = jsonDic[@"hasOrdered"];
                                                                          apiResult.result = true;
                                                                      }
                                                                      else
                                                                          [apiResult copyErrorInfoFrom:loadResult];
                                                                      return apiResult;
                                                                  }];
}

@end
