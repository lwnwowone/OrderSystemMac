//
//  MissionControl.m
//  DAE
//
//  Created by AlancLiu on 30/06/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import "MissionControl.h"

static NSMutableArray *missionList;
static NSMutableArray *backgroundMissionList;

@implementation MissionControl

+(void)startNewMissionWithoutIndicator:(NSString *)missionID{
    if(!backgroundMissionList)
        backgroundMissionList = [NSMutableArray new];
    
    [backgroundMissionList addObject:missionID];
}

+(void)startNewMission:(NSString *)missionID{
    if(!missionList)
        missionList = [NSMutableArray new];
    
    [missionList addObject:missionID];
    
    //Show loading indicator
}

+(void)missionComplete:(NSString *)missionID{
    if(missionList && [missionList containsObject:missionID]){
        [missionList removeObject:missionID];
        
        if(0 == missionList.count){
            [ALBasicToolBox runFunctionInMainThread:^{
                //Remove loading indicator
            }];
        }
    }
    else if(backgroundMissionList && [backgroundMissionList containsObject:missionID]){
        [backgroundMissionList removeObject:missionID];
    }
}

@end
