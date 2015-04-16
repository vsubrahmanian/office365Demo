//
//  MSOContactHelper.h
//  office365Demo
//
//  Created by Vijay Subrahmanian on 08/04/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSOContactInfoModel.h"

@protocol MSOContactHelperDelegate <NSObject>

@optional

- (void)getContactsResponse:(NSArray *)iContacts andError:(NSError *)iError;
- (void)updateContactError:(NSError *)iError;
- (void)createContactResponse:(MSOContactInfoModel *)iContact andError:(NSError *)iError;
- (void)deleteContactError:(NSError *)iError;

@end

@interface MSOContactHelper : NSObject

@property (nonatomic, weak) id <MSOContactHelperDelegate> delegate;

- (id)initWithADAuthToken:(NSString *)iToken andResourceID:(NSString *)iResourceID;
- (void)getContacts;
- (void)createContactWithContactInfo:(MSOContactInfoModel *)iContactInfo;
- (void)updateContactID:(NSUInteger)iContactID withContactInfo:(MSOContactInfoModel *)iContactInfo;
- (void)deleteContactID:(NSUInteger)contactID;

@end
