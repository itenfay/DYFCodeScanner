//
//  UIImage+QRCode.m
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

#import "UIImage+QRCode.h"

@implementation UIImage (QRCode)

- (NSString *)yf_stringValue {
    // 创建一个CIImage对象, 开始识别图片, 获取图片特征
    CIImage *ciImage = [[CIImage alloc] initWithCGImage:self.CGImage options:nil];
    
    // 创建上下文, 软件渲染
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
    
    // 创建一个探测器(CIDetectorTypeQRCode)
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    
    NSArray<CIFeature *> *features = [detector featuresInImage:ciImage];
    for (CIQRCodeFeature *codef in features) {
#if DEBUG
        // 打印二维码中的信息
        NSLog(@"QRCode Feature Message: %@", codef.messageString);
#endif
    }
    CIQRCodeFeature *codef = (CIQRCodeFeature *)features.firstObject;
    
    return codef.messageString;
}

@end
