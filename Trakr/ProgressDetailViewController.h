//
// Created by Qinsi ZHU on 8/6/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>

@class Progress;


@interface ProgressDetailViewController : UITableViewController
@property (strong, nonatomic) NSString *progressId;
@property (strong, nonatomic) Progress *progress;
@end