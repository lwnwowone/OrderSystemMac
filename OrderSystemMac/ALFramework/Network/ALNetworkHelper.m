//
//  NetworkHelper.m
//  ALThreadPool
//
//  Created by Alanc Liu on 23/03/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import "ALNetworkHelper.h"
#import "Reachability.h"

@interface ALNetworkHelper()

@property (nonatomic) ALNetworkStatus currentStatus;
@property (nonatomic,strong) void (^notifiBlock)();

@end

static Reachability* reachabilityInstance;
static ALNetworkHelper* instance;

@implementation ALNetworkHelper

+(ALNetworkStatus)networkStatus{
    return [instance currentStatus];
}

+(int)timeOutTime{
    return 30;
}

+(void)netWorkStatusChanged:(void(^)())notifiBlock{
    if(nil == instance)
        instance = [ALNetworkHelper new];
    instance.notifiBlock = notifiBlock;
}

#pragma private methods

-(id)init{
    self = [super init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    NSString *remoteHostName = @"www.apple.com";
    reachabilityInstance = [Reachability reachabilityWithHostName:remoteHostName];
    [reachabilityInstance startNotifier];
    [self updateInterfaceWithReachability:reachabilityInstance];
    
    return self;
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    if(reachability.currentReachabilityStatus == NotReachable)
        _currentStatus = ALNetworkStatusNotReachable;
    else if(reachability.currentReachabilityStatus == ReachableViaWWAN)
        _currentStatus = ALNetworkStatusCellular;
    else if(reachability.currentReachabilityStatus == ReachableViaWiFi)
        _currentStatus = ALNetworkStatusWiFi;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(notifyStatus)
                                               object:nil];
    [self performSelector:@selector(notifyStatus) withObject:nil afterDelay:1];
}

-(void)notifyStatus{
    if(instance.notifiBlock)
        [instance.notifiBlock invoke];
}

@end
