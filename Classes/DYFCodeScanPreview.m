//
//  DYFCodeScanPreview.m
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

#import "DYFCodeScanPreview.h"
#import "DYFCodeScanMacros.h"
#import "UIButton+Corner.h"

#define ItemW                  40.f
#define ItemH                  40.f

@interface DYFCodeScanPreview ()
@property (nonatomic, strong) UIImageView *lineImgView;
@end

@implementation DYFCodeScanPreview

- (UIImageView *)lineImgView {
    if (!_lineImgView) {
        _lineImgView = [[UIImageView alloc] init];
        _lineImgView.image = DYFBundleImageNamed(@"code_scan_line");
    }
    return _lineImgView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
    }
    return _tipLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure {
    self.autoresizingMask       = (UIViewAutoresizingFlexibleLeftMargin |
                                   UIViewAutoresizingFlexibleWidth      |
                                   UIViewAutoresizingFlexibleTopMargin  |
                                   UIViewAutoresizingFlexibleHeight);
    self.backgroundColor        = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    self.transparentArea        = CGSizeMake(280, 280);
    self.hasNavigationBar       = NO;
    
    [self addLine];
    [self addTipLabel];
    [self addItems];
    
    [self addPinchGR];
}

- (void)addLine {
    [self addSubview:self.lineImgView];
}

- (void)addTipLabel {
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.numberOfLines   = 1;
    self.tipLabel.font            = [UIFont systemFontOfSize:13.f];
    self.tipLabel.textColor       = [UIColor colorWithWhite:0.8f alpha:1.f];
    self.tipLabel.textAlignment   = NSTextAlignmentCenter;
    [self addSubview:self.tipLabel];
}

- (void)addItems {
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:DYFBundleImageNamed(@"code_scan_back") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag       = 9;
    [self addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.tag             = 10;
    titleLabel.textColor       = [UIColor whiteColor];
    titleLabel.numberOfLines   = 1;
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    titleLabel.font            = [UIFont boldSystemFontOfSize:17.f];
    [self addSubview:titleLabel];
    
    UIButton *torchButton = [[UIButton alloc] init];
    [torchButton setImage:DYFBundleImageNamed(@"code_scan_torch") forState:UIControlStateNormal];
    [torchButton addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    torchButton.tag       = 11;
    torchButton.showsTouchWhenHighlighted = YES;
    [self addSubview:torchButton];
    
    UIButton *photoButton = [[UIButton alloc] init];
    [photoButton setImage:DYFBundleImageNamed(@"code_scan_photo") forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    photoButton.tag       = 12;
    photoButton.showsTouchWhenHighlighted = YES;
    [self addSubview:photoButton];
    
    UIButton *historyButton = [[UIButton alloc] init];
    [historyButton setImage:DYFBundleImageNamed(@"code_scan_history") forState:UIControlStateNormal];
    [historyButton addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
    historyButton.tag       = 13;
    historyButton.hidden    = YES;
    historyButton.showsTouchWhenHighlighted = YES;
    [self addSubview:historyButton];
}

- (void)addPinchGR {
    UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc] init];
    [pinchGR addTarget:self action:@selector(pinchAction:)];
    [self addGestureRecognizer:pinchGR];
}

- (void)pinchAction:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat maxScale = 5.f;
        CGFloat minScale = 1.f;
        
        CGFloat nowScale = recognizer.scale;
        if (nowScale > maxScale) {
            nowScale = maxScale;
        }
        if (nowScale < minScale) {
            nowScale = minScale;
        }
        
        if (DYFRespondsToMethod(self.delegate, zoom:)) {
            [self.delegate zoom:nowScale];
        }
    }
}

- (void)setTitle:(NSString *)title {
    UILabel *titleLabel = [self viewWithTag:10];
    titleLabel.text = title;
    DYFLog(@"title: %@", titleLabel.text);
}

- (NSString *)title {
    UILabel *titleLabel = [self viewWithTag:10];
    return titleLabel.text;
}

- (void)setHasTorch:(BOOL)hasTorch {
    _hasTorch = hasTorch;
    if (hasTorch) {
        UIButton *torchButton = [self viewWithTag:11];
        [torchButton setImage:DYFBundleImageNamed(@"code_scan_torch_on") forState:UIControlStateSelected];
    }
}

