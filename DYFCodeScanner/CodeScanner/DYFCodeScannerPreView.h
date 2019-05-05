//
//  DYFCodeScannerPreView.h
//
//  Created by dyf on 2018/01/28.
//  Copyright © 2018年 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol DYFCodeScannerPreViewDelegate <NSObject>

- (void)back;
- (void)openTorch;
- (void)openPhotoLibrary;

@optional

- (void)queryHistory;
- (void)zoom:(CGFloat)scale;

@end

@interface DYFCodeScannerPreView : UIView

@property (nonatomic, weak  ) id<DYFCodeScannerPreViewDelegate> delegate;

@property (nonatomic, assign) CGSize transparentArea;
@property (nonatomic, assign) BOOL isReading;
@property (nonatomic, strong) UILabel *tipLabel;

- (void)startScan;
- (void)stopScan;

- (void)showTorchButton;

@end
