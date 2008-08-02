// Copyright (C) 2008 Cyrus Najmabadi
//
// This program is free software; you can redistribute it and/or modify it 
// under the terms of the GNU General Public License as published by the Free
// Software Foundation; either version 2 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, write to the Free Software Foundation, Inc., 51 
// Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#import "TicketsViewController.h"
#import "AbstractNavigationController.h"
#import "DifferenceEngine.h"
#import "Utilities.h"
#import "Application.h"
#import "AutoresizingCell.h"
#import "ApplicationTabBarController.h"
#import "ViewControllerUtilities.h"
#import "Performance.h"
#import "AttributeCell.h"
#import "DateUtilities.h"
#import "SearchDatePickerViewController.h"
#import "ColorCache.h"

@implementation TicketsViewController

@synthesize navigationController;
@synthesize theater;
@synthesize movie;
@synthesize performances;
@synthesize futurePerformances;

- (void) dealloc {
    self.navigationController = nil;
    self.theater = nil;
    self.movie = nil;
    self.performances = nil;
    self.futurePerformances = nil;

    [super dealloc];
}

- (BoxOfficeController*) controller {
    return [self.navigationController controller];
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (void) refresh {
    NSArray* allPerformances =  [self.model moviePerformances:movie forTheater:theater];
    self.performances = [NSMutableArray array];
    self.futurePerformances = [NSMutableArray array];

    NSDate* now = [NSDate date];
    for (Performance* performance in allPerformances) {
        if ([DateUtilities isToday:[self.model searchDate]]) {
            NSDate* showtimeDate = [DateUtilities dateWithNaturalLanguageString:performance.time];

            if ([now compare:showtimeDate] == NSOrderedDescending) {
                //[self.futurePerformances addObject:performance];
                continue;
            }
        }

        [self.performances addObject:performance];
    }
}

- (id) initWithController:(AbstractNavigationController*) navigationController_
                  theater:(Theater*) theater_
                    movie:(Movie*) movie_
                    title:(NSString*) title_ {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.navigationController = navigationController_;
        self.theater = theater_;
        self.movie = movie_;

        UILabel* label = [ViewControllerUtilities viewControllerTitleLabel];
        label.text = title_;

        self.title = title_;
        self.navigationItem.titleView = label;

        [self refresh];
    }

    return self;
}

- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];

    [self.model setCurrentlySelectedMovie:self.movie theater:self.theater];

    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:animated];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    NSInteger sections = 3;
    if (futurePerformances.count > 0) {
        sections++;
    }

    return sections;
}

- (NSInteger)       tableView:(UITableView*) tableView
        numberOfRowsInSection:(NSInteger) section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return performances.count;
    } else if (section == 3) {
        return futurePerformances.count;
    }

    return 0;
}

- (NSString*)       tableView:(UITableView*) tableView
      titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return nil;
    } else if (section == 1) {
        return nil;
    } else if (section == 2 && performances.count) {
        NSString* dateString = [DateUtilities formatFullDate:[self.model searchDate]];

        if ([DateUtilities isToday:[self.model searchDate]]) {
            return [NSString stringWithFormat:NSLocalizedString(@"Today - %@", nil), dateString];
        } else {
            return dateString;
        }
    } else if (section == 3 && futurePerformances.count) {
        return [NSString stringWithFormat:NSLocalizedString(@"Tomorrow - %@", nil),
                [DateUtilities formatFullDate:[DateUtilities tomorrow]]];
    }

    return nil;
}

- (UITableViewCell*) showtimeCellForSection:(NSInteger) section row:(NSInteger) row {
    static NSString* reuseIdentifier = @"TicketsViewShowtimeCellIdentifier";

    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].bounds
                                       reuseIdentifier:reuseIdentifier] autorelease];

        cell.textAlignment = UITextAlignmentCenter;
        cell.font = [UIFont boldSystemFontOfSize:14];
    }

    NSArray* list = (section == 2 ? self.performances : self.futurePerformances);
    
    Performance* performance = [list objectAtIndex:row];
    
    if (![self.theater.sellsTickets isEqual:@"True"] ||
        [Utilities isNilOrEmpty:[performance identifier]]) {
        cell.textColor = [UIColor blackColor];
        cell.text = [NSString stringWithFormat:NSLocalizedString(@"%@ (No Online Ticketing)", nil), [performance time]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.textColor = [ColorCache commandColor];
        cell.text = [NSString stringWithFormat:NSLocalizedString(@"Order tickets for %@", nil), [performance time]];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }

    return cell;
}

