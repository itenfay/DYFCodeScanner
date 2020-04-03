<div align=center>
<img src="https://github.com/dgynfi/DYFCodeScanner/raw/master/images/CodeScanner.png" width="90%">
</div>

[如果此项目能帮助到你，就请你给一颗星。谢谢！(If this project can help you, please give it a star. Thanks!)](https://github.com/dgynfi/DYFCodeScanner)

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/DYFCodeScanner.svg?style=flat)](http://cocoapods.org/pods/DYFCodeScanner)&nbsp;
![CocoaPods](http://img.shields.io/cocoapods/p/DYFCodeScanner.svg?style=flat)&nbsp;

## DYFCodeScanner

一个简单的二维码和条码扫描器，有一套自定义的扫描动画以及界面，支持相机缩放，还可以生成和识别二维码。(A simple QR code and barcode scanner, which has a set of custom scanning animation and interface, supports camera zooming, and can generate and identify QR code.)

## Group (ID:614799921)

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFCodeScanner/raw/master/images/g614799921.jpg" width="30%" />
</div>

## Installation

Using [CocoaPods](https://cocoapods.org):

```
pod 'DYFCodeScanner', '~> 1.0.2'
```

Or

```
# Install lastest version.
pod 'DYFCodeScanner'
```

## Preview

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFCodeScanner/raw/master/images/CodeScannerPreview.gif" width="30%" />
</div>

## Usage

- 添加隐私 (Add Privacy)

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFCodeScanner/raw/master/images/camera_photo_privacy.png" width="80%" />
</div>

```
<key>NSCameraUsageDescription</key>
<string>扫描二维码/条形码，允许App访问您的相机？</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>存取照片，允许App访问您的相册？</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>存取照片，允许App访问您的相册？</string>
```

- 导入头文件 (Import Header)

```
#import "DYFCodeScanner.h"
```

- 扫描二维码/条形码 (Scanning QR code / Barcode) 

1. 支持push和模态两种场景过渡。 (Supporting push or modal transition.)  <br />
2. 根据项目的需求，选择之一即可。(According to the needs of the project, you can choose one of them.) <br />
3. 当你要推进视图控制器，你可以选择隐藏或者不隐藏导航条。(When you want to push the view controller, you can choose to or not to hide the navigation bar.)

```
- (IBAction)scan:(id)sender {
    static BOOL shouldPush      = YES;
    static BOOL naviBarHidden   = YES;

    DYFCodeScannerViewController *codesVC = [[DYFCodeScannerViewController alloc] init];
    codesVC.scanType            = DYFCodeScannerTypeAll;
    codesVC.navigationTitle     = @"二维码/条形码";
    codesVC.tipString           = [NSString stringWithFormat:@"将二维码/条形码放入框内，即自动扫描"];
    codesVC.resultHandler       = ^(BOOL result, NSString *stringValue) {
        if (result) {
            [self showResult:stringValue];
        } else {
            NSLog(@"QRCode Message: %@", stringValue);
        }
    };

    if (shouldPush) {
        codesVC.navigationBarHidden = naviBarHidden = !naviBarHidden;
        [self.navigationController pushViewController:codesVC animated:YES];
    } else {
        [self presentViewController:codesVC animated:YES completion:NULL];
    }

    shouldPush = !shouldPush;
}

- (void)showResult:(NSString *)value {
    if (self.m_textView.text.length > 0) {
        self.m_textView.text = @"";
    }
    self.m_textView.text = value;
}
```

- 生成二维码 (Generating QR code)

1. 生成带中心图像的二维码 (Generating QR code that contains center image)

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFCodeScanner/raw/master/images/2051832951.jpg" width="30%" />
</div>

```
- (IBAction)generateQRCode:(id)sender {
    CGRect rect = self.qrc_imageView.frame;
    DYFQRCodeImageView *imageView = [DYFQRCodeImageView createWithFrame:rect stringValue:@"http://img.shields.io/cocoapods/v/DYFAssistiveTouchView.svg?style=flat" centerImage:[UIImage imageNamed:@"cat49334.jpg"]];
    self.qrc_imageView.image = imageView.image;
}
```

2. 生成带颜色的二维码 (Generating QR code that contains backgroudColor and foregroudColor)

<div align=left>
&emsp; <img src="https://github.com/dgynfi/DYFCodeScanner/raw/master/images/1890129771.jpg" width="30%" />
</div>

```
- (IBAction)generateColorQRCode:(id)sender {
    CGRect rect = self.cqrc_imageView.frame;
    DYFQRCodeImageView *imageView = [DYFQRCodeImageView createWithFrame:rect stringValue:@"http://img.shields.io/cocoapods/p/DYFAssistiveTouchView.svg?style=flat" backgroudColor:[UIColor grayColor] foregroudColor:[UIColor greenColor]];
    self.cqrc_imageView.image = imageView.image;
}
```

3.  生成带中心图像颜色的二维码 (Generating QR code that contains center image, backgroudColor and foregroudColor)

```
DYFQRCodeImageView *imageView = [DYFQRCodeImageView createWithFrame:CGRectMake(30, 88, 200, 200) stringValue:@"https://github.com/dgynfi/DYFAuthIDAndGestureLock" backgroudColor:[UIColor grayColor] foregroudColor:[UIColor greenColor] centerImage:[UIImage imageNamed:@"cat49334.jpg"]];
[self.view addSubview:imageView];
```

- 识别二维码 (Recognizing QR code)

```
- (void)recognizeQRCode:(UILongPressGestureRecognizer *)recognizer {
    UIImage *qrcodeImage = ((DYFQRCodeImageView *)recognizer.view).image;
    NSString *stringValue = [qrcodeImage yf_stringValue];
    #if DEBUG
        NSLog(@"stringValue: %@", stringValue);
    #endif
}
```

## Code Sample

- [Code Sample Portal](https://github.com/dgynfi/DYFCodeScanner/blob/master/Basic%20Files/ViewController.m)