- (void)updateLayout {
    DYFLog();
    [self layoutLine];
    [self layoutTipLabel];
    
    CGSize    vSize         = self.bounds.size;
    
    UIButton *backButton    = [self viewWithTag: 9];
    UILabel  *titleLabel    = [self viewWithTag:10];
    UIButton *torchButton   = [self viewWithTag:11];
    UIButton *photoButton   = [self viewWithTag:12];
    UIButton *historyButton = [self viewWithTag:13];
    
    if (self.hasNavigationBar) {
        backButton.hidden = YES;
        titleLabel.hidden = YES;
    }
    
    if (!backButton.hidden) {
        CGFloat dt       =  8.f;
        CGFloat backBtnX = 12.f;
        CGFloat backBtnY = (DYFStatusBarHeight > 20.f) ? 44.f : 34.f;
        backButton.frame = CGRectMake(backBtnX, backBtnY, ItemW - dt, ItemH - dt);
        backButton.imageEdgeInsets = UIEdgeInsetsMake(3, -2, 3, 2);
        
        CGFloat titleLabX = backBtnX + ItemW - dt + 10.f;
        CGFloat titleLabY = backButton.frame.origin.y;
        CGFloat titleLabW = vSize.width - 2*titleLabX;
        titleLabel.frame  = CGRectMake(titleLabX, titleLabY, titleLabW, ItemH - dt);
    }
    
    UIColor *bgColor  = [UIColor colorWithWhite:0.2 alpha:0.6];
    
    CGFloat tipLabY   = self.tipLabel.frame.origin.y;
    CGFloat tipLabH   = self.tipLabel.frame.size.height;
    
    CGFloat torchBtnX = (vSize.width - self.transparentArea.width)/2.f;
    CGFloat torchBtnY = tipLabY + tipLabH + 30.f;
    torchButton.frame = CGRectMake(torchBtnX, torchBtnY, ItemW, ItemH);
    torchButton.clipCorner(UIRectCornerAllCorners, bgColor, ItemH/2, VVBorderNull);
    
    CGFloat photoBtnX = (vSize.width - ItemW)/2.f;
    CGFloat photoBtnY = torchButton.frame.origin.y;
    if (historyButton.hidden) {
        photoBtnX     = (vSize.width + self.transparentArea.width)/2.f - ItemW;
    }
    photoButton.frame = CGRectMake(photoBtnX, photoBtnY, ItemW, ItemH);
    photoButton.clipCorner(UIRectCornerAllCorners, bgColor, ItemH/2, VVBorderNull);
    
    if (!historyButton.hidden) {
        CGFloat historyBtnX = (vSize.width + self.transparentArea.width)/2.f - ItemW;
        CGFloat historyBtnY = torchButton.frame.origin.y;
        historyButton.frame = CGRectMake(historyBtnX, historyBtnY, ItemW, ItemH);
        historyButton.clipCorner(UIRectCornerAllCorners, bgColor, ItemH/2, VVBorderNull);
    }
}

- (void)layoutLine {
    CGFloat vW = self.bounds.size.width;
    CGFloat vH = self.bounds.size.height;
    CGFloat tH = self.transparentArea.height;
    
    CGFloat dw = 260.f;
    CGFloat dh = 2.f;
    CGFloat dx = (vW - dw)/2;
    CGFloat dy = vH/2 - tH/2 - 20.f;
    
    self.lineImgView.frame = CGRectMake(dx, dy, dw, dh);
}

- (void)layoutTipLabel {
    CGFloat vW = self.bounds.size.width;
    CGFloat vH = self.bounds.size.height;
    CGFloat tW = self.transparentArea.width;
    CGFloat tH = self.transparentArea.height;
    
    CGFloat dw = tW + 40.f;
    CGFloat dh = [self heightForString:self.tipLabel andWidth:dw];
    CGFloat dx = (vW - dw)/2;
    CGFloat dy = vH/2 + tH/2 - 20.f;
    
    self.tipLabel.frame = CGRectMake(dx, dy, dw, dh);
}

- (void)itemClicked:(UIButton *)sender {
    NSInteger index = sender.tag - 10;
    
    switch (index) {
        case -1: {
            !DYFRespondsToMethod(self.delegate, back) ?: [self.delegate back];
            break;
        }
            
        case 1: {
            DYFLog(@"hasTorch: %d", self.hasTorch);
            if (self.hasTorch) {
                sender.selected = !sender.selected;
                
                if (sender.selected) {
                    !DYFRespondsToMethod(self.delegate, turnOnTorch)  ?: [self.delegate turnOnTorch];
                } else {
                    !DYFRespondsToMethod(self.delegate, turnOffTorch) ?: [self.delegate turnOffTorch];
                }
            }
            break;
        }
            
        case 2: {
            !DYFRespondsToMethod(self.delegate, openPhotoLibrary) ?: [self.delegate openPhotoLibrary];
            break;
        }
            
        case 3: {
            !DYFRespondsToMethod(self.delegate, queryHistory) ?: [self.delegate queryHistory];
            break;
        }
            
        default:
            break;
    }
    
    if (index != 1) {
        UIButton *torchButton = [self viewWithTag:11];
        torchButton.selected  = NO;
        !DYFRespondsToMethod(self.delegate, turnOffTorch) ?: [self.delegate turnOffTorch];
    }
}

