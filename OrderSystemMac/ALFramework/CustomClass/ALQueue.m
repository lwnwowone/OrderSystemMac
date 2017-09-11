//
//  ALQueue.m
//  Pods
//
//  Created by AlancLiu on 28/08/2017.
//
//

#import "ALQueue.h"

@implementation ALQueue

-(id)init{
    self = [super init];
    operationArray = [NSMutableArray new];
    return self;
}

-(void)enqueue:(id)aObject{
    [operationArray addObject:aObject];
    [self.objectEnqueue invoke];
}

-(id)dequeue{
    id dObj = nil;
    if(operationArray.count > 0){
        dObj = [operationArray objectAtIndex:0];
        [operationArray removeObjectAtIndex:0];
    }
    return dObj;
}

-(id)objectAtIndex:(int)index{
    return [operationArray objectAtIndex:index];
}

-(int)count{
    return (int)operationArray.count;
}

@end
