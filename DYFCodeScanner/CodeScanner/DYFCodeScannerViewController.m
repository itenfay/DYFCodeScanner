//
//  DYFCodeScannerViewController.m
//
//  Created by dyf on 2018/01/28.
//  Copyright © 2018年 dyf. All rights reserved.
//

#import "DYFCodeScannerViewController.h"
#import "DYFCodeScannerPreView.h"
#import "DYFCodeScannerMacros.h"
#import "UIImage+DYFQRExtension.h"

@interface DYFCodeScannerViewController () <AVCaptureMetadataOutputObjectsDelegate, DYFCodeScannerPreViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) AVCaptureSession     *session; // 会话
@property (nonatomic, strong) AVCaptureDeviceInput *input;   // 输入流
@property (nonatomic, strong) DYFCodeScannerPreView *preView; // 预览视图
@property (nonatomic, assign) UIStatusBarStyle     originStatusBarStyle;
@end

@implementation DYFCodeScannerViewController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self initConfig];
    }
    
    return self;
}

- (void)initConfig {
    self.scanType = DYFCodeScannerTypeAll;
}

- (void)setNavigationBarHidden:(BOOL)hidden {
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = hidden;
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomView];
    [self setTips];
    [self requestAccess];
}

- (void)setTips {
    if (self.tipStr && self.tipStr.length > 0) {
        self.preView.tipLabel.text = self.tipStr;
    }
}

- (void)requestAccess {
    @DYFWeakObject(self)
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (granted) {
                [weak_self addScanView];
            } else {
                NSString *msg = @"请在“设置”-“隐私”-“相机”选项中，允许App访问你的相机";
                
                if (weak_self.resultHandler) {
                    weak_self.resultHandler(NO, msg);
                }
                
                DYFLog(@"E | %@", msg);
            }
            
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    
    if (self.session) {
        [self.session startRunning];
    }
    
    [self.preView startScan];
    
    [self setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:self.originStatusBarStyle animated:YES];
    
    if (self.session) {
        [self.session stopRunning];
    }
    
    [self.preView stopScan];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self setNavigationBarHidden:NO];
}

- (DYFCodeScannerPreView *)preView {
    if (!_preView) {
        _preView = [[DYFCodeScannerPreView alloc] initWithFrame:self.view.bounds];
        _preView.delegate = self;
    }
    return _preView;
}

- (void)addCustomView {
    [self.view addSubview:self.preView];
}

- (void)addScanView {
    // 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    // 创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 设置代理在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    [self setInput:input];
    [self checkTorch];
    
    // 会话
    self.session = [[AVCaptureSession alloc] init];
    
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    if([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    
    // 设置数据采集质量
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    // 设置扫码支持的编码格式
    switch (self.scanType) {
        case DYFCodeScannerTypeAll:
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,
                                           AVMetadataObjectTypeEAN13Code,
                                           AVMetadataObjectTypeEAN8Code,
                                           AVMetadataObjectTypeUPCECode,
                                           AVMetadataObjectTypeCode39Code,
                                           AVMetadataObjectTypeCode39Mod43Code,
                                           AVMetadataObjectTypeCode93Code,
                                           AVMetadataObjectTypeCode128Code,
                                           AVMetadataObjectTypePDF417Code];
            break;
            
        case DYFCodeScannerTypeQRCode:
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
            break;
            
        case DYFCodeScannerTypeBarcode:
            output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                           AVMetadataObjectTypeEAN8Code,
                                           AVMetadataObjectTypeUPCECode,
                                           AVMetadataObjectTypeCode39Code,
                                           AVMetadataObjectTypeCode39Mod43Code,
                                           AVMetadataObjectTypeCode93Code,
                                           AVMetadataObjectTypeCode128Code,
                                           AVMetadataObjectTypePDF417Code];
            break;
            
        default:
            break;
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
    previewLayer.frame = self.view.layer.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    // 将预览层添加到界面中
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
    [self.session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (!self.preView.isReading) {
        return;
    }
    
    if (metadataObjects.count > 0) {
        
        [self.session stopRunning];
        [self.preView stopScan];
        
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        NSString *result = metadataObject.stringValue;
        
        [self captureOutputWithCompletion:^{
            if (self.resultHandler) {
                self.resultHandler(result ? YES : NO, result);
            }
        }];
    }
}

- (void)captureOutputWithCompletion:(void (^)(void))completion {
    UINavigationController *nc = self.navigationController;
    if (nc) {
        if (nc.viewControllers.count == 1) {
            [nc dismissViewControllerAnimated:YES completion:completion];
        } else {
            [nc popViewControllerAnimated:YES];
            if (completion) {
                completion();
            }
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:completion];
    }
}

- (void)checkTorch {
    AVCaptureDevice *device = self.input.device;
    
    [device lockForConfiguration:nil];
    
    if ([device hasTorch]) {
        [self.preView showTorchButton];
    }
    
    [device unlockForConfiguration];
}

#pragma mark - DYFCodeScannerPreViewDelegate

- (void)back {
    DYFLog();
    [self captureOutputWithCompletion:NULL];
}

- (void)openTorch {
    DYFLog();
    AVCaptureDevice *device = self.input.device;
    
    // 锁定
    [device lockForConfiguration:nil];
    
    // 判定是否有闪光灯
    if ([device hasTorch]) {
        
        if (device.torchMode == AVCaptureTorchModeOff) {
            device.torchMode = AVCaptureTorchModeOn;
        } else if (device.torchMode == AVCaptureTorchModeOn) {
            device.torchMode = AVCaptureTorchModeOff;
        }
        
    }
    
    // 解锁
    [device unlockForConfiguration];
}

- (void)openPhotoLibrary {
    DYFLog();
    [self showImagePicker];
}

- (void)queryHistory {
    DYFLog();
}

- (void)showImagePicker {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        
        [self presentViewController:ipc animated:YES completion:NULL];
        
    } else {
        
        DYFLog(@"W | ImagePicker: SourceType is not available.");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker diDYFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSString *qrCodeMsg = image.QRCodeString;
        
        DYFLog(@"OriginalImage: %@, QRCode message: %@", image, qrCodeMsg);
        
        [self captureOutputWithCompletion:^{
            if (self.resultHandler) {
                self.resultHandler(qrCodeMsg ? YES : NO, qrCodeMsg);
            }
        }];
        
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)zoom:(CGFloat)scale {
    AVCaptureDevice *device = self.input.device;
    // 锁定
    [device lockForConfiguration:nil];
    device.videoZoomFactor = scale;
    // 解锁
    [device unlockForConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DYFLog();
}

@end