- (CGFloat)heightForString:(UILabel *)label andWidth:(CGFloat)width {
    CGSize sizeToFit = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void)startAnimation {
    if (!_lineImgView || !_isReading) {
        return;
    }
    
    CGFloat vH = self.bounds.size.height;
    CGFloat tH = self.transparentArea.height;
    
    [UIView animateWithDuration:2.f delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        //self.lineImgView.transform = CGAffineTransformMakeTranslation(0, tH - 20);
        CGRect r = self.lineImgView.frame;
        r.origin.y = vH/2 + tH/2 - 40.f;
        self.lineImgView.frame = r;
        
    } completion:^(BOOL finished) {
        
        //self.lineImgView.transform = CGAffineTransformIdentity;
        CGRect r = self.lineImgView.frame;
        r.origin.y = vH/2 - tH/2 - 20.f;
        self.lineImgView.frame = r;
        
        [self startAnimation];
        
    }];
}

- (void)startScan {
    if (_lineImgView) {
        _isReading = YES;
        [self updateLayout];
        [self startAnimation];
    }
}

- (void)stopScan {
    _isReading = NO;
}

- (void)drawRect:(CGRect)rect {
    CGSize vSize          = self.bounds.size;
    CGRect screenDrawRect = CGRectMake(0, 0, vSize.width, vSize.height);
    
    CGFloat rX = (screenDrawRect.size.width  - self.transparentArea.width )/2;
    CGFloat rY = (screenDrawRect.size.height - self.transparentArea.height)/2 - 30;
    CGFloat rW = self.transparentArea.width;
    CGFloat rH = self.transparentArea.height;
    CGRect clearDrawRect = CGRectMake(rX, rY, rW, rH);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self addScreenFillRect:ctx rect:screenDrawRect];
    [self addCenterClearRect:ctx rect:clearDrawRect];
    [self addWhiteRect:ctx rect:clearDrawRect];
    [self addCornerLineWithContext:ctx rect:clearDrawRect];
}

- (void)addScreenFillRect:(CGContextRef)ctx rect:(CGRect)rect {
    CGContextSetRGBFillColor(ctx, 10/255.0, 10/255.0, 10/255.0, 0.5);
    CGContextFillRect(ctx, rect); // draw the transparent layer
}

- (void)addCenterClearRect:(CGContextRef)ctx rect:(CGRect)rect {
    CGContextClearRect(ctx, rect); // clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect {
    // 画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 52/255.0, 191/255.0, 37/255.0, 1);
    
    // 左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7, rect.origin.y+15)
    };
    CGPoint poinsTopLeftB[] = {
        CGPointMake(rect.origin.x, rect.origin.y+0.7),
        CGPointMake(rect.origin.x+15, rect.origin.y+0.7)
    };
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    // 左下角
    CGPoint poinsBottomLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y+rect.size.height-15),
        CGPointMake(rect.origin.x+0.7, rect.origin.y+rect.size.height)
    };
    CGPoint poinsBottomLeftB[] = {
        CGPointMake(rect.origin.x, rect.origin.y+rect.size.height-0.7),
        CGPointMake(rect.origin.x+0.7+15, rect.origin.y+rect.size.height-0.7)
    };
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    // 右上角
    CGPoint poinsTopRightA[] = {
        CGPointMake(rect.origin.x+rect.size.width-15, rect.origin.y+0.7),
        CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+0.7)
    };
    CGPoint poinsTopRightB[] = {
        CGPointMake(rect.origin.x+rect.size.width-0.7, rect.origin.y),
        CGPointMake(rect.origin.x+rect.size.width-0.7, rect.origin.y+15+0.7)
    };
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    // 右下角
    CGPoint poinsBottomRightA[] = {
        CGPointMake(rect.origin.x+rect.size.width-0.7, rect.origin.y+rect.size.height-15),
        CGPointMake(rect.origin.x-0.7+rect.size.width, rect.origin.y+rect.size.height)
    };
    CGPoint poinsBottomRightB[] = {
        CGPointMake(rect.origin.x+rect.size.width-15, rect.origin.y+rect.size.height-0.7),
        CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height-0.7)
    };
    [self addLine:poinsBottomRightA pointB:poinsBottomRightB ctx:ctx];
    
    CGContextStrokePath(ctx);
}

- (void)addLine:(CGPoint[])pointA pointB:(CGPoint[])pointB ctx:(CGContextRef)ctx {
    CGContextAddLines(ctx, pointA, 2);
    CGContextAddLines(ctx, pointB, 2);
}

- (void)dealloc {
    DYFLog();
}

@end
