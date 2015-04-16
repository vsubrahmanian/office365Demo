//
//  ContactInfoTableViewController.m
//  office365Demo
//
//  Created by Vijay Subrahmanian on 07/04/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

#import "ContactInfoTableViewController.h"
#import "ContactFieldTableViewCell.h"
#import "MSOContactHelper.h"

@interface ContactInfoTableViewController () <MSOContactHelperDelegate, ContactFieldTableViewCellDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) NSArray *contactRelations;
@property (nonatomic, strong) NSIndexPath *activeCellIndex;
@property (nonatomic, strong) MSOContactHelper *contactHelper;
@property (nonatomic, strong) MSOContactInfoModel *contactInfoUnmodified;
@property (nonatomic, strong) UIView *loadingOverlay;
@property (nonatomic) BOOL isEditingContact;

@end

@implementation ContactInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *anAccessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
    NSString *aResourceID = [[NSUserDefaults standardUserDefaults] valueForKey:@"resourceID"];
    
    self.contactHelper = [[MSOContactHelper alloc] initWithADAuthToken:anAccessToken andResourceID:aResourceID];
    self.contactHelper.delegate = self;
    [self.contactHelper getContacts];
    
    NSDictionary *contactRelationInfo = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"contactRelation" ofType:@"plist"]];
    NSDictionary *contactFieldInfo = (NSDictionary *)[contactRelationInfo valueForKey:@"contactFields"];
    NSArray *contactFieldOrderList = (NSArray *)[contactRelationInfo valueForKey:@"contactFieldDisplayOrder"];
    
    NSMutableArray *aContactRelationsList = [[NSMutableArray alloc] initWithCapacity:contactFieldOrderList.count];
    
    for (NSString *contactFieldKey in contactFieldOrderList) {
        [aContactRelationsList addObject:[contactFieldInfo valueForKey:contactFieldKey]];
    }
    self.contactRelations = aContactRelationsList;
    
    self.navigationItem.title = @"Contact Details";
    
    if (self.contactInfo.ID) {
        UIBarButtonItem *deleteContactButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteContact)];
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editContact)];
        self.navigationItem.rightBarButtonItems = @[deleteContactButton, editButton];
    } else if (self.contactInfo) {
        self.isEditingContact = YES;
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveContact)];
        self.navigationItem.rightBarButtonItems = @[saveButton];
    } else {
        self.navigationItem.rightBarButtonItems = nil;
    }
    
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
    self.loadingOverlay = [topLevelObjects objectAtIndex:0];
    self.loadingOverlay.frame = self.navigationController.view.frame;
    [self.navigationController.view addSubview:self.loadingOverlay];
    self.loadingOverlay.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setContactInfo:(MSOContactInfoModel *)iContactInfo {
    _contactInfo = iContactInfo;

    if (self.contactInfo.ID) {
        self.isEditingContact = NO;
        UIBarButtonItem *deleteContactButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteContact)];
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editContact)];
        self.navigationItem.rightBarButtonItems = @[deleteContactButton, editButton];
    } else if (self.contactInfo) {
        self.isEditingContact = YES;
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveContact)];
        self.navigationItem.rightBarButtonItems = @[saveButton];
    } else {
        self.navigationItem.rightBarButtonItems = nil;
    }
    [self.tableView reloadData];
}

#pragma mark - Local Methods

- (void)editContact {
    self.isEditingContact = YES;
    UIBarButtonItem *deleteContactButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteContact)];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveContact)];
    self.navigationItem.rightBarButtonItems = @[deleteContactButton, saveButton];
    [self.tableView reloadData];
}

- (void)saveContact {
    
    if (!self.contactInfo.lastName.length) {
        // Last name is missing. Show an alert.
        [[[UIAlertView alloc] initWithTitle:@"Last Name required" message:@"Please enter the Last Name before saving the contact" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    [self resignFirstResponder];
    
    if (self.contactInfo.ID) {
        // Updating Contact
        self.loadingOverlay.hidden = NO;
        [self.contactHelper updateContactID:self.contactInfo.ID withContactInfo:self.contactInfo];
    } else {
        // Creating Contact
        self.loadingOverlay.hidden = NO;
        [self.contactHelper createContactWithContactInfo:self.contactInfo];
    }
}

- (void)deleteContact {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sure you want to delete this contact?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItems[0] animated:YES];
    } else {
        [actionSheet showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate 

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.destructiveButtonIndex == buttonIndex) {
        // Delete Contact
        self.loadingOverlay.hidden = NO;
        [self.contactHelper deleteContactID:self.contactInfo.ID];
    }
}

#pragma mark - MSOContactHelperDelegate

- (void)updateContactError:(NSError *)iError {
    self.isEditingContact = NO;
    UIBarButtonItem *deleteContactButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteContact)];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editContact)];
    self.navigationItem.rightBarButtonItems = @[deleteContactButton, editButton];

    if (iError) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:iError.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        [self.tableView reloadData];
    }
    self.loadingOverlay.hidden = YES;
}

