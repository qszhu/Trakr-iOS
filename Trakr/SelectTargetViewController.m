//
// Created by Qinsi ZHU on 8/2/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "SelectTargetViewController.h"
#import "IUtils.h"
#import "CreateTargetViewController.h"


@implementation SelectTargetViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Select Target";

    [IUtils setRightBarAddButton:self action:@selector(createTargetPressed)];
}

- (void)createTargetPressed {
    UIViewController *createTargetVC = [[CreateTargetViewController alloc] init];
    [self.navigationController pushViewController:createTargetVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.text = [NSString stringWithFormat:@"Target %d", indexPath.row];
    }
    return cell;
}

@end