//
//  DetailViewController.m
//  RPI Directory
//
//  Created by Brendon Justin on 4/13/12.
//  Copyright (c) 2012 Brendon Justin. All rights reserved.
//

#import "DirectoryDetailViewController.h"
#import "Person.h"

@interface DirectoryDetailViewController ()

- (void)configureView;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@end

@implementation DirectoryDetailViewController

@synthesize person;
@synthesize masterPopoverController = _masterPopoverController;

#pragma mark - Initialization

- (id)initWithPerson:(Person *)newPerson {
    self = [super init];
    if (self) {
        person = newPerson;
    }
    return self;
}

#pragma mark - Managing the detail item

- (void)setPerson:(Person *)newPerson
{
    if (person != newPerson) {
        person = newPerson;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *addContactButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showContactSheeet)];
    self.navigationItem.rightBarButtonItem = addContactButton;
    
    //Configure TableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.person = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Action

- (void)showContactSheeet {
    UIActionSheet *addContactSheet = [[UIActionSheet alloc] initWithTitle:person.name delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Create New Contact", @"Add to Existing Contact", nil];
    [addContactSheet showInView:self.view];
}

#pragma mark - UIActionSheet Delegate

- (void)addNewContact {
    //NSString * addressString1 = [appDelegate getCurrentSummary];
    //NSString * addressString2 = [appDelegate getCurrentTubeImage];
    //NSString * cityName = [appDelegate getCurrentcheckValue];
    //NSString * stateName = [appDelegate getCurrentTubeUrl];
    //NSString * postal = [appDelegate getCurrentViews];
    NSString *emailString = self.person.details[@"email"];
    NSString *phoneNumber = self.person.details[@"phone"];
    NSString *prefName = self.person.name;
    NSString *notes = self.person.notes;
    
    CFErrorRef *error = nil;
    ABAddressBookRef libroDirec = ABAddressBookCreateWithOptions(NULL, error);
    
    ABRecordRef persona = ABPersonCreate();
    ABRecordSetValue(persona, kABPersonFirstNameProperty, (__bridge CFTypeRef)([self.person.details[@"first_name"] capitalizedString]), nil);
    ABRecordSetValue(persona, kABPersonMiddleNameProperty, (__bridge CFTypeRef)([self.person.details[@"middle_name"] capitalizedString]), nil);
    ABRecordSetValue(persona, kABPersonLastNameProperty, (__bridge CFTypeRef)([self.person.details[@"last_name"] capitalizedString]), nil);
    ABRecordSetValue(persona, kABPersonOrganizationProperty, @"Rensselaer Polytechnic Institute", nil);
    ABRecordSetValue(persona, kABPersonDepartmentProperty, (__bridge CFTypeRef)([self.person.details[@"major"] capitalizedString]), nil);
    
    //const CFStringRef customLabel = CFSTR( "major" );
    
    //phone
    /*ABMutableMultiValueRef multiPhone2 = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone2, (__bridge CFTypeRef)([self.person.details[@"major"] capitalizedString]), customLabel, NULL);
    ABRecordSetValue(persona, kABPerson, multiPhone2,nil);
    CFRelease(multiPhone2);
    
    ABAddressBookAddRecord(libroDirec, persona, error);*/
    
    
    
    /*ABMutableMultiValueRef multiHome = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    
    NSString *homeStreetAddress=[addressString1 stringByAppendingString:addressString2];
    
    [addressDictionary setObject:homeStreetAddress forKey:(NSString *) kABPersonAddressStreetKey];
    
    [addressDictionary setObject:cityName forKey:(NSString *)kABPersonAddressCityKey];
    
    [addressDictionary setObject:stateName forKey:(NSString *)kABPersonAddressStateKey];
    
    [addressDictionary setObject:postal forKey:(NSString *)kABPersonAddressZIPKey];*/
    
    /*bool didAddHome = ABMultiValueAddValueAndLabel(multiHome, addressDictionary, kABHomeLabel, NULL);
    
    if(didAddHome)
    {
        ABRecordSetValue(persona, kABPersonAddressProperty, multiHome, NULL);
        
        NSLog(@"Address saved.....");
    }
    
    [addressDictionary release];*/
    
    //##############################################################################
    
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    
    bool didAddPhone = ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(phoneNumber), kABPersonPhoneMobileLabel, NULL);
    
    if (didAddPhone) {
        
        ABRecordSetValue(persona, kABPersonPhoneProperty, multiPhone,nil);
        
        NSLog(@"Phone Number saved......");
        
    }
    else {
        NSLog(@"Couldnt add phone");
    }
    
    CFRelease(multiPhone);
    
    //##############################################################################
    
    ABMutableMultiValueRef emailMultiValue = ABMultiValueCreateMutable(kABPersonEmailProperty);
    
    bool didAddEmail = ABMultiValueAddValueAndLabel(emailMultiValue, (__bridge CFTypeRef)(emailString), kABOtherLabel, NULL);
    
    if(didAddEmail) {
        
        ABRecordSetValue(persona, kABPersonEmailProperty, emailMultiValue, nil);
        
        NSLog(@"Email saved......");
    }
    
    CFRelease(emailMultiValue);
    
    //##############################################################################
    
    ABAddressBookAddRecord(libroDirec, persona, nil);
    
    CFRelease(persona);
    bool good = TRUE;
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(persona, ^(bool granted, CFErrorRef error) {
            // First time ac cess has been granted, add the contact
            
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        good = TRUE;
    }
    else {
        good = false;
    }
    if (good) {
        bool addContact = ABAddressBookSave(libroDirec, nil);
        if (addContact) {
            NSString * errorString = [NSString stringWithFormat:@"Information are saved into Contact"];
            
            UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"New Contact Info" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [errorAlert show];
        }
        else {
            NSLog(@"Get fucked");
        }
    }
    
    
    
    CFRelease(libroDirec);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Create New Contact
    if (buttonIndex == 0) {
        [self addNewContact];
    }
    //Add To Existing
    else if (buttonIndex == 1) {
        
    }
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *labelString = nil;
    NSString *detailString = nil;
    CGFloat height, height2, greaterHeight, padding;
    
    int count = 0;
    for (NSString *string in self.person.details) {
        if (count++ == indexPath.row) {
            labelString = string;
            detailString = [self.person.details objectForKey:string];
        }
    }
    
    if (labelString == nil || detailString == nil) {
        return 44;
    } else {
        labelString = [labelString stringByReplacingOccurrencesOfString:@"_"
                                                             withString:@" "];
        
        //  Based on code by Tim Rupe on StackOverflow:
        //  http://stackoverflow.com/questions/129502/how-do-i-wrap-text-in-a-uitableviewcell-without-a-custom-cell
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:12.0];
        CGSize constraintSize = CGSizeMake(67.0f, MAXFLOAT);
        CGSize labelSize = [labelString sizeWithFont:cellFont constrainedToSize:constraintSize];
        
        height = labelSize.height;
        
        cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
        constraintSize = CGSizeMake(320.0f - 67.0f - 20.0f, MAXFLOAT);
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            constraintSize = CGSizeMake(768.0f - 67.0f - 60.0f, MAXFLOAT);
        }
        labelSize = [detailString sizeWithFont:cellFont constrainedToSize:constraintSize];

        height2 = labelSize.height;
        
        //  Find the greater of the two.  If it is less than 30 pixels (empirically determined),
        //  then just return 44.
        if (height > height2) {
            greaterHeight = height;
            padding = 14;
        } else {
            greaterHeight = height2;
            padding = 10;
        }
        
        return greaterHeight > 30 ? greaterHeight + padding : 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.person) {
        return [self.person.details count];
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.person) {
        return person.name;
    } else {
        return @"Details for selection will appear here.";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2
                                      reuseIdentifier:@"DetailCell"];
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
    }
    
    int count = 0;
    for (NSString *string in self.person.details) {
        if (count++ == indexPath.row) {
            cell.textLabel.text = [string stringByReplacingOccurrencesOfString:@"_"
                                                                    withString:@" "];
            cell.detailTextLabel.text = [self.person.details objectForKey:string];
        }
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Search RPI", @"Search RPI");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
