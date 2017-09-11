//
//  NetworkHelper.h
//  ALThreadPool
//
//  Created by Alanc Liu on 23/03/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    ALNetworkStatusNotReachable,
    ALNetworkStatusWiFi,
    ALNetworkStatusCellular
}ALNetworkStatus;

@interface ALNetworkHelper : NSObject

+(void)netWorkStatusChanged:(void(^)())notifiBlock;

+(ALNetworkStatus)networkStatus;
+(int)timeOutTime;

@end
