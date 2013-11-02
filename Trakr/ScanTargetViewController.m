//
//  ScanTargetViewController.m
//  Trakr
//
//  Created by Qinsi ZHU on 11/2/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "ScanTargetViewController.h"
#import "ZXingObjC.h"
#import "Const.h"
#import "TestFlight.h"

@interface ScanTargetViewController ()<ZXCaptureDelegate>
@property (nonatomic, strong) ZXCapture* capture;
@end

@implementation ScanTargetViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [TestFlight passCheckpoint:@"scan target view appear"];

    self.capture = [ZXCapture new];
    self.capture.delegate = self;
    self.capture.rotation = 90.0f;
    self.capture.camera = self.capture.back;

    self.capture.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.capture.layer];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)captureResult:(ZXCapture*)capture result:(ZXResult*)result {
    if (result) {
        if (result.barcodeFormat == kBarcodeFormatEan13) {
            [self dismissViewControllerAnimated:YES completion:^{
                [self.capture stop];
                [[NSNotificationCenter defaultCenter] postNotificationName:kBarcodeScannedNotification object:result.text];
            }];
        }
    }
}

@end
