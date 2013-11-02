//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "CreateTargetViewController.h"
#import "IUtils.h"
#import "Target.h"
#import "SVProgressHUD.h"
#import "Const.h"
#import "ScanTargetViewController.h"
#import "AFNetworking.h"
#import "TestFlight.h"

@interface CreateTargetViewController()
@property(strong, nonatomic) Target *target;
@end

@implementation CreateTargetViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.target = [Target object];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barcodeScanned:) name:kBarcodeScannedNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [TestFlight passCheckpoint:@"create target view appear"];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self dismissKeyboard];
}

- (void)dismissKeyboard {
    [self.nameField resignFirstResponder];
    [self.summaryField resignFirstResponder];
}

- (IBAction)donePressed:(id)sender {
    [TestFlight passCheckpoint:@"done pressed"];

    self.target.name = self.nameField.text;
    self.target.summary = self.summaryField.text;

    [SVProgressHUD showWithStatus:@"Creating target..." maskType:SVProgressHUDMaskTypeGradient];
    [self.target saveWithTarget:self selector:@selector(saveTargetWithResult:error:)];
}

- (void)saveTargetWithResult:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (![result boolValue]) {
        [IUtils showErrorDialogWithTitle:@"Cannot create target" error:error];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidCreateTargetNotification object:self.target];
    }];
}

- (IBAction)cancelPressed:(id)sender {
    [TestFlight passCheckpoint:@"cancel pressed"];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)scanPressed:(id)sender {
    [TestFlight passCheckpoint:@"scan pressed"];

    [self presentViewController:[ScanTargetViewController new] animated:YES completion:nil];
}

- (void)barcodeScanned:(NSNotification *)notification {
    NSString *barcode = notification.object;
    [self loadBookInfo:barcode];
}

- (void)loadBookInfo:(NSString *)isbn {
    [SVProgressHUD showWithStatus:@"Loading information..." maskType:SVProgressHUDMaskTypeGradient];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *url = @"https://api.douban.com/v2/book/isbn/";
    [manager GET:[url stringByAppendingString:isbn] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        [self.nameField setText:[responseObject valueForKey:@"title"]];
        [self.summaryField setText:[responseObject valueForKey:@"summary"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismiss];
        [IUtils showErrorDialogWithTitle:@"Error loading information" error:error];
    }];
}

@end