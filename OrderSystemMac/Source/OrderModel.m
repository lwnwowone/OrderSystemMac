//
//  OrderModel.m
//  OrderSystem
//
//  Created by AlancLiu on 05/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import "OrderModel.h"
#import "OrderAPIService.h"

static OrderModel *instance;

@implementation OrderModel{
    
@private NSString *currentUser;
@private OrderAPIService *apiService;
    
}

+(instancetype)sharedInstance{
    @synchronized (self) {
        if(!instance){
            instance = [OrderModel new];
            instance->apiService = [OrderAPIService new];
        }
        return instance;
    }
}

-(void)searchTodayOrdersWithFinishBlock:(void(^)(ALActionResultWithData *))callback{
    [ALTask runOneReturnDataTaskWithActionBlock:^ALActionResultWithData *{
        ALActionResultWithData *apiResult = [apiService searchTodayOrders];
        return apiResult;
    } andCallback:callback];
}

-(void)createOrderWithFinishBlock:(void(^)(ALActionResult *))callback{
    [ALTask runNoneReturnDataTaskWithActionBlock:^ALActionResult *{
        return [apiService createOrder];
    } andCallback:callback];
}

-(void)closeOrderWithFinishBlock:(void(^)(ALActionResult *))callback{
    [ALTask runNoneReturnDataTaskWithActionBlock:^ALActionResult *{
        return [apiService closeOrder];
    } andCallback:callback];
}

-(id)init{
    self = [super init];
    
    self.currentOrderState = false;
    
    return self;
}

@end
