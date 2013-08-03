//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "CreateTargetViewController.h"


@implementation CreateTargetViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Create Target";

    [self.descriptionText.layer setBackgroundColor:[[UIColor whiteColor] CGColor]];
    [self.descriptionText.layer setBorderColor:[[UIColor grayColor] CGColor]];
    [self.descriptionText.layer setBorderWidth:1.0];
    [self.descriptionText.layer setCornerRadius:8.0f];
    [self.descriptionText.layer setMasksToBounds:YES];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.nameField resignFirstResponder];
    [self.descriptionText resignFirstResponder];
}

- (void)createPressed:(id)sender {

}
@end