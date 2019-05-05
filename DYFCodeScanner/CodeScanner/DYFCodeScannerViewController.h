//
//  DYFCodeScannerViewController.h
//
//  Created by dyf on 2018/01/28.
//  Copyright © 2018年 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^CaptureOutputResultHandler)(BOOL result, NSString *stringValue);

typedef NS_ENUM(NSInteger, DYFCodeScannerType) {
    DYFCodeScannerTypeAll = 0, //default, scan QRCode and barcode
    DYFCodeScannerTypeQRCode,  //scan QRCode only
    DYFCodeScannerTypeBarcode, //scan barcode only
};

@interface DYFCodeScannerViewController : UIViewController
@property (nonatomic, assign) DYFCodeScannerType scanType;
@property (nonatomic, copy) NSString *tipStr;

@property (nonatomic, copy) CaptureOutputResultHandler resultHandler;

@end
