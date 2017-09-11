//
//  ALLogMeta.mm
//  DAE
//
//  Created by AlancLiu on 27/07/2017.
//  Copyright © 2017 Huiyin. All rights reserved.
//

#import "ALLogMeta.h"
#import "ALDateUitil.h"

@implementation ALLogMeta

-(id)init{
    self = [super init];
    
    self.time = [ALDateUitil getCurrentDate];
    self.timestamp = [ALDateUitil getCurrentTimestamp];
    
    return self;
}

@end
