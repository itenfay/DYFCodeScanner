//
//  UIButton+Corner.h
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
#import <CoreGraphics/CoreGraphics.h>

// Declare Border Struct.
struct VVBorder {
    CGFloat width;
    UIColor *color;
};
typedef struct VVBorder VVBorder;

// Declare Border Null.
CG_EXTERN const VVBorder VVBorderNull;

CG_INLINE VVBorder
VVBorderMake(CGFloat width, UIColor *color) {
    VVBorder b;
    b.width = width;
    b.color = color;
    return b;
}

// Block for clipping corner.
typedef void (^ClipCornerBlock)(UIRectCorner rc,
                                UIColor *color,
                                CGFloat radius,
                                VVBorder border);

@interface UIButton (Corner)

// Clips corner.
- (ClipCornerBlock)clipCorner;

@end
