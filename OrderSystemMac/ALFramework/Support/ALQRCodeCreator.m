//
//  ALQRCodeCreator.m
//  TestQR
//
//  Created by AlancLiu on 29/06/2017.
//  Copyright © 2017 AlancLiu. All rights reserved.
//

#import "ALQRCodeCreator.h"

// Level L (Low)	7% of codewords can be restored.
// Level M (Medium) 15% of codewords can be restored.
// Level Q (Quartile) 25% of codewords can be restored.
// Level H (High) 30% of codewords can be restored.

@implementation ALQRCodeCreator

+(UIImage *)getQRCodeByContent:(NSString *)content andimageLength:(float)imageLength{
    return [[ALQRCodeCreator new] getQRCodeImageByContent:content andLength:imageLength];
}

-(UIImage *)getQRCodeImageByContent:(NSString *)content andLength:(float)length{
    CIImage *tmpImg = [self createQRForString:content andLevel:@"M"];
    return [self createNonInterpolatedUIImageFormCIImage:tmpImg andLength:length];
}

-(CIImage *)createQRForString:(NSString *)content andLevel:(NSString *)level{
    NSData *strData = [content dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:strData forKey:@"inputMessage"];
    [qrFilter setValue:level forKey:@"inputCorrectionLevel"];
    return qrFilter.outputImage;
}

-(UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image andLength:(float)length{
    CGRect extentRect = image.extent;
    float scale = MIN(length/extentRect.size.width, length/extentRect.size.height);
    
    int width = extentRect.size.width * scale;
    int height = extentRect.size.height * scale;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bigmapImage = [context createCGImage:image fromRect:extentRect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extentRect, bigmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    return [[UIImage alloc] initWithCGImage:scaledImage];
}

@end
