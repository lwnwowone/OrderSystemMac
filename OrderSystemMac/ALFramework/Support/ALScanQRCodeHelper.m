//  ALScanQRCodeHelper.m

#import "ALScanQRCodeHelper.h"
#import <AVFoundation/AVFoundation.h>

@interface ALScanQRCodeHelper() <AVCaptureMetadataOutputObjectsDelegate>{
    AVCaptureSession *_session;             //输入输出的中间桥梁
    AVCaptureVideoPreviewLayer *_layer;     //捕捉视频预览层
    AVCaptureMetadataOutput *_output;       //捕获元数据输出
    AVCaptureDeviceInput *_input;           //采集设备输入
    UIView *_viewContainer;                 //装载图层
}

@end

@implementation ALScanQRCodeHelper

+ (instancetype)sharedInstance
{
    static ALScanQRCodeHelper *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[ALScanQRCodeHelper alloc] init];
    });
    return singleton;
}

//初始化-单例，只调用一次
- (id)init
{
    self = [super init];
    if (self) {
        //初始化链接对象
        _session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
        
        // MARK: 避免模拟器运行崩溃
        if(!TARGET_IPHONE_SIMULATOR) {
            //获取摄像设备
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            //创建输入流
            _input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            [_session addInput:_input];
            
            //创建输出流
            _output = [[AVCaptureMetadataOutput alloc]init];
            //设置代理 在主线程里刷新
            [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            [_session addOutput:_output];
            //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
            _output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                            AVMetadataObjectTypeEAN13Code,
                                            AVMetadataObjectTypeEAN8Code,
                                            AVMetadataObjectTypeCode128Code];
            
            // 要在addOutput之后，否则iOS10会崩溃
            _layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
            _layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        }
    }
    return self;
}

//销毁对象
- (void)dealloc
{
    _scanView = nil;
    _scanBlock = nil;
}

- (void)startRunning {
    //避免模拟器运行崩溃
    if(!TARGET_IPHONE_SIMULATOR) {
        [_session startRunning];
    }
    
}

- (void)stopRunning {
    //避免模拟器运行崩溃
    if(!TARGET_IPHONE_SIMULATOR) {
        [_session stopRunning];
    }
}

- (void)addLayer:(UIView *)viewContainer
{
    _viewContainer = viewContainer;
    _layer.frame = _viewContainer.layer.frame;
    [_viewContainer.layer insertSublayer:_layer atIndex:0];
}

- (void)setScanningRect:(CGRect)scanRect scanView:(UIView *)scanView
{
    CGFloat x,y,width,height;
    
    x = scanRect.origin.y / _layer.frame.size.height;
    y = scanRect.origin.x / _layer.frame.size.width;
    width = scanRect.size.height / _layer.frame.size.height;
    height = scanRect.size.width / _layer.frame.size.width;
    
    _output.rectOfInterest = CGRectMake(x, x, width, height);
    
    self.scanView = scanView;
    if (self.scanView) {
        self.scanView.frame = scanRect;
        if (_viewContainer) {
            [_viewContainer addSubview:self.scanView];
        }
    }
}

-(void)showLayer{
    _layer.hidden = false;
}

-(void)hideLayer{
    _layer.hidden = true;
}

#pragma mark - AVCaptureMetadataOutputObjects Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count > 0) {
        //[_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];
        
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"scanner_tip" ofType:@"wav"];
        NSData *soundData = [NSData dataWithContentsOfFile:soundPath];
        if(soundData){
            NSError *error = [NSError new];
            AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
            [player play];
        }
        
        if (self.scanBlock) {
            self.scanBlock(metadataObject.stringValue);
        }
    }
}

@end
