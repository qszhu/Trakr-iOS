//
//  PlansViewController.m
//  Trakr
//
//  Created by Qinsi ZHU on 8/1/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "PlansViewController.h"
#import "IUtils.h"
#import "SelectPlanViewController.h"

@interface PlansViewController ()

@end

@implementation PlansViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Plans";

        [IUtils setRightBarAddButton:self action:@selector(newPlanPressed)];
    }

    return self;
}

- (void)newPlanPressed {
    [IUtils showViewController:@"SelectPlanViewController" in:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end