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
#import "TestFlight.h"

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
    [TestFlight passCheckpoint:@"select target view load"];

    self.title = @"Select Target";

    [IUtils setRightBarAddButton:self action:@selector(createTargetPressed)];
}

- (void)createTargetPressed {
    [TestFlight passCheckpoint:@"create target pressed"];

    CreateTargetViewController *createTargetVC = [[CreateTargetViewController alloc] init];
    createTargetVC.createPlanVC = self.createPlanVC;
    [self.navigationController pushViewController:createTargetVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [TestFlight passCheckpoint:@"select target"];

    self.createPlanVC.plan.target = [[Target alloc] initWithParseObject:[self.objects objectAtIndex:(NSUInteger) indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end