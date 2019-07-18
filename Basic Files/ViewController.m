//
//  ViewController.m
//
//  Created by dyf on 2019/5/6.
//  Copyright © 2019 dyf. All rights reserved.
//

#import "ViewController.h"
#import "DYFCodeScannerViewController.h"
#import "DYFQRCodeImageView.h"
#import "UIImage+QRCode.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView         *m_textView;
@property (weak, nonatomic) IBOutlet DYFQRCodeImageView *qrc_imageView;
@property (weak, nonatomic) IBOutlet DYFQRCodeImageView *cqrc_imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"二维码/条形码";
    [self addActionForImageView];
}

- (void)addActionForImageView {
    self.qrc_imageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *gr_longPress = [[UILongPressGestureRecognizer alloc] init];
    [gr_longPress addTarget:self action:@selector(recognizeQRCode:)];
    [self.qrc_imageView addGestureRecognizer:gr_longPress];
    
    self.cqrc_imageView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *gr_longPress2 = [[UILongPressGestureRecognizer alloc] init];
    [gr_longPress2 addTarget:self action:@selector(recognizeQRCode:)];
    [self.cqrc_imageView addGestureRecognizer:gr_longPress2];
}

- (IBAction)scan:(id)sender {
    static BOOL shouldPush = YES;
    
    DYFCodeScannerViewController *codesVC = [[DYFCodeScannerViewController alloc] init];
    codesVC.scanType = DYFCodeScannerTypeAll;
    codesVC.navigationTitle = @"二维码/条形码";
    codesVC.tipString = [NSString stringWithFormat:@"将二维码/条形码放入框内，即自动扫描"];
    codesVC.resultHandler = ^(BOOL result, NSString *stringValue) {
        if (result) {
            [self showResult:stringValue];
        } else {
            NSLog(@"QRCode Message: %@", stringValue);
        }
    };
    
    if (shouldPush) {
        [self.navigationController pushViewController:codesVC animated:YES];
    } else {
        [self presentViewController:codesVC animated:YES completion:NULL];
    }
    
    shouldPush = !shouldPush;
}

- (IBAction)generateQRCode:(id)sender {
    CGRect rect = self.qrc_imageView.frame;
    DYFQRCodeImageView *imageView = [DYFQRCodeImageView createWithFrame:rect stringValue:@"http://img.shields.io/cocoapods/v/DYFAssistiveTouchView.svg?style=flat" centerImage:[UIImage imageNamed:@"cat49334.jpg"]];
    self.qrc_imageView.image = imageView.image;
}

- (IBAction)generateColorQRCode:(id)sender {
    CGRect rect = self.cqrc_imageView.frame;
    DYFQRCodeImageView *imageView = [DYFQRCodeImageView createWithFrame:rect stringValue:@"http://img.shields.io/cocoapods/p/DYFAssistiveTouchView.svg?style=flat" backgroudColor:[UIColor grayColor] foregroudColor:[UIColor greenColor]];
    self.cqrc_imageView.image = imageView.image;
}

- (void)showResult:(NSString *)value {
    if (self.m_textView.text.length > 0) {
        self.m_textView.text = @"";
    }
    self.m_textView.text = value;
}

- (void)recognizeQRCode:(UILongPressGestureRecognizer *)recognizer {
    UIImage *qrcodeImage = ((DYFQRCodeImageView *)recognizer.view).image;
    NSString *stringValue = [qrcodeImage yf_stringValue];
#if DEBUG
    NSLog(@"stringValue: %@", stringValue);
#endif
    
    if (@available(iOS 8.0 ,*)) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"获取二维码的内容" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
        [alertController addAction:cancelAction];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showResult:stringValue];
        }];
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:NULL];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