- (UITableViewCell*) commandCellForRow:(NSInteger) row {
    AttributeCell* cell = [[[AttributeCell alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                reuseIdentifier:nil] autorelease];

    if (row == 0) {
        Location* location = [self.model locationForAddress:theater.address];
        if (![Utilities isNilOrEmpty:location.address] && ![Utilities isNilOrEmpty:location.city]) {
            [cell setKey:NSLocalizedString(@"Map", nil)
                   value:[NSString stringWithFormat:@"%@, %@", location.address, location.city]
            hasIndicator:NO];
        } else {
            [cell setKey:NSLocalizedString(@"Map", nil) value:theater.address hasIndicator:NO];
        }
    } else {
        [cell setKey:NSLocalizedString(@"Call", nil) value:theater.phoneNumber hasIndicator:NO];
    }

    return cell;
}

- (UITableViewCell*) changeDateCell {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].bounds
                                                    reuseIdentifier:nil] autorelease];

    cell.textAlignment = UITextAlignmentCenter;
    cell.font = [UIFont boldSystemFontOfSize:14];
    cell.textColor = [ColorCache commandColor];

    cell.text = NSLocalizedString(@"Change date", nil);

    return cell;
}

- (UITableViewCell*)        tableView:(UITableView*) tableView
                cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        return [self commandCellForRow:indexPath.row];
    } else if (indexPath.section == 1) {
        return [self changeDateCell];
    } else if (indexPath.section == 2 || indexPath.section == 3) {
        return [self showtimeCellForSection:indexPath.section row:indexPath.row];
    }

    return nil;
}

- (void) didSelectCommandAtRow:(NSInteger) row {
    if (row == 0) {
        [Application openMap:theater.address];
    } else if (row == 1) {
        [Application makeCall:theater.phoneNumber];
    }
}

- (void) didSelectShowtimeAtRow:(NSInteger) row {
    Performance* performance = [self.performances objectAtIndex:row];
    NSString* showId = performance.identifier;

    if (![self.theater.sellsTickets isEqual:@"True"] ||
        [Utilities isNilOrEmpty:showId]) {
        return;
    }

    //https://mobile.fandango.com/tickets.jsp?mk=98591&tk=557&showtime=2008:5:11:16:00
    //https://www.fandango.com/purchase/movietickets/process03/ticketboxoffice.aspx?row_count=1601099982&mid=98591&tid=AAJNK

    NSDateComponents* dateComponents =
    [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                    fromDate:[self.model searchDate]];
    NSDateComponents* timeComponents =
    [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit)
                                    fromDate:[DateUtilities dateWithNaturalLanguageString:performance.time]];

    NSString* url =
    [NSString stringWithFormat:@"https://mobile.fandango.com/tickets.jsp?mk=%@&tk=%@&showtime=%d:%d:%d:%d:%02d",
     self.movie.identifier,
     self.theater.identifier,
     [dateComponents year],
     [dateComponents month],
     [dateComponents day],
     [timeComponents hour],
     [timeComponents minute]];

    [Application openBrowser:url];
}

- (void) didSelectFutureShowtimeAtRow:(NSInteger) row {
    Performance* performance = [self.futurePerformances objectAtIndex:row];
    NSString* showId = performance.identifier;

    if (![self.theater.sellsTickets isEqual:@"True"] ||
        [Utilities isNilOrEmpty:showId]) {
        return;
    }

    //https://mobile.fandango.com/tickets.jsp?mk=98591&tk=557&showtime=2008:5:11:16:00
    //https://www.fandango.com/purchase/movietickets/process03/ticketboxoffice.aspx?row_count=1601099982&mid=98591&tid=AAJNK

    NSDate* showDate = [DateUtilities dateWithNaturalLanguageString:performance.time];
    NSDateComponents* oneDayComponents = [[[NSDateComponents alloc] init] autorelease];
    oneDayComponents.day = 1;

    NSDate* tomorrow = [[NSCalendar currentCalendar] dateByAddingComponents:oneDayComponents toDate:showDate options:0];
    NSDateComponents* components = [[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit)
                                                                   fromDate:tomorrow];


    NSString* url =
    [NSString stringWithFormat:@"https://mobile.fandango.com/tickets.jsp?mk=%@&tk=%@&showtime=%d:%d:%d:%d:%02d",
     self.movie.identifier,
     self.theater.identifier,
     [components year],
     [components month],
     [components day],
     [components hour],
     [components minute]];

    [Application openBrowser:url];
}

- (void) didSelectChangeDate {
    SearchDatePickerViewController* pickerController =
    [SearchDatePickerViewController pickerWithNavigationController:self.navigationController controller:[self.navigationController controller]];
    [self.navigationController pushViewController:pickerController animated:YES];
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    if (indexPath.section == 0) {
        [self didSelectCommandAtRow:indexPath.row];
    } else if (indexPath.section == 1) {
        [self didSelectChangeDate];
    } else if (indexPath.section == 2) {
        [self didSelectShowtimeAtRow:indexPath.row];
    } else if (indexPath.section == 3) {
        [self didSelectFutureShowtimeAtRow:indexPath.row];
    }
}

@end

