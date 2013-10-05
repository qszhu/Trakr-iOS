//
// Created by Qinsi ZHU on 8/1/13.
// Copyright (c) 2013 Qinsi ZHU. All rights reserved.
//


#import "IUtils.h"
#import "TTTTimeIntervalFormatter.h"


@implementation IUtils {

}

+ (NSString *)trim:(NSString *)aString {
    return [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSError *)errorWithCode:(NSInteger)errorCode message:(NSString *)errorMessage {
    NSMutableDictionary *details = [NSMutableDictionary dictionary];
    [details setValue:errorMessage forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain:@"world" code:errorCode userInfo:details];
}

+ (NSInteger)daysBetween:(NSDate *)startDate and:(NSDate *)endDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger startDay = [calendar ordinalityOfUnit:NSDayCalendarUnit
                                             inUnit:NSEraCalendarUnit forDate:startDate];
    NSInteger endDay = [calendar ordinalityOfUnit:NSDayCalendarUnit
                                           inUnit:NSEraCalendarUnit forDate:endDate];
    return endDay - startDay;
}

+ (NSDate *)dateByOffset:(NSInteger)offset fromDate:(NSDate *)date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = offset;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:date options:0];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    return [NSDateFormatter localizedStringFromDate:date
                                          dateStyle:NSDateFormatterLongStyle
                                          timeStyle:NSDateFormatterNoStyle];
}

+ (void)setRightBarAddButton:(UIViewController *)viewController action:(SEL)action {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                 target:viewController
                                 action:action];
    viewController.navigationItem.rightBarButtonItem = btn;
}

+ (void)dismissView:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

+ (void)showDialogWithTitle:(NSString *)title message:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

+ (void)showErrorDialogWithTitle:(NSString *)title error:(NSError *)error {
    [self showDialogWithTitle:title message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]];
}

+ (void)showValidationErrorDialog {
    [self showDialogWithTitle:@"Missing Information"
                      message:@"Make sure you fill out all of the information!"];
}

+ (void)logError:(NSError *)error {
    NSLog(@"Error: %@", [[error userInfo] objectForKey:NSLocalizedDescriptionKey]);
}

+ (void)resetTableViewCell:(UITableViewCell *)cell {
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (UITableViewCell *)recycleCellFromTableView:(UITableView *)tableView {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    [IUtils resetTableViewCell:cell];
    return cell;
}

+ (NSString *)relativeDate:(NSDate *)date {
    TTTTimeIntervalFormatter *timeIntervalFormatter = [TTTTimeIntervalFormatter new];
    NSTimeInterval interval = [date timeIntervalSinceDate:[NSDate date]];
    return [timeIntervalFormatter stringForTimeInterval:interval];
}

@end