//
//  OrderAPIService.m
//  OrderSystem
//
//  Created by AlancLiu on 05/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import "OrderAPIService.h"
#import "OrderSystemHttpClient.h"
#import "OrderMeta.h"

@implementation OrderAPIService

-(ALActionResultWithData *)searchTodayOrders{
    return (ALActionResultWithData *)[OrderSystemHttpClient runNeedTokenAPIWithAPIAddress:@"order/todayOrders"
                                                                            andParameters:nil
                                                                         andRequestMethod:ALHttpMethodGet
                                                                  andSucceededHandleBlock:^ALActionResult *(ALActionResultWithData<NSString *> *httpResult) {
                                                                      ALActionResultWithData *apiResult = [ALActionResultWithData new];
                                                                      ALActionResultWithData *loadResult = [ALJsonHelper getJsonObjectFromJsonString:httpResult.data];

                                                                      if(loadResult.result && [loadResult.data isKindOfClass:[NSDictionary class]]){
                                                                          NSDictionary *jsonDic = loadResult.data;
                                                                          NSMutableArray *resultArray = [NSMutableArray new];
                                                                          for (NSDictionary *infoDic in jsonDic[@"orderList"]) {
                                                                              OrderMeta *tMeta = [[OrderMeta alloc] initWithInfoDic:infoDic];
                                                                              [resultArray addObject:tMeta];
                                                                          }
                                                                          apiResult.data = [resultArray copy];
                                                                          apiResult.result = true;
                                                                      }
                                                                      else
                                                                          [apiResult copyErrorInfoFrom:loadResult];
                                                                      return apiResult;
                                                                  }];
}

-(ALActionResult *)createOrder{
    return [OrderSystemHttpClient runNeedTokenAPIWithAPIAddress:@"order/create"
                                                  andParameters:nil
                                               andRequestMethod:ALHttpMethodPost];
}

-(ALActionResult *)closeOrder{
    return [OrderSystemHttpClient runNeedTokenAPIWithAPIAddress:@"order/remove"
                                                  andParameters:nil
                                               andRequestMethod:ALHttpMethodPost];
}

@end
