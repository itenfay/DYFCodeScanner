//
//  UIImage+DYFQRExtension.m
//
//  Created by dyf on 2018/01/28.
//  Copyright © 2018年 dyf. All rights reserved.
//

#import "UIImage+DYFQRExtension.h"
#import "DYFCodeScannerMacros.h"

@implementation UIImage (DYFQRExtension)

- (NSString *)QRCodeString {
    // 创建一个CIImage对象, 开始识别图片, 获取图片特征
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:self.CGImage options:nil];
    
    // 创建上下文, 软件渲染
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
    
    // 创建一个探测器(CIDetectorTypeQRCode)
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    
    NSArray<CIFeature *> *features = [detector featuresInImage:ciImage];
    for (CIQRCodeFeature *codef in features) {
        // 打印二维码中的信息
        DYFLog(@"QRCode message = %@", codef.messageString);
    }
    CIQRCodeFeature *codef = (CIQRCodeFeature *)features.firstObject;
    
    return codef.messageString;
}

@end
