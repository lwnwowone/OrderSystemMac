//
//  ALActionResult.h
//  ALThreadPool
//
//  Created by Alanc Liu on 22/03/2017.
//  Copyright © 2017 Alanc Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALActionResult : NSObject


@property (nonatomic) bool result;
@property (nonatomic) NSString *errorMessage;
@property (nonatomic) NSString *errorCode;
@property (nonatomic) id extraData;


-(ALActionResult *)copy;
-(void)copyErrorInfoFrom:(ALActionResult *)theResult;
-(void)internalError;

@end

@interface ALActionResultWithData<T> : ALActionResult

@property T data;

@end


@interface ALActionResultWith2Data<T1,T2> : ALActionResultWithData<T1>

@property T2 data2;

@end

@interface ALActionResultWith3Data<T1,T2,T3> : ALActionResultWith2Data<T1,T2>

@property T3 data3;

@end
