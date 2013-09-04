//
//  Setting.h
//  Trakr
//
//  Created by Qinsi ZHU on 9/5/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Setting : NSObject
+ (BOOL)taskShouldShowTimer;
+ (void)setTaskShouldShowTimer:(BOOL)taskShouldShowTimer;
@end
