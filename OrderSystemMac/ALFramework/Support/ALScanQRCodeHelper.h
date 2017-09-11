//  ALScanQRCodeHelper.h

// FIXME:iOS10权限
/**
 <key>NSCameraUsageDescription</key>
 <key>NSPhotoLibraryUsageDescription</key>
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ALScanQRCodeHelper : NSObject

//第一步：创建声明单例方法
+(instancetype)sharedInstance;

@property (nonatomic,strong) UIView *scanView;

@property (nonatomic) void(^scanBlock)(NSString *scanResult);

-(void)addLayer:(UIView *)viewContainer;

-(void)setScanningRect:(CGRect)scanRect scanView:(UIView *)scanView;

-(void)startRunning;
-(void)stopRunning;

-(void)showLayer;
-(void)hideLayer;

@end
