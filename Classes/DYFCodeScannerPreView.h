//
//  DYFCodeScannerPreView.h
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

@protocol DYFCodeScannerPreViewDelegate <NSObject>

- (void)back;
- (void)turnOnTorch;
- (void)turnOffTorch;
- (void)openPhotoLibrary;

@optional

- (void)zoom:(CGFloat)scale;
- (void)queryHistory;

@end

@interface DYFCodeScannerPreView : UIView

@property (nonatomic,   weak) id<DYFCodeScannerPreViewDelegate> delegate;
@property (nonatomic,   copy) NSString *title;

@property (nonatomic, assign) CGSize transparentArea;
@property (nonatomic, assign) BOOL isReading;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, assign) BOOL hasTorch;
@property (nonatomic, assign) BOOL hasNavigationBar;

- (void)startScan;
- (void)stopScan;

@end
