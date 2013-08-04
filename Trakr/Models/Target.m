//
// Created by Qinsi ZHU on 8/4/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Parse/Parse.h>
#import "Target.h"
#import "IUtils.h"


@implementation Target {

}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@" name: %@ ", self.name];
    [description appendFormat:@" description: %@ ", self.desc];
    [description appendFormat:@" pfObject: %@ ", self.pfObject];
    [description appendString:@">"];
    return description;
}

+ (Target *)fromPFObject:(PFObject *)object {
    Target *theTarget = [[Target alloc] init];
    theTarget.name = [object objectForKey:@"name"];
    theTarget.desc = [object objectForKey:@"description"];
    theTarget.pfObject = object;
    return theTarget;
}

- (NSError *)getValidationError {
    self.name = [IUtils trim:self.name];
    if (self.name.length == 0) {
        return [IUtils errorWithCode:400 message:@"Target name is required"];
    }
    return nil;
}

- (PFObject *)toPFObject {
    PFObject *obj = self.pfObject == nil ? [PFObject objectWithClassName:@"Target"] : self.pfObject;
    [obj setObject:self.name forKey:@"name"];
    if (self.desc) {
        [obj setObject:self.desc forKey:@"description"];
    }
    return obj;
}

- (void)saveWithTarget:(id)target selector:(SEL)selector {
    self.pfObject = [self toPFObject];
    [self.pfObject saveInBackgroundWithTarget:target selector:selector];
}

@end