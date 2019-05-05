//
//  DYFCodeScannerMacros.h
//
//  Created by dyf on 2018/01/28.
//  Copyright © 2018年 dyf. All rights reserved.
//

#ifndef DYFCodeScannerMacros_h
#define DYFCodeScannerMacros_h

// 日志输出
#ifdef DEBUG
    #define DYFLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define DYFLog(fmt, ...)
#endif

// Resolving block circular reference
#ifndef DYFWeakObject
    #if __has_feature(objc_arc)
        #define DYFWeakObject(o) try {} @finally {} __weak __typeof(o) weak##_##o = o;
    #else
        #define DYFWeakObject(o) try {} @finally {} __block __typeof(o) weak##_##o = o;
    #endif
#endif

#ifndef DYFStrongObject
    #if __has_feature(objc_arc)
        #define DYFStrongObject(o) try {} @finally {} __strong __typeof(o) strong##_##o = weak##_##o;
    #else
        #define DYFStrongObject(o) try {} @finally {} __typeof(o) strong##_##o = weak##_##o;
    #endif
#endif

// 创建二维码时，中间头像的宽和高
#define DYFCQRMeImageW  80.f
#define DYFCQRMeImageH  80.f

// Bundle名称
#define DYFBundleName @"DYFCodeScanner.bundle"

// 字符串追加字符串
#define DYFAppendingString(s, e) [s stringByAppendingString:e]
// 字符串追加路径
#define DYFAppendingPathComponent(s, e) [s stringByAppendingPathComponent:e]

// 通过图像名称获取图像对象
#define DYFImageNamed(name) [UIImage imageNamed:name]

// 通过图像名称获取Bundle包中的图像对象
#define DYFBundleImageNamed(name) [UIImage imageNamed:DYFAppendingPathComponent(DYFBundleName, name)]

// 目标对象是否响应方法
#define DYFCRespondsToMethod(target, sel) [target respondsToSelector:@selector(sel)]

// 获取应用单例
#define DYFSharedApp UIApplication.sharedApplication

// 获取状态栏高度
#define DYFStatusBarHeight DYFSharedApp.statusBarFrame.size.height

#endif /* DYFCodeScannerMacros_h */
