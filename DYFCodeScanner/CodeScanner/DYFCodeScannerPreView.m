//
//  DYFCodeScannerPreView.m
//
//  Created by dyf on 2018/01/28.
//  Copyright © 2018年 dyf. All rights reserved.
//

#import "DYFCodeScannerPreView.h"
#import "DYFCodeScannerMacros.h"

@interface DYFCodeScannerPreView ()
@property (nonatomic, strong) UIImageView *lineImgView;
@end

@implementation DYFCodeScannerPreView

- (UIImageView *)lineImgView {
    if (!_lineImgView) {
        _lineImgView = [[UIImageView alloc] init];
        _lineImgView.image = DYFBundleImageNamed(@"code_scanner_line");
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
        [self initConfig];
    }
    
    return self;
}

- (void)initConfig {
    self.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin|
                             UIViewAutoresizingFlexibleWidth     |
                             UIViewAutoresizingFlexibleTopMargin |
                             UIViewAutoresizingFlexibleHeight);
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    
    self.transparentArea = CGSizeMake(280, 280);
    
    [self addPinchGestureRecognizer];
    
    [self addLine];
    [self addItems];
    [self addTipLabel];
}

- (void)addLine {
    [self addSubview:self.lineImgView];
}

- (void)addItems {
    CGSize viewSize = self.bounds.size;
    
    CGFloat itemSpace = 15.f;
    CGFloat itemW = 36.f;
    CGFloat itemH = 36.f;
    CGFloat itemY = (DYFStatusBarHeight > 20.f) ? 44.f : 34.f;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(itemSpace, itemY, itemW, itemH)];
    [backButton setImage:DYFBundleImageNamed(@"code_scanner_back") forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(itemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = 10;
    backButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    backButton.layer.cornerRadius = itemH/2;
    backButton.layer.masksToBounds = YES;
    [self addSubview:backButton];
    
    UIButton *historyButton = [[UIButton alloc] initWithFrame:CGRectMake(viewSize.width-itemSpace-itemW, itemY, itemW, itemH)];
    [historyButton setImage:DYFBundleImageNamed(@"code_scanner_history") forState:UIControlStateNormal];
    [historyButton addTarget:self action:@selector(itemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    historyButton.tag = 13;
    historyButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    historyButton.layer.cornerRadius = itemH/2;
    historyButton.layer.masksToBounds = YES;
    historyButton.hidden = YES;
    historyButton.showsTouchWhenHighlighted = YES;
    [self addSubview:historyButton];
    
    CGFloat rx = historyButton.hidden ? viewSize.width: historyButton.frame.origin.x;
    
    UIButton *photoButton = [[UIButton alloc] initWithFrame:CGRectMake(rx-itemSpace-itemW, itemY, itemW, itemH)];
    [photoButton setImage:DYFBundleImageNamed(@"code_scanner_photo") forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(itemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    photoButton.tag = 12;
    photoButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    photoButton.layer.cornerRadius = itemH/2;
    photoButton.layer.masksToBounds = YES;
    photoButton.showsTouchWhenHighlighted = YES;
    [self addSubview:photoButton];
    
    UIButton *torchButton = [[UIButton alloc] initWithFrame:CGRectMake(photoButton.frame.origin.x-itemSpace-itemW, itemY, itemW, itemH)];
    [torchButton setImage:DYFBundleImageNamed(@"code_scanner_torch") forState:UIControlStateNormal];
    [torchButton setImage:DYFBundleImageNamed(@"code_scanner_torch_on") forState:UIControlStateSelected];
    [torchButton addTarget:self action:@selector(itemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    torchButton.tag = 11;
    torchButton.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    torchButton.layer.cornerRadius = itemH/2;
    torchButton.layer.masksToBounds = YES;
    torchButton.hidden = YES;
    [self addSubview:torchButton];
}

- (void)addTipLabel {
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.font = [UIFont systemFontOfSize:14.f];
    
    [self addSubview:self.tipLabel];
}

- (void)addPinchGestureRecognizer {
    UIPinchGestureRecognizer *pinchGR = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(shouldReceiveZoom:)];
    [self addGestureRecognizer:pinchGR];
}

- (void)shouldReceiveZoom:(UIPinchGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        if (DYFCRespondsToMethod(self.delegate, zoom:)) {
            
            if (recognizer.scale < 1.f) {
                recognizer.scale = 1.f;
            }
            
            if (recognizer.scale > 3.f) {
                recognizer.scale = 3.f;
            }
            
            [self.delegate zoom:recognizer.scale];
            
        }
    }
}

- (void)itemDidClicked:(UIButton *)sender {
    NSInteger index = sender.tag - 10;
    
    switch (index) {
        case 0: {
            if (DYFCRespondsToMethod(self.delegate, back)) {
                [self.delegate back];
            }
            break;
        }
            
        case 1: {
            sender.selected = !sender.selected;
            if (DYFCRespondsToMethod(self.delegate, openTorch)) {
                [self.delegate openTorch];
            }
            break;
        }
            
        case 2: {
            if (DYFCRespondsToMethod(self.delegate, openPhotoLibrary)) {
                [self.delegate openPhotoLibrary];
            }
            break;
        }
            
        case 3: {
            if (DYFCRespondsToMethod(self.delegate, queryHistory)) {
                [self.delegate queryHistory];
            }
            break;
        }
            
        default:
            break;
    }
}

- (CGFloat)heightForString:(UILabel *)label andWidth:(CGFloat)width {
    CGSize sizeToFit = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

- (void)layoutLine {
    CGFloat delta = self.transparentArea.height/2 - 10;
    
    CGFloat dw = 260.f;
    CGFloat dh = 2.f;
    CGFloat dx = (self.bounds.size.width - dw)/2;
    CGFloat dy = (self.bounds.size.height - dh)/2 - delta;
    
    self.lineImgView.frame = CGRectMake(dx, dy, dw, dh);
}

- (void)layoutTipLabel {
    CGFloat delta = self.transparentArea.height/2 + 5;
    
    CGFloat dw = self.transparentArea.width;
    CGFloat dh = [self heightForString:self.tipLabel andWidth:dw];
    CGFloat dx = (self.bounds.size.width - dw)/2;
    CGFloat dy = self.bounds.size.height/2 + delta;
    
    self.tipLabel.frame = CGRectMake(dx, dy, dw, dh);
}

- (void)startAnimation {
    if (!_lineImgView || !_isReading) {
        return;
    }
    
    [UIView animateWithDuration:2.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _lineImgView.transform = CGAffineTransformMakeTranslation(0, self.transparentArea.height - 20);
        
    } completion:^(BOOL finished) {
        
        _lineImgView.transform = CGAffineTransformIdentity;
        [self startAnimation];
        
    }];
}

- (void)showTorchButton {
    UIButton *torchButton = [self viewWithTag:11];
    torchButton.hidden = NO;
}

- (void)startScan {
    if (_lineImgView) {
        _isReading = YES;
        
        [self layoutLine];
        [self layoutTipLabel];
        
        [self startAnimation];
    }
}

- (void)stopScan {
    _isReading = NO;
}

- (void)drawRect:(CGRect)rect {
    CGSize viewSize = self.bounds.size;
    CGRect screenDrawRect = CGRectMake(0, 0, viewSize.width, viewSize.height);
    
    CGFloat rX = (screenDrawRect.size.width - self.transparentArea.width)/2;
    CGFloat rY = (screenDrawRect.size.height - self.transparentArea.height)/2 - 10;
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
    CGContextSetRGBFillColor(ctx, 10/255.0, 10/255.0, 10/255.0, 0.7);
    CGContextFillRect(ctx, rect); //draw the transparent layer
}

- (void)addCenterClearRect:(CGContextRef)ctx rect:(CGRect)rect {
    CGContextClearRect(ctx, rect); //clear the center rect  of the layer
}

- (void)addWhiteRect:(CGContextRef)ctx rect:(CGRect)rect {
    CGContextStrokeRect(ctx, rect);
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 0.8);
    CGContextAddRect(ctx, rect);
    CGContextStrokePath(ctx);
}

- (void)addCornerLineWithContext:(CGContextRef)ctx rect:(CGRect)rect {
    //画四个边角
    CGContextSetLineWidth(ctx, 2);
    CGContextSetRGBStrokeColor(ctx, 52/255.0, 191/255.0, 37/255.0, 1);
    
    //左上角
    CGPoint poinsTopLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y),
        CGPointMake(rect.origin.x+0.7, rect.origin.y+15)
    };
    CGPoint poinsTopLeftB[] = {
        CGPointMake(rect.origin.x, rect.origin.y+0.7),
        CGPointMake(rect.origin.x+15, rect.origin.y+0.7)
    };
    [self addLine:poinsTopLeftA pointB:poinsTopLeftB ctx:ctx];
    
    //左下角
    CGPoint poinsBottomLeftA[] = {
        CGPointMake(rect.origin.x+0.7, rect.origin.y+rect.size.height-15),
        CGPointMake(rect.origin.x+0.7, rect.origin.y+rect.size.height)
    };
    CGPoint poinsBottomLeftB[] = {
        CGPointMake(rect.origin.x, rect.origin.y+rect.size.height-0.7),
        CGPointMake(rect.origin.x+0.7+15, rect.origin.y+rect.size.height-0.7)
    };
    [self addLine:poinsBottomLeftA pointB:poinsBottomLeftB ctx:ctx];
    
    //右上角
    CGPoint poinsTopRightA[] = {
        CGPointMake(rect.origin.x+rect.size.width-15, rect.origin.y+0.7),
        CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+0.7)
    };
    CGPoint poinsTopRightB[] = {
        CGPointMake(rect.origin.x+rect.size.width-0.7, rect.origin.y),
        CGPointMake(rect.origin.x+rect.size.width-0.7, rect.origin.y+15+0.7)
    };
    [self addLine:poinsTopRightA pointB:poinsTopRightB ctx:ctx];
    
    //右下角
    CGPoint poinsBottomRightA[] = {
        CGPointMake(rect.origin.x+rect.size.width-0.7, rect.origin.y+rect.size.height-15),
        CGPointMake(rect.origin.x-0.7+rect.size.width, rect.origin.y+rect.size.height)
    };
    CGPoint poinsBottomRightB[] = {
        CGPointMake(rect.origin.x+rect.size.width-15, rect.origin.y+rect.size.height-0.7),
        CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height- 0.7)
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
