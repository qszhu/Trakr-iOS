//
//  LoginCommon.m
//  Trakr
//
//  Created by Qinsi ZHU on 10/2/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "LoginCommon.h"

@implementation LoginCommon

+ (UILabel *)getTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Trakr";
    label.font = [UIFont systemFontOfSize:36];
    label.textColor = [UIColor lightTextColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [label sizeToFit];
    return label;
}

@end
