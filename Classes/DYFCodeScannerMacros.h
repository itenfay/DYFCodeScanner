//
//  DYFCodeScannerMacros.h
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

#ifndef DYFCodeScannerMacros_h
#define DYFCodeScannerMacros_h

// 日志输出
#ifdef DEBUG
    #define DYFLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define DYFLog(fmt, ...) {}
#endif

// Resolving block circular reference - __weak (arc)
#ifndef DYFWeakObject
    #if __has_feature(objc_arc)
        #define DYFWeakObject(o) try {} @finally {} __weak __typeof(o) weak##_##o = o;
    #else
        #define DYFWeakObject(o) try {} @finally {} __block __typeof(o) weak##_##o = o;
    #endif
#endif

// Resolving block circular reference - __strong (arc)
#ifndef DYFStrongObject
    #if __has_feature(objc_arc)
        #define DYFStrongObject(o) try {} @finally {} __strong __typeof(o) strong##_##o = weak##_##o;
    #else
        #define DYFStrongObject(o) try {} @finally {} __typeof(o) strong##_##o = weak##_##o;
    #endif
#endif

// 创建二维码时，中间头像的宽和高
#define DYFQRCodeMeImageW                100.f
#define DYFQRCodeMeImageH                100.f

// Bundle名称
#define DYFBundleName                    @"DYFCodeScanner.bundle"

// 字符串追加字符串
#define DYFAppendingString(s, e)         [s stringByAppendingString:e]
// 字符串追加路径
#define DYFAppendingPathComponent(s, e)  [s stringByAppendingPathComponent:e]
// Bundle文件路径
#define DYFBundleFilePath(name)          DYFAppendingPathComponent(DYFBundleName, name)

// 通过图像名称获取图像对象
#define DYFImageNamed(name)              [UIImage imageNamed:name]

// 通过图像名称获取Bundle中的图像对象
#define DYFBundleImageNamed(name)        [UIImage imageNamed:DYFBundleFilePath(name)]

// 目标对象是否响应方法
#define DYFRespondsToMethod(target, sel) (target && [target respondsToSelector:@selector(sel)])

// 获取应用单例
#define DYFSharedApp                     UIApplication.sharedApplication

// 获取状态栏高度
#define DYFStatusBarHeight               DYFSharedApp.statusBarFrame.size.height

#endif /* DYFCodeScannerMacros_h */
