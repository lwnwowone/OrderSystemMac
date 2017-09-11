//
//  AppDelegate.m
//  OrderSystemMac
//
//  Created by AlancLiu on 06/09/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    [self InitALFramework];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma ALFramework init

-(void)InitALFramework{
    [self InitErrorMessage];
    [self initAlertMessage];
    [self initNetHelper];
}

- (void)initNetHelper {
    [ALNetworkHelper netWorkStatusChanged:^{
        NSString* status = @"NotReachable";
        if(1 == [ALNetworkHelper networkStatus])
            status = @"WiFi";
        else if(1 == [ALNetworkHelper networkStatus])
            status = @"Cellular";
        LOG_INFO([NSString stringWithFormat:@"Current network status = %@",status]);
    }];
}

-(void)InitErrorMessage{
    
}

-(void)initAlertMessage{
    
}

@end
