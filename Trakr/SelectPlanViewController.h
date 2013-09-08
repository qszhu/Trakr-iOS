//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@class ProgressViewController;


@interface SelectPlanViewController : PFQueryTableViewController <UIActionSheetDelegate>
@property(strong, nonatomic) ProgressViewController *progressVC;
@end