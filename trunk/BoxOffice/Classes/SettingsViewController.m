//
//  SettingsViewController.m
//  BoxOffice
//
//  Created by Cyrus Najmabadi on 4/30/08.
//  Copyright 2008 Metasyntactic. All rights reserved.
//

#import "SettingsViewController.h"
#import "ApplicationTabBarController.h"
#import "BoxOfficeAppDelegate.h"
#import "XmlParser.h"
#import "TextFieldEditorViewController.h"
#import "PickerEditorViewController.h"
#import "Utilities.h"
#import "CreditsViewController.h"

@implementation SettingsViewController

@synthesize navigationController;
@synthesize currentLocationItem;
@synthesize activityIndicator;
@synthesize locationManager;

- (void) dealloc {
    self.navigationController = nil;
    self.currentLocationItem = nil;
    self.activityIndicator = nil;
    self.locationManager = nil;
    [super dealloc];
}

- (id) initWithNavigationController:(SettingsNavigationController*) controller {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        self.title = NSLocalizedString(@"Settings", nil);
        self.navigationController = controller;
        
        self.currentLocationItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CurrentPosition.png"]
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(onCurrentLocationClicked:)] autorelease]; 
        
        self.navigationItem.leftBarButtonItem = currentLocationItem;
        
        self.locationManager = [[[CLLocationManager alloc] init] autorelease];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL) animated {
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:self.model.activityView] autorelease];
}

- (void) onCurrentLocationClicked:(id) sender {
    self.activityIndicator = [[[ActivityIndicator alloc] initWithNavigationItem:self.navigationItem] autorelease];
    [self.activityIndicator start];
    
    [self.locationManager startUpdatingLocation];
}

- (void) stopActivityIndicator {
    [self.activityIndicator stop];    
    self.activityIndicator = nil;
}

- (void) locationManager:(CLLocationManager*) manager
     didUpdateToLocation:(CLLocation*) newLocation
            fromLocation:(CLLocation*) oldLocation {
    if (oldLocation != nil) {
        [locationManager stopUpdatingLocation];
        [self performSelectorInBackground:@selector(findZipcodeBackgroundEntryPoint:) withObject:newLocation];
    }
}

- (void) findZipcodeBackgroundEntryPoint:(CLLocation*) location {
    NSAutoreleasePool* autoreleasePool= [[NSAutoreleasePool alloc] init];
    
    [self findZipcode:location];
    
    [autoreleasePool release];
}

- (void) findZipcode:(CLLocation*) location {
    CLLocationCoordinate2D coordinates = [location coordinate];
    
    NSString* urlString = [NSString stringWithFormat:@"http://ws.geonames.org/findNearbyPostalCodes?lat=%f&lng=%f&maxRows=1", coordinates.latitude, coordinates.longitude];

    XmlElement* geonamesElement = [Utilities downloadXml:urlString];
    
    NSString* zipcode = nil;
    if (geonamesElement != nil)
    {
        XmlElement* codeElement = [geonamesElement element:@"code"];
        XmlElement* postalElement = [codeElement element:@"postalcode"];
        zipcode = [postalElement text];
    }
    
    [self performSelectorOnMainThread:@selector(reportFoundZipcode:) withObject:zipcode waitUntilDone:NO];
}

- (void) reportFoundZipcode:(NSString*) zipcode {
    [self stopActivityIndicator];
    
    if ([Utilities isNilOrEmpty:zipcode]) {
        return;
    }
    
    self.model.zipcode = zipcode;
    [self.tableView reloadData];
}

- (void)locationManager:(CLLocationManager*) manager
       didFailWithError:(NSError*) error {
    [locationManager stopUpdatingLocation];
    [self stopActivityIndicator];
}

- (BoxOfficeModel*) model {
    return [self.navigationController model];
}

- (BoxOfficeController*) controller {
    return [self.navigationController controller];
}

- (void) refresh {
    [self.tableView reloadData];
}

- (UITableViewCellAccessoryType) tableView:(UITableView*) tableView
          accessoryTypeForRowWithIndexPath:(NSIndexPath*) indexPath {
    return UITableViewCellAccessoryDisclosureIndicator;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView*) tableView {
    return 3;
}

- (NSInteger)               tableView:(UITableView*) tableView
                numberOfRowsInSection:(NSInteger) section {
    return 1;
}

- (UITableViewCell*)                tableView:(UITableView*) tableView
                        cellForRowAtIndexPath:(NSIndexPath*) indexPath {
    UITableViewCell* cell = [[[UITableViewCell alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] autorelease];
    
    NSInteger section = [indexPath section];
    
    if (section == 0) {
        cell.text = [[self model] zipcode];
    } else if (section == 1) {
        cell.text = [NSString stringWithFormat:NSLocalizedString(@"%d miles", nil), [[self model] searchRadius]];
    } else if (section == 2) {
        cell.text = NSLocalizedString(@"About", nil);
    }
    
    return cell;
}

- (NSString*)               tableView:(UITableView*) tableView
              titleForHeaderInSection:(NSInteger) section {
    if (section == 0) {
        return NSLocalizedString(@"Zipcode", nil);
    } else if (section == 1) {
        return NSLocalizedString(@"Search radius", nil);
    }
    
    return nil; 
}

- (void)            tableView:(UITableView*) tableView
      didSelectRowAtIndexPath:(NSIndexPath*) indexPath {
    NSInteger section = [indexPath section];
    
    if (section == 0) {
        TextFieldEditorViewController* controller = 
        [[[TextFieldEditorViewController alloc] initWithController:self.navigationController
                                                         withTitle:NSLocalizedString(@"Zipcode", nil)
                                                        withObject:self
                                                      withSelector:@selector(onZipcodeChanged:)
                                                          withText:[self.model zipcode]
                                                          withType:UIKeyboardTypeNumbersAndPunctuation] autorelease];
        
        [self.navigationController pushViewController:controller animated:YES];
    } else if (section == 1) {
        NSArray* values = [NSArray arrayWithObjects: @"5", @"10", @"15", @"20", @"25", 
                           @"30", @"35", @"40", @"45", @"50", nil];
        NSString* defaultValue = [NSString stringWithFormat:@"%d", [self.model searchRadius]];
        
        PickerEditorViewController* controller = 
        [[[PickerEditorViewController alloc] initWithController:self.navigationController
                                                      withTitle:NSLocalizedString(@"Search radius", nil)
                                                     withObject:self
                                                   withSelector:@selector(onSearchRadiusChanged:)
                                                     withValues:values
                                                   defaultValue:defaultValue] autorelease];
        
        [self.navigationController pushViewController:controller animated:YES];
    } else if (section == 2) {
        CreditsViewController* controller = [[[CreditsViewController alloc] init] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
    
    return;
}

- (void) onZipcodeChanged:(NSString*) zipcode {
    NSMutableString* trimmed = [NSMutableString string];
    for (NSInteger i = 0; i < [zipcode length]; i++) {
        unichar c = [zipcode characterAtIndex:i];
        if (isalnum(c)) {
            [trimmed appendString:[NSString stringWithCharacters:&c length:1]];
        }
    }
    
    [self.controller setZipcode:trimmed];
    [self.tableView reloadData];
}

- (void) onSearchRadiusChanged:(NSString*) radius {
    [self.controller setSearchRadius:[radius intValue]];
    [self.tableView reloadData];
}

@end
