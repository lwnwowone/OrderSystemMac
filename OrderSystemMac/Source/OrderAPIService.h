//
//  OrderAPIService.h
//  OrderSystem
//
//  Created by AlancLiu on 05/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderAPIService : NSObject

-(ALActionResultWithData *)searchTodayOrders;
-(ALActionResult *)createOrder;
-(ALActionResult *)closeOrder;

@end
