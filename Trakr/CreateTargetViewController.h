//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface CreateTargetViewController : UIViewController
@property(strong, nonatomic) IBOutlet UITextField *nameField;
@property(strong, nonatomic) IBOutlet UITextView *descriptionText;
@property(strong, nonatomic) IBOutlet UIButton *createButton;

- (IBAction)createPressed:(id)sender;
@end