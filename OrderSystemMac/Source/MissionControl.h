//
//  MissionControl.h
//  DAE
//
//  Created by AlancLiu on 30/06/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MissionControl : NSObject

+(void)startNewMissionWithoutIndicator:(NSString *)missionID;
+(void)startNewMission:(NSString *)missionID;
+(void)missionComplete:(NSString *)missionID;

@end
