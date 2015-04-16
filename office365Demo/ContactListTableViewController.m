//
//  ContactListTableViewController.m
//  office365Demo
//
//  Created by Vijay Subrahmanian on 07/04/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

#import "ContactListTableViewController.h"
#import "ContactInfoTableViewController.h"
#import "MSOContactHelper.h"

@interface ContactListTableViewController () <MSOContactHelperDelegate, ContactInfoTableViewDelegate>

@property (nonatomic, strong) NSArray *contactList;
@property (nonatomic, strong) MSOContactInfoModel *selectedContact;
@property (nonatomic, strong) UIView *loadingOverlay;

@end

@implementation ContactListTableViewController

#pragma mark - Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    self.navigationItem.title = @"Contacts";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonSelected)];
    self.navigationItem.leftBarButtonItem = cancelButton;

    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
    self.loadingOverlay = [topLevelObjects objectAtIndex:0];
    self.loadingOverlay.frame = self.navigationController.view.frame;
    [self.navigationController.view addSubview:self.loadingOverlay];
    self.loadingOverlay.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *anAccessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
    NSString *aResourceID = [[NSUserDefaults standardUserDefaults] valueForKey:@"resourceID"];
    
    MSOContactHelper *aContactHelper = [[MSOContactHelper alloc] initWithADAuthToken:anAccessToken andResourceID:aResourceID];
    aContactHelper.delegate = self;
    [aContactHelper getContacts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Local Methods

- (void)cancelButtonSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ContactInfoTableViewDelegate

- (void)newContactAdded:(MSOContactInfoModel *)iContactInfo {

    [self.tableView beginUpdates];
    NSMutableArray *aContactList = [self.contactList mutableCopy];
    [aContactList insertObject:iContactInfo atIndex:0];
    self.contactList = aContactList;
    
    NSIndexPath *aFirstRow = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView insertRowsAtIndexPaths:@[aFirstRow] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [self.tableView selectRowAtIndexPath:aFirstRow animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)contactDeleted:(MSOContactInfoModel *)iContactInfo {
    
    if ([self.contactList containsObject:iContactInfo]) {
        [self.tableView beginUpdates];
        NSUInteger deletedContactIndex = [self.contactList indexOfObject:iContactInfo];
        NSMutableArray *aContactList = [self.contactList mutableCopy];
        [aContactList removeObjectAtIndex:deletedContactIndex];
        self.contactList = aContactList;

        NSIndexPath *aDeletedIndex = [NSIndexPath indexPathForRow:deletedContactIndex inSection:1];
        [self.tableView deleteRowsAtIndexPaths:@[aDeletedIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        NSIndexPath *aFirstRow = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:aFirstRow animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.tableView didSelectRowAtIndexPath:aFirstRow];
    }
}

#pragma mark - MSOContactHelperDelegate

- (void)getContactsResponse:(NSArray *)iContacts andError:(NSError *)iError {
    
    if (iContacts) {
        for (MSOContactInfoModel *aContactInfo in iContacts) {
            NSLog(@"Contact Details:\n %@", aContactInfo);
        }
        self.contactList = iContacts;
        [self.tableView reloadData];
    } else if (iError) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:iError.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    self.loadingOverlay.hidden = YES;
}

#pragma mark - Table View Datasource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return (section == 0) ? 1 : self.contactList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0) ? @"Create New Contact" : @"Existing Contacts";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"newContactCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
        MSOContactInfoModel *aContactInfo = (MSOContactInfoModel *)[self.contactList objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", aContactInfo.lastName, (aContactInfo.firstName.length) ? aContactInfo.firstName : @""];
        cell.detailTextLabel.text = (aContactInfo.businesPhone.length) ? aContactInfo.businesPhone : (aContactInfo.mobileNumber.length) ? aContactInfo.mobileNumber : aContactInfo.emailAddress;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        self.selectedContact = [[MSOContactInfoModel alloc] init];
    } else {
        self.selectedContact = [self.contactList objectAtIndex:indexPath.row];
    }
    [self performSegueWithIdentifier:@"showContactDetailsSegue" sender:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ContactInfoTableViewController *contactInfoVC = nil;
    // Not sure why this behaves diferently in iOS7 and iOS8..
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        contactInfoVC = (ContactInfoTableViewController *)[(UINavigationController *)segue.destinationViewController viewControllers][0];
    } else if ([segue.destinationViewController isKindOfClass:[ContactInfoTableViewController class]]) {
        contactInfoVC = (ContactInfoTableViewController *)segue.destinationViewController;
    }
    contactInfoVC.contactInfo = self.selectedContact;
    contactInfoVC.delegate = self;
    self.selectedContact = nil;
}

@end
