//
//  DeleteUtils.h
//  Trakr
//
//  Created by Qinsi ZHU on 10/5/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@interface DeleteUtils : NSObject
- (void)delete:(NSString *)name object:(PFObject *)object inView:(UIView *)view withNotificationName:(NSString *)notificationName;
@end
