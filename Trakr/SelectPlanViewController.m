//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "SelectPlanViewController.h"
#import "IUtils.h"
#import "CreatePlanViewController.h"


@implementation SelectPlanViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Select Plan";

    [IUtils setRightBarAddButton:self action:@selector(createPlanPressed)];
}

- (void)createPlanPressed {
    UIViewController *createPlanVC = [[CreatePlanViewController alloc] init];
    [self.navigationController pushViewController:createPlanVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"Plan %d", indexPath.row];
    }
    return cell;
}

@end