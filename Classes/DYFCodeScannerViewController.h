//
//  DYFCodeScannerViewController.h
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

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/**
 A block is used to capture the output with a boolean value and a string value.
 */
typedef void (^DYFCaptureOutputResultHandler)(BOOL result, NSString *stringValue);

typedef NS_ENUM(NSInteger, DYFCodeScannerType) {
    DYFCodeScannerTypeAll = 0, // Default, scan QRCode and barcode.
    DYFCodeScannerTypeQRCode,  // Scan QRCode only.
    DYFCodeScannerTypeBarcode, // Scan barcode only.
};

@interface DYFCodeScannerViewController : UIViewController

/** It is used to hide navigation bar for a code scanner. */
@property (nonatomic, assign) BOOL navigationBarHidden;

/** The scan type for a code scanner. */
@property (nonatomic, assign) DYFCodeScannerType scanType;

/** The string is used to prompt users. */
@property (nonatomic,   copy) NSString *tipString;

/** The title for navigation item. */
@property (nonatomic,   copy) NSString *navigationTitle;

/** When the property is setted, it is called back after the output is captured. */
@property (nonatomic,   copy) DYFCaptureOutputResultHandler resultHandler;

@end
