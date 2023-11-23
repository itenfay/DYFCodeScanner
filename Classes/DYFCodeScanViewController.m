//
//  DYFCodeScanViewController.m
//
//  Created by dyf on 2018/01/28.
//  Copyright © 2018 dyf. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "DYFCodeScanViewController.h"
#import "DYFCodeScanPreview.h"
#import "DYFCodeScanMacros.h"
#import "UIImage+QRCode.h"

@interface DYFCodeScanViewController ()
<
AVCaptureMetadataOutputObjectsDelegate,
DYFCodeScanPreviewDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIGestureRecognizerDelegate
>
@property (nonatomic, strong) AVCaptureSession      *session;  // 会话
@property (nonatomic, strong) AVCaptureDeviceInput  *input;    // 输入流
@property (nonatomic, strong) DYFCodeScanPreview *preview;     // 预览视图
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@end

@implementation DYFCodeScanViewController

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.scanType = DYFCodeScanTypeAll;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createQueue];
    [self configureNavigationBar];
    [self addPreview];
    [self requestAccess];
}

- (void)createQueue
{
    dispatch_queue_t sessionQueue = dispatch_queue_create("com.scan.sessionQueue", DISPATCH_QUEUE_SERIAL);
    self.sessionQueue = sessionQueue;
}

- (void)_startSessionRunning
{
    @DYFWeakObject(self);
    dispatch_async(self.sessionQueue, ^{
        @DYFStrongObject(self);
        if (strong_self.session && ![strong_self.session isRunning]) {
            [strong_self.session startRunning];
        }
    });
}

- (void)_stopSessionRunning
{
    @DYFWeakObject(self);
    dispatch_async(self.sessionQueue, ^{
        @DYFStrongObject(self);
        if (strong_self.session && [strong_self.session isRunning]) {
            [strong_self.session stopRunning];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationBarHidden) {
        [self hideNavigationBar:YES];
    }
    
    [self _startSessionRunning];
    [self.preview startScan];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.navigationController) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.navigationBarHidden) {
        [self hideNavigationBar:NO];
    }
    
    [self _stopSessionRunning];
    [self.preview stopScan];
}

- (void)hideNavigationBar:(BOOL)hidden
{
    if (self.navigationController) {
        self.navigationController.navigationBarHidden = hidden;
    }
}

- (void)configureNavigationBar
{
    if (self.navigationController) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
        self.navigationItem.title = self.navigationTitle;
        
        if (!self.navigationBarHidden) {
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            backButton.frame = CGRectMake(0, 0, 40, 40);
            [backButton setImage:DYFBundleImageNamed(@"code_scan_blueBack") forState:UIControlStateNormal];
            [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            backButton.imageEdgeInsets = UIEdgeInsetsMake(3, -10, 3, 30);
            
            UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            spaceItem.width = -20;
            UIBarButtonItem *backItem  = [[UIBarButtonItem alloc] initWithCustomView:backButton];
            self.navigationItem.leftBarButtonItems = @[spaceItem, backItem];
            
            self.preview.hasNavigationBar = YES;
        } else {
            self.preview.hasNavigationBar = NO;
        }
    } else {
        self.preview.hasNavigationBar = NO;
    }
}

- (void)backButtonClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestAccess
{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (granted) {
                [self onPreview];
            } else {
                NSString *msg = @"请在系统“设置”-“隐私”-“相机”选项中，允许App访问你的相机";
                DYFLog(@"[W]: %@", msg);
                !self.resultHandler ?: self.resultHandler(NO, msg);
            }
        });
    }];
}

- (void)addPreview
{
    [self.view addSubview:self.preview];
}

- (void)onPreview
{
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
        case DYFCodeScanTypeAll:
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
        case DYFCodeScanTypeQRCode:
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
            break;
        case DYFCodeScanTypeBarcode:
            output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                           AVMetadataObjectTypeEAN8Code,
                                           AVMetadataObjectTypeUPCECode,
                                           AVMetadataObjectTypeCode39Code,
                                           AVMetadataObjectTypeCode39Mod43Code,
                                           AVMetadataObjectTypeCode93Code,
                                           AVMetadataObjectTypeCode128Code,
                                           AVMetadataObjectTypePDF417Code];
            break;
        default: break;
    }
    
    if (self.input.device.isFocusPointOfInterestSupported &&
        [self.input.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [self.input.device lockForConfiguration:nil];
        [self.input.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [self.input.device unlockForConfiguration];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.session];
    previewLayer.frame = self.view.layer.bounds;
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    // 将预览层添加到界面中
    [self.view.layer insertSublayer:previewLayer atIndex:0];
    
    [self _startSessionRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (!self.preview.isReading) { return; }
    
    if (metadataObjects.count > 0) {
        [self _stopSessionRunning];
        [self.preview stopScan];
        
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        NSString *result = metadataObject.stringValue;
        
        [self captureOutputWithCompletion:^{
            !self.resultHandler ?: self.resultHandler(result ? YES : NO, result);
        }];
    }
}

- (void)captureOutputWithCompletion:(void (^)(void))completionHandler
{
    UINavigationController *nc = self.navigationController;
    if (nc) {
        if (nc.viewControllers.count == 1) {
            [nc dismissViewControllerAnimated:YES completion:completionHandler];
        } else {
            [nc popViewControllerAnimated:YES];
            !completionHandler ?: completionHandler();
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:completionHandler];
    }
}

- (void)checkTorch {
    AVCaptureDevice *device = self.input.device;
    [device lockForConfiguration:nil];
    self.preview.hasTorch = device.hasTorch;
    [device unlockForConfiguration];
}

#pragma mark - DYFCodeScanPreviewDelegate

- (void)back
{
    [self captureOutputWithCompletion:NULL];
}

- (void)turnOnTorch
{
    [self onTorch:YES];
}

- (void)turnOffTorch
{
    [self onTorch:NO];
}

- (void)onTorch:(BOOL)onOrOff
{
    AVCaptureDevice *device = self.input.device;
    // 锁定
    [device lockForConfiguration:nil];
    // 判断是否有闪光灯
    if ([device hasTorch]) {
        if (onOrOff) {
            device.torchMode = AVCaptureTorchModeOn;
        } else {
            device.torchMode = AVCaptureTorchModeOff;
        }
    }
    // 解锁
    [device unlockForConfiguration];
}

- (void)openPhotoLibrary
{
    [self presentImagePicker];
}

- (void)queryHistory
{
    DYFLog();
}

- (void)presentImagePicker
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ipc.delegate = self;
        [self presentViewController:ipc animated:YES completion:NULL];
    } else {
        DYFLog(@"[W]: ImagePicker: SourceType is not available.");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSString *codeMsg = image.yf_stringValue;
        DYFLog(@"OriginalImage: %@, QRCode message: %@", image, codeMsg);
        
        [self captureOutputWithCompletion:^{
            !self.resultHandler ?: self.resultHandler(codeMsg ? YES : NO, codeMsg);
        }];
    });
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)zoom:(CGFloat)scale
{
    AVCaptureDevice *device = self.input.device;
    [device lockForConfiguration:nil];
    device.videoZoomFactor = scale;
    [device unlockForConfiguration];
}

- (DYFCodeScanPreview *)preview
{
    if (!_preview) {
        _preview = [[DYFCodeScanPreview alloc] initWithFrame:self.view.bounds];
        _preview.delegate      = self;
        _preview.title         = self.navigationTitle;
        _preview.tipLabel.text = self.tipString;
    }
    return _preview;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    DYFLog();
}

@end
