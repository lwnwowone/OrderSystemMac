//
//  OrderModel.h
//  OrderSystem
//
//  Created by AlancLiu on 05/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (nonatomic) bool currentOrderState;

+(instancetype)sharedInstance;

-(void)searchTodayOrdersWithFinishBlock:(void(^)(ALActionResultWithData *))callback;
-(void)createOrderWithFinishBlock:(void(^)(ALActionResult *))callback;
-(void)closeOrderWithFinishBlock:(void(^)(ALActionResult *))callback;

@end