- (void)createContactResponse:(MSOContactInfoModel *)iContact andError:(NSError *)iError {
    self.isEditingContact = NO;
    UIBarButtonItem *deleteContactButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteContact)];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editContact)];
    self.navigationItem.rightBarButtonItems = @[deleteContactButton, editButton];
    
    if (iError) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:iError.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        self.contactInfo = iContact;
        
        if ([self.delegate respondsToSelector:@selector(newContactAdded:)]) {
            [self.delegate newContactAdded:iContact];
        }
    }
    self.loadingOverlay.hidden = YES;
}

- (void)deleteContactError:(NSError *)iError {

    if (iError) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:iError.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        
        if ([self.delegate respondsToSelector:@selector(contactDeleted:)]) {
            [self.delegate contactDeleted:self.contactInfo];
        }
    }
}

#pragma mark - TableView Datasource and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return (self.contactInfo) ? self.contactRelations.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *aContactFieldInfo = [self.contactRelations objectAtIndex:section];
    return [aContactFieldInfo valueForKey:@"sectionTitle"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *aContactFieldInfo = [self.contactRelations objectAtIndex:indexPath.section];
    NSString *rowHeight = [aContactFieldInfo valueForKey:@"cellHeight"];
    return (rowHeight.floatValue) ? rowHeight.floatValue : 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *aContactFieldInfo = [self.contactRelations objectAtIndex:indexPath.section];
    NSString *reuseIdentifier = @"textFieldCell";
    contactFieldCellStyle cellStyle = contactFieldCellTextField;
    
    if ([[aContactFieldInfo valueForKey:@"type"] isEqualToString:@"textView"]) {
        reuseIdentifier = @"textViewCell";
        cellStyle = contactFieldCellTextView;
    }
    NSString *aModelPropertyKey = [aContactFieldInfo valueForKey:@"key"];
    
    ContactFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    // Check if any cell is available for reuse.
    if (!cell) {
        cell = [[ContactFieldTableViewCell alloc] initWithStyle:cellStyle andReuseIdentifier:reuseIdentifier];
    }
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.enableFieldEditing = self.isEditingContact;
    cell.fieldIdentifierKey = aModelPropertyKey;
    cell.fieldValue = [self.contactInfo valueForFieldKey:aModelPropertyKey];
    cell.fieldTableIndex = indexPath;
    cell.fieldPlaceHolderText = (self.isEditingContact) ? [aContactFieldInfo valueForKey:@"placeholder"] : @" - ";
    cell.delegate = self;
    
    return cell;
}

#pragma mark - ContactFieldTableViewCellDelegate methods

- (void)fieldDidBeginEditingAtIndex:(NSIndexPath *)iIndexPath {
    self.activeCellIndex = iIndexPath;
}

- (void)fieldValueUpdated:(NSString *)iFieldValue forField:(NSString *)iFieldIdentifier {
    [self.contactInfo setFieldValue:iFieldValue forKey:iFieldIdentifier];
}

#pragma mark - Keyboard frame adjustment methods
// Adjusting view when the keyboard appears
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
        // iOS 8 accounts for orientation while iOS7 doesn't.
        kbSize = CGSizeMake(kbSize.height, kbSize.width);
    }
    
    UIEdgeInsets contentInsets = self.tableView.contentInset;
//     // I donnno why I need to do this. If am not doing this, not working fine in all iOS versions.
//     // http://stackoverflow.com/questions/594181/making-a-uitableview-scroll-when-text-field-is-selected
    if (contentInsets.bottom != kbSize.height) {
        contentInsets.bottom = kbSize.height;
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
    }
    // Scroll to editing cell.
    [self.tableView scrollToRowAtIndexPath:self.activeCellIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
