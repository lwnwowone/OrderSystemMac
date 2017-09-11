//
//  ALQRCodeCreator.h
//  TestQR
//
//  Created by AlancLiu on 29/06/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ALQRCodeCreator : NSObject

+(UIImage *)getQRCodeByContent:(NSString *)content andimageLength:(float)imageLength;

@end
