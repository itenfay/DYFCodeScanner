//
//  DYFQRCodeImageView.m
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

#import "DYFQRCodeImageView.h"
#import "DYFCodeScanMacros.h"

@implementation DYFQRCodeImageView

+ (instancetype)createWithFrame:(CGRect)frame stringValue:(NSString *)stringValue
{
    return [self createWithFrame:frame stringValue:stringValue centerImage:nil];
}

+ (instancetype)createWithFrame:(CGRect)frame stringValue:(NSString *)stringValue centerImage:(UIImage *)centerImage
{
    return [self createWithFrame:frame stringValue:stringValue centerImage:centerImage centerSize:CGSizeMake(DYFQRCodeMeImageW, DYFQRCodeMeImageH)];
}

+ (instancetype)createWithFrame:(CGRect)frame stringValue:(NSString *)stringValue centerImage:(UIImage *)centerImage centerSize:(CGSize)centerSize
{
    return [[self alloc] initWithFrame:frame stringValue:stringValue centerImage:centerImage centerSize:centerSize];
}

+ (instancetype)createWithFrame:(CGRect)frame stringValue:(NSString *)stringValue backgroudColor:(UIColor *)backgroudColor foregroudColor:(UIColor *)foregroudColor
{
    return [self createWithFrame:frame stringValue:stringValue backgroudColor:backgroudColor foregroudColor:foregroudColor centerImage:nil];
}

+ (instancetype)createWithFrame:(CGRect)frame stringValue:(NSString *)stringValue backgroudColor:(UIColor *)backgroudColor foregroudColor:(UIColor *)foregroudColor centerImage:(UIImage *)centerImage
{
    return [self createWithFrame:frame stringValue:stringValue backgroudColor:backgroudColor foregroudColor:foregroudColor centerImage:centerImage centerSize:CGSizeMake(DYFQRCodeMeImageW, DYFQRCodeMeImageH)];
}

+ (instancetype)createWithFrame:(CGRect)frame stringValue:(NSString *)stringValue backgroudColor:(UIColor *)backgroudColor foregroudColor:(UIColor *)foregroudColor centerImage:(UIImage *)centerImage centerSize:(CGSize)centerSize;
{
    return [[self alloc] initWithFrame:frame stringValue:stringValue backgroudColor:backgroudColor foregroudColor:foregroudColor centerImage:centerImage centerSize:centerSize];
}

- (instancetype)initWithFrame:(CGRect)frame stringValue:(NSString *)stringValue
{
    return [self initWithFrame:frame stringValue:stringValue centerImage:nil];
}

- (instancetype)initWithFrame:(CGRect)frame stringValue:(NSString *)stringValue centerImage:(UIImage *)centerImage
{
    return [self initWithFrame:frame stringValue:stringValue centerImage:centerImage centerSize:CGSizeMake(DYFQRCodeMeImageW, DYFQRCodeMeImageH)];
}

