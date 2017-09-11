//
//  ALQueue.h
//  Pods
//
//  Created by AlancLiu on 28/08/2017.
//
//

#import <Foundation/Foundation.h>

@interface ALQueue : NSObject{
@protected NSMutableArray *operationArray;
}

-(void)enqueue:(id)aObject;
-(id)dequeue;

-(id)objectAtIndex:(int)index;

@property (nonatomic) void (^objectEnqueue)();

@property (nonatomic,readonly) int count;

@end
