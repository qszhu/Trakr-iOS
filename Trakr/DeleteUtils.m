//
//  DeleteUtils.m
//  Trakr
//
//  Created by Qinsi ZHU on 10/5/13.
//  Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//

#import "DeleteUtils.h"
#import "IUtils.h"
#import "SVProgressHUD.h"

@interface DeleteUtils() <UIActionSheetDelegate>
@property (strong, nonatomic) NSString *name, *notificationName;
@property (strong, nonatomic) PFObject *object;
@end

@implementation DeleteUtils

- (void)delete:(NSString *)name object:(PFObject *)object inView:(UIView *)view withNotificationName:(NSString *)notificationName {
    self.name = name;
    self.object = object;
    self.notificationName = notificationName;
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Are you sure to delete this %@?", name]
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:@"Delete"
                                              otherButtonTitles:nil];
    [sheet showInView:view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"Deleting %@...", self.name] maskType:SVProgressHUDMaskTypeGradient];
        [self.object deleteInBackgroundWithTarget:self selector:@selector(deleteWithResult:error:)];
    }
}

- (void)deleteWithResult:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (![result boolValue]) {
        [IUtils showErrorDialogWithTitle:[NSString stringWithFormat:@"Cannot delete %@", self.name] error:error];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:self];
}

@end
