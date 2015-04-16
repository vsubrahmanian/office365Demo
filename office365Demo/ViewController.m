//
//  ViewController.m
//  office365Demo
//
//  Created by Vijay Subrahmanian on 31/03/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

#import "ViewController.h"
#import <ADALiOS/ADAuthenticationContext.h>
#import <office365_odata_base/office365_odata_base.h>
#import "ContactInfoTableViewController.h"

#define Authority @"https://login.windows.net/myTenant.onmicrosoft.com"
#define ResourceID @"https://myTenant.sharepoint.com"
#define RedirectURI @"http://testOffice365.com"
#define ClientID @"xx00xx00-x0x0-x0x0-x0x0-x0x0x0x0x0x0"


@interface ViewController() <UISplitViewControllerDelegate>

@property (nonatomic, strong) UIView *loadingOverlay;

@end

@implementation ViewController

#pragma mark - Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
    self.loadingOverlay = [topLevelObjects objectAtIndex:0];
    self.loadingOverlay.frame = self.view.frame;
    [self.view addSubview:self.loadingOverlay];
    self.loadingOverlay.hidden = NO;
    
    [self authentcateUserWithAuthority:Authority resourceID:ResourceID redirectURI:RedirectURI andClientID:ClientID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Local methods

- (void)authentcateUserWithAuthority:(NSString *)iAuthority resourceID:(NSString *)iResourceID redirectURI:(NSString *)iRedirectURI andClientID:(NSString *)iClientID {
    // Create an instance of ADAuthenticationContext
    ADAuthenticationContext *anAuthContext;
    ADAuthenticationError *anError;
    anAuthContext = [ADAuthenticationContext authenticationContextWithAuthority:iAuthority error:&anError];
    
    __block NSString *anAccessToken;
    
    if (!anError) {
        // Acquire a token (prompts user to sign in)
        [anAuthContext acquireTokenWithResource:iResourceID
                                       clientId:iClientID
                                    redirectUri:[NSURL URLWithString:iRedirectURI]
                                completionBlock:^(ADAuthenticationResult *result) {
                                    // handle authentication error or success with
                                    // result.error or result.accessToken ...
                                    if (!result.error) {
                                        anAccessToken = result.accessToken;
                                        // If auth is successful, save it in user defaults
                                        if (anAccessToken) {
                                            NSLog(@"Access Token: %@", anAccessToken);
                                            [[NSUserDefaults standardUserDefaults] setValue:anAccessToken forKey:@"accessToken"];
                                            [[NSUserDefaults standardUserDefaults] setValue:iResourceID forKey:@"resourceID"];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
                                        }
                                        [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Login Successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                    } else {
                                        NSLog(@"Error getting token: %@", result.error.localizedDescription);
                                        [[[UIAlertView alloc] initWithTitle:@"Error" message:result.error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                                    }
                                    self.loadingOverlay.hidden = YES;
                                }];
        
    } else {
        NSLog(@"Error setting Auth context: %@", anError.localizedDescription);
        [[[UIAlertView alloc] initWithTitle:@"Error" message:anError.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        self.loadingOverlay.hidden = YES;
    }
}

#pragma mark - UISplitViewControllerDelegate methods

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    // This is not to automatically show the detail view controller on inital load [in portrait mode].
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController viewControllers][0] isKindOfClass:[ContactInfoTableViewController class]] && ([(ContactInfoTableViewController *)[(UINavigationController *)secondaryViewController viewControllers][0] contactInfo] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UISplitViewController *splitViewController = (UISplitViewController *)segue.destinationViewController;
    splitViewController.delegate = self;
}

@end
