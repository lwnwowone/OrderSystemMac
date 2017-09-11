//
//  UserModel.m
//  OrderSystem
//
//  Created by AlancLiu on 05/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import "UserModel.h"
#import "UserAPIService.h"
#import "OrderModel.h"

static UserModel *instance;

@implementation UserModel{
    
@private UserAPIService *apiService;

}

+(instancetype)sharedInstance{
    @synchronized (self) {
        if(!instance){
            instance = [UserModel new];
            instance->apiService = [UserAPIService new];
        }
        return instance;
    }
}

-(void)registerWithUsername:(NSString *)username andPassword:(NSString *)password andFinishBlock:(void(^)(ALActionResult *))callback{
    [ALTaskChain runTwoTasksWithActionOne:^ALActionResult *(NSArray<ALTask *> *taskGroup) {
        return [apiService registerWith:username andPassword:password];
    } andActionTwo:^ALActionResult *(NSArray<ALTask *> *taskGroup) {
        ALActionResultWith2Data *apiResult = [apiService getProfile];
        if(apiResult.result){
            self.currentUser = apiResult.data;
            [OrderModel sharedInstance].currentOrderState = [apiResult.data2 isEqualToString:@"true"];
        }
        return apiResult;
    } andCallback:callback];
}

-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password andFinishBlock:(void(^)(ALActionResult *))callback{
    [ALTaskChain runTwoTasksWithActionOne:^ALActionResult *(NSArray<ALTask *> *taskGroup) {
        return [apiService loginWith:username andPassword:password];
    } andActionTwo:^ALActionResult *(NSArray<ALTask *> *taskGroup) {
        ALActionResultWith2Data *apiResult = [apiService getProfile];
        if(apiResult.result){
            self.currentUser = apiResult.data;
            [OrderModel sharedInstance].currentOrderState = [apiResult.data2 isEqualToString:@"true"];
        }
        return apiResult;
    } andCallback:callback];
}

-(void)autoLoginWithFinishBlock:(void(^)(ALActionResult *))callback{
    [ALTask runNoneReturnDataTaskWithActionBlock:^ALActionResult *{
        ALActionResultWith2Data *apiResult = [apiService getProfile];
        if(apiResult.result){
            self.currentUser = apiResult.data;
            [OrderModel sharedInstance].currentOrderState = [apiResult.data2 isEqualToString:@"true"];
        }
        return apiResult;
    } andCallback:callback];
}

@end
