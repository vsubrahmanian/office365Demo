//
//  MSOContactInfoModel.h
//  office365Demo
//
//  Created by Vijay Subrahmanian on 08/04/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSOContactInfoModel : NSObject

@property (nonatomic) NSUInteger ID;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic, strong) NSString *company;
@property (nonatomic, strong) NSString *jobTitle;
@property (nonatomic, strong) NSString *businesPhone;
@property (nonatomic, strong) NSString *homePhone;
@property (nonatomic, strong) NSString *mobileNumber;
@property (nonatomic, strong) NSString *faxNumber;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *stateOrProvince;
@property (nonatomic, strong) NSString *zipOrPostalCode;
@property (nonatomic, strong) NSString *countryOrRegion;
@property (nonatomic, strong) NSString *webpageURL;
@property (nonatomic, strong) NSString *webpageDescription;
@property (nonatomic, strong) NSString *notes;

// Use the below methods for setting and accessing the object properties using key value coding.
// Have added safe checks so that it doesn't result in an exception.
- (void)setFieldValue:(NSString *)iValue forKey:(NSString *)iKey;
- (NSString *)valueForFieldKey:(NSString *)iKey;

@end
