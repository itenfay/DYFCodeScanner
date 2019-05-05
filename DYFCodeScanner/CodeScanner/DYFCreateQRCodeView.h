//
//  DYFCreateQRCodeView.h
//
//  Created by dyf on 2018/01/28.
//  Copyright © 2018年 dyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface DYFCreateQRCodeView : UIImageView

+ (instancetype)createWithFrame:(CGRect)frame withStringValue:(NSString *)stringValue;
+ (instancetype)createWithFrame:(CGRect)frame withStringValue:(NSString *)stringValue withCenterImage:(UIImage *)centerImage;
+ (instancetype)createWithFrame:(CGRect)frame withStringValue:(NSString *)stringValue withBackgroudColor:(UIColor *)backgroudColor withForegroudColor:(UIColor *)foregroudColor;
+ (instancetype)createWithFrame:(CGRect)frame withStringValue:(NSString *)stringValue withBackgroudColor:(UIColor *)backgroudColor withForegroudColor:(UIColor *)foregroudColor withCenterImage:(UIImage *)centerImage;

- (instancetype)initWithFrame:(CGRect)frame withStringValue:(NSString *)stringValue;
- (instancetype)initWithFrame:(CGRect)frame withStringValue:(NSString *)stringValue withCenterImage:(UIImage *)centerImage;

- (instancetype)initWithFrame:(CGRect)frame withStringValue:(NSString *)stringValue withBackgroudColor:(UIColor *)backgroudColor withForegroudColor:(UIColor *)foregroudColor;
- (instancetype)initWithFrame:(CGRect)frame withStringValue:(NSString *)stringValue withBackgroudColor:(UIColor *)backgroudColor withForegroudColor:(UIColor *)foregroudColor withCenterImage:(UIImage *)centerImage;

@end