- (instancetype)initWithFrame:(CGRect)frame stringValue:(NSString *)stringValue centerImage:(UIImage *)centerImage centerSize:(CGSize)centerSize
{
    self = [super initWithFrame:frame];
    if (self) {
        [self generateQRCodeWithStringValue:stringValue centerImage:centerImage centerSize:centerSize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame stringValue:(NSString *)stringValue backgroudColor:(UIColor *)backgroudColor foregroudColor:(UIColor *)foregroudColor
{
    return [self initWithFrame:frame stringValue:stringValue backgroudColor:backgroudColor foregroudColor:foregroudColor centerImage:nil];
}

- (instancetype)initWithFrame:(CGRect)frame stringValue:(NSString *)stringValue backgroudColor:(UIColor *)backgroudColor foregroudColor:(UIColor *)foregroudColor centerImage:(UIImage *)centerImage
{
    return [self initWithFrame:frame stringValue:stringValue backgroudColor:backgroudColor foregroudColor:foregroudColor centerImage:centerImage centerSize:CGSizeMake(DYFQRCodeMeImageW, DYFQRCodeMeImageH)];
}

- (instancetype)initWithFrame:(CGRect)frame stringValue:(NSString *)stringValue backgroudColor:(UIColor *)backgroudColor foregroudColor:(UIColor *)foregroudColor centerImage:(UIImage *)centerImage centerSize:(CGSize)centerSize
{
    self = [super initWithFrame:frame];
    if (self) {
        [self generateQRCodeWithStringValue:stringValue backgroudColor:backgroudColor foregroudColor:foregroudColor centerImage:centerImage centerSize:centerSize];
    }
    return self;
}

- (void)generateQRCodeWithStringValue:(NSString *)stringValue centerImage:(UIImage *)centerImage centerSize:(CGSize)centerSize
{
    // 创建二维码过滤器
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setDefaults];
    
    // 生成二维码
    NSData *data = [stringValue dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:data forKey:@"inputMessage"];
    
    CIImage *codeImage = qrFilter.outputImage;
    // 拉伸
    codeImage = [codeImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    // 绘制二维码
    UIImage *qrImage = [UIImage imageWithCIImage:codeImage];
    UIGraphicsBeginImageContext(qrImage.size);
    [qrImage drawInRect:CGRectMake(0, 0, qrImage.size.width, qrImage.size.height)];
    
    if (centerImage) {
        CGFloat meImgX = (qrImage.size.width  - centerSize.width)/2.f;
        CGFloat meImgY = (qrImage.size.height - centerSize.height)/2.f;
        [centerImage drawInRect:CGRectMake(meImgX, meImgY, centerSize.width, centerSize.height)];
    }
    
    // 获取绘制好的二维码
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)generateQRCodeWithStringValue:(NSString *)stringValue backgroudColor:(UIColor *)backgroudColor foregroudColor:(UIColor *)foregroudColor centerImage:(UIImage *)centerImage
{
    [self generateQRCodeWithStringValue:stringValue backgroudColor:backgroudColor foregroudColor:foregroudColor centerImage:centerImage centerSize:CGSizeMake(DYFQRCodeMeImageW, DYFQRCodeMeImageH)];
}

- (void)generateQRCodeWithStringValue:(NSString *)stringValue backgroudColor:(UIColor *)backgroudColor foregroudColor:(UIColor *)foregroudColor centerImage:(UIImage *)centerImage centerSize:(CGSize)centerSize
{
    // 创建二维码过滤器
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setDefaults];
    
    // 生成二维码
    NSData *data = [stringValue dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:data forKey:@"inputMessage"];
    CIImage *codeImage = qrFilter.outputImage;
    
    // 生成带有颜色的二维码
    // 创建颜色过滤器
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    // 设置默认值
    [colorFilter setDefaults];
    
    // 输入内容
    // 画颜色的图片
    [colorFilter setValue:codeImage forKey:@"inputImage"];
    
    // 使用CIColor
    // inputColor0 前景色 [CIColor colorWithRed:1 green:0 blue:0]
    [colorFilter setValue:[CIColor colorWithCGColor:foregroudColor.CGColor] forKey:@"inputColor0"];
    // inputColor1 背景色 [CIColor colorWithRed:0 green:1 blue:0]
    [colorFilter setValue:[CIColor colorWithCGColor:backgroudColor.CGColor] forKey:@"inputColor1"];
    
    codeImage = colorFilter.outputImage;
    // 拉伸
    codeImage = [codeImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    // 绘制二维码
    UIImage *qrImage = [UIImage imageWithCIImage:codeImage];
    UIGraphicsBeginImageContext(qrImage.size);
    [qrImage drawInRect:CGRectMake(0, 0, qrImage.size.width, qrImage.size.height)];
    
    if (centerImage) {
        CGFloat meImgX = (qrImage.size.width  - centerSize.width)/2.f;
        CGFloat meImgY = (qrImage.size.height - centerSize.height)/2.f;
        [centerImage drawInRect:CGRectMake(meImgX, meImgY, centerSize.width, centerSize.height)];
    }
    // 获取绘制好的二维码
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
