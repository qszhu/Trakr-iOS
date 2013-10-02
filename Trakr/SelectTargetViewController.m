//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import <Parse/Parse.h>
#import "SelectTargetViewController.h"
#import "IUtils.h"
#import "CreateTargetViewController.h"
#import "Plan.h"
#import "Target.h"
#import "Const.h"
#import "SVProgressHUD.h"
#import "TestFlight.h"

@interface SelectTargetViewController()
@property (strong, nonatomic) NSIndexPath *selectedIndex;
@end

@implementation SelectTargetViewController {

}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.parseClassName = NSStringFromClass([Target class]);
        self.textKey = @"name";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Select Target";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateTarget:) name:kDidCreateTargetNotification object:nil];

    [IUtils setRightBarAddButton:self action:@selector(createTargetPressed)];
}

- (void)didCreateTarget:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidSelectTargetNotification object:notification.object];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [TestFlight passCheckpoint:@"select target view appear"];
}

- (void)createTargetPressed {
    [TestFlight passCheckpoint:@"create target pressed"];

    UIStoryboard *createTargetStoryboard = [UIStoryboard storyboardWithName:@"CreateTarget" bundle:nil];
    UINavigationController *createTargetNav = [createTargetStoryboard instantiateInitialViewController];
    [self presentViewController:createTargetNav animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [TestFlight passCheckpoint:@"select target"];

    Target *target = [self.objects objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidSelectTargetNotification object:target];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.selectedIndex = indexPath;
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure to delete this target?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                             destructiveButtonTitle:@"Delete"
                                                  otherButtonTitles:nil];
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [TestFlight passCheckpoint:@"delete target"];

        [SVProgressHUD showWithStatus:@"Deleting target..." maskType:SVProgressHUDMaskTypeGradient];
        [[self.objects objectAtIndex:self.selectedIndex.row] deleteInBackgroundWithTarget:self selector:@selector(deleteTargetWithResult:error:)];
    }
}

- (void)deleteTargetWithResult:(NSNumber *)result error:(NSError *)error {
    [SVProgressHUD dismiss];
    if (![result boolValue]) {
        [IUtils showErrorDialogWithTitle:@"Cannot delete target" error:error];
        return;
    }
    [self loadObjects];
}

@end