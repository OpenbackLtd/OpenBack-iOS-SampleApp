//
//  AppInboxViewController.m
//
//  Copyright © 2019 OpenBack, Ltd. All rights reserved.
//

@import OpenBack;
#import "AppInboxViewController.h"

@interface InboxCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fieldTitle;
@property (weak, nonatomic) IBOutlet UILabel *fieldContent;
@property (weak, nonatomic) IBOutlet UILabel *fieldDate;
@property (weak, nonatomic) IBOutlet UIImageView *chevronView;
@property (weak, nonatomic) IBOutlet UIImageView *envelope;

@end

@implementation InboxCell

@end

@interface AppInboxViewController () <UITableViewDelegate, UITableViewDataSource, OpenBackAppInboxDelegate>

@property (strong, nonatomic) OpenBackAppInbox *inbox;
@property (strong, nonatomic) NSArray<OpenBackAppInboxMessage *> *messages;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *noMessagesLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation AppInboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.noMessagesLabel.hidden = YES;
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    self.inbox = OpenBack.appInbox;
    self.inbox.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.inbox getAllMessages:^(NSArray<OpenBackAppInboxMessage *> * _Nonnull messages) {
        self.messages = messages;
        [self.tableView reloadData];
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
    }];
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.noMessagesLabel.hidden = self.messages.count > 0 ? YES : NO;
    return self.messages.count;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InboxCell" forIndexPath:indexPath];
    OpenBackAppInboxMessage *message = [self.messages objectAtIndex:indexPath.row];
    cell.fieldTitle.text = message.title;
    cell.fieldTitle.font = message.isRead ? [self normalFont:cell.fieldTitle.font] : [self boldFont:cell.fieldTitle.font];
    cell.fieldContent.text = message.content;
    cell.fieldContent.font = message.isRead ? [self normalFont:cell.fieldContent.font] : [self boldFont:cell.fieldContent.font];
    NSDate *deliveryDate = [NSDate dateWithTimeIntervalSince1970:message.deliveryTime];
    cell.fieldDate.text = [AppInboxViewController relativeDateFromNow:deliveryDate];
    cell.chevronView.hidden = !message.isActionable;
    cell.envelope.image = [UIImage imageNamed:message.isRead ? @"FA-Envelope-Open" : @"FA-Envelope"];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    OpenBackAppInboxMessage *message = [self.messages objectAtIndex:indexPath.row];
    return message.isActionable;
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OpenBackAppInboxMessage *message = [self.messages objectAtIndex:indexPath.row];
    [self.inbox executeMessage:message completion:^(NSError * _Nullable error) {
        [self.inbox getAllMessages:^(NSArray<OpenBackAppInboxMessage *> * _Nonnull messages) {
            self.messages = messages;
            [self.tableView reloadData];
        }];
    }];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.inbox removeMessage:self.messages[indexPath.row] completion:^(NSError * _Nullable error) {
            [self.inbox getAllMessages:^(NSArray<OpenBackAppInboxMessage *> * _Nonnull messages) {
                self.messages = messages;
                [self.tableView reloadData];
            }];
        }];
    }
}

#pragma mark - Inbox Delegate

- (void)appInboxMessageRead:(OpenBackAppInboxMessage *)message {
    // Lazy full refresh
    [self.inbox getAllMessages:^(NSArray<OpenBackAppInboxMessage *> * _Nonnull messages) {
        self.messages = messages;
        [self.tableView reloadData];
    }];
}

- (void)appInboxMessageAdded:(OpenBackAppInboxMessage *)message {
    // Lazy full refresh
    [self.inbox getAllMessages:^(NSArray<OpenBackAppInboxMessage *> * _Nonnull messages) {
        self.messages = messages;
        [self.tableView reloadData];
    }];
}

- (void)appInboxMessageExpired:(OpenBackAppInboxMessage *)message {
    // Lazy full refresh
    [self.inbox getAllMessages:^(NSArray<OpenBackAppInboxMessage *> * _Nonnull messages) {
        self.messages = messages;
        [self.tableView reloadData];
    }];
}

#pragma mark - Font Helper

- (UIFont *)normalFont:(UIFont *)font {
    UIFontDescriptor *descriptor = font.fontDescriptor;
    descriptor = [descriptor fontDescriptorWithSymbolicTraits:0];
    return [UIFont fontWithDescriptor:descriptor size:0];
}

- (UIFont *)boldFont:(UIFont *)font {
    UIFontDescriptor *descriptor = font.fontDescriptor;
    descriptor = [descriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    return [UIFont fontWithDescriptor:descriptor size:0];
}

#pragma mark - Close Handler

- (IBAction)handleCloseButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Utils

+ (NSString *)relativeDateFromNow:(NSDate *)date {
    NSCalendarUnit units = NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units fromDate:date toDate:[NSDate date] options:0];
    if (components.year == 1) {
        return @"a year ago";
    } else if (components.year > 0) {
        return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
    } else if (components.month == 1) {
        return @"a month ago";
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    } else if (components.weekOfYear == 1) {
        return @"a week ago";
    } else if (components.weekOfYear > 0) {
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    } else if (components.day == 1) {
        return @"yesterday";
    } else if (components.day > 0) {
        return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
    } else if (components.hour == 1) {
        return @"an hour ago";
    } else if (components.hour > 6) {
        return @"today";
    } else if (components.hour > 0) {
        return [NSString stringWithFormat:@"%ld hours ago", (long)components.hour];
    } else if (components.minute < 1) {
        return @"just now";
    } else if (components.minute < 20) {
        return @"a few minutes ago";
    } else if (components.minute > 0) {
        return [NSString stringWithFormat:@"%ld minutes ago", (long)components.minute];
    }
    return @"-";
}

@end
