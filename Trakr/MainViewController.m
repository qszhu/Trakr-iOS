//
// Created by Qinsi ZHU on 8/1/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "MainViewController.h"
#import "LogInViewController.h"
#import "SignUpViewController.h"

@implementation MainViewController {

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (![PFUser currentUser]) {
        LogInViewController *logInViewController = [[LogInViewController alloc] init];

        SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];

        [logInViewController setSignUpController:signUpViewController];

        [self presentViewController:logInViewController animated:YES completion:nil];
    }
}

@end