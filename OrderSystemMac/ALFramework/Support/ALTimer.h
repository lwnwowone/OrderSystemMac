//
//  ALTimer.h
//  DAE
//
//  Created by 刘文楠 on 7/10/17.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALTimer : NSObject

@property (nonatomic) void(^timerfired)();

-(void)runTimer;
-(void)stopTimer;

@end
