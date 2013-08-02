//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "Constants.h"


@implementation Constants {

}

+ (NSArray *)UNITS {
    static NSArray *theArray;
    if (!theArray) {
        theArray = [[NSArray alloc] initWithObjects:@"Chapters", @"Pages", nil];
    }
    return theArray;
}

+ (NSArray *)REPEAT {
    static NSArray *theArray;
    if (!theArray) {
        theArray = [[NSArray alloc] initWithObjects:@"Every Day", @"Every Week", @"Every Two Weeks", @"Every Month", @"Every Year", nil];
    }
    return theArray;
}

@end