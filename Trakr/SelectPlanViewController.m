//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "SelectPlanViewController.h"
#import "IUtils.h"


@implementation SelectPlanViewController {

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Select a Plan";

        [IUtils setRightBarAddButton:self action:@selector(createPlanPressed)];
    }

    return self;
}

- (void)createPlanPressed {
    [IUtils showViewController:@"CreatePlanViewController" in:self];
}

@end