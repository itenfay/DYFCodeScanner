[如果你觉得能帮助到你，请给一颗小星星。谢谢！(If you think it can help you, please give it a star. Thanks!)](https://github.com/dgynfi/DYFCodeScanner)

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](LICENSE)&nbsp;

## DYFCodeScanner

 一个二维码/条形码的扫码器，代码简洁，高效。(A QR code and Barcode scanner for iOS. concise code and efficient.)

## 技术交流群(群号:155353383) 

欢迎加入技术交流群，一起探讨技术问题。<br />
![](https://github.com/dgynfi/DYFCodeScanner/raw/master/images/qq155353383.jpg)

## 效果图

<div align=left>
<img src="https://github.com/dgynfi/DYFCodeScanner/raw/master/images/CodeScannerPreview.gif" width="40%" />
</div>

## 使用说明

- 导入头文件 (Import Header)

```
#import "DYFCodeScannerViewController.h"
#import "DYFQRCodeImageView.h"
#import "UIImage+QRCode.h"
```

- 扫描二维码/条形码 (Scanning QR code / Barcode) 

&nbsp;&nbsp;支持push和模态两种场景过渡 (Supporting push or modal transition)

```
// 根据项目的需求，自由选择之一，即可。
// According to the needs of the project, you can choose one of them freely.
- (IBAction)scan:(id)sender {
    static BOOL shouldPush = YES;

    DYFCodeScannerViewController *codesVC = [[DYFCodeScannerViewController alloc] init];
    codesVC.scanType = DYFCodeScannerTypeAll;
    codesVC.navigationTitle = @"二维码/条形码";
    codesVC.tipString = [NSString stringWithFormat:@"将二维码/条形码放入框内，即自动扫描"];
    codesVC.resultHandler = ^(BOOL result, NSString *stringValue) {
        if (result) {
            [self showResult:stringValue];
        } else {
            NSLog(@"QRCode Message: %@", stringValue);
        }
    };

    if (shouldPush) {
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
<img src="https://github.com/dgynfi/DYFCodeScanner/raw/master/images/2051832951.jpg" width="50%" />
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
<img src="https://github.com/dgynfi/DYFCodeScanner/raw/master/images/1890129771.jpg" width="50%" />
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
DYFQRCodeImageView *imageView = [DYFQRCodeImageView createWithFrame:CGRectMake(100, 100, 240, 240) stringValue:@"https://github.com/dgynfi/DYFAuthIDAndGestureLock" backgroudColor:[UIColor grayColor] foregroudColor:[UIColor greenColor] centerImage:[UIImage imageNamed:@"cat49334.jpg"]];
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
