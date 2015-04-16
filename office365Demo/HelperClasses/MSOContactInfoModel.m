//
//  MSOContactInfoModel.m
//  office365Demo
//
//  Created by Vijay Subrahmanian on 08/04/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

#import "MSOContactInfoModel.h"

@interface MSOContactInfoModel() <NSMutableCopying, NSCopying, NSCoding>

@end

@implementation MSOContactInfoModel

- (void)setFieldValue:(NSString *)iValue forKey:(NSString *)iKey {

    if ([self respondsToSelector:NSSelectorFromString(iKey)]) {
    
        if (![iValue isEqual:[NSNull null]]) {
            [self setValue:iValue forKey:iKey];
        }
    }
}

- (NSString *)valueForFieldKey:(NSString *)iKey {
    NSString *value = @"";
    
    if ([self respondsToSelector:NSSelectorFromString(iKey)]) {
        value = [self valueForKey:iKey];
    }
    return value;
}

- (NSString *)description {
    // Printing all Values in Description.
    return [NSString stringWithFormat:@"\nLast name: %@\nFirst name: %@\nFull name: %@\nEmail: %@\nCompany: %@\nJob Title: %@\nBusiness Ph: %@\nHome Ph: %@\nMob: %@\nFax: %@\nAddress: %@\nCity: %@\nState: %@\nZip: %@\nCountry: %@\nWeb URL: %@\nWeb Desc: %@\nNotes: %@\n", self.lastName, self.firstName, self.fullName, self.emailAddress, self.company, self.jobTitle, self.businesPhone, self.homePhone, self.mobileNumber, self.faxNumber, self.address, self.city, self.stateOrProvince, self.zipOrPostalCode, self.countryOrRegion, self.webpageURL, self.webpageDescription, self.notes];
}

#pragma mark - NSMutableCopyingProtocol

- (id)mutableCopyWithZone:(NSZone *)zone {
    MSOContactInfoModel *aDuplicate = [[MSOContactInfoModel allocWithZone:zone] init];
    
    if (aDuplicate) {
        aDuplicate.ID = self.ID;
        aDuplicate.lastName = [self.lastName copy];
        aDuplicate.firstName = [self.firstName copy];
        aDuplicate.fullName = [self.fullName copy];
        aDuplicate.emailAddress = [self.emailAddress copy];
        aDuplicate.company = [self.company copy];
        aDuplicate.jobTitle = [self.jobTitle copy];
        aDuplicate.businesPhone = [self.businesPhone copy];
        aDuplicate.homePhone = [self.homePhone copy];
        aDuplicate.mobileNumber = [self.mobileNumber copy];
        aDuplicate.faxNumber = [self.faxNumber copy];
        aDuplicate.address = [self.address copy];
        aDuplicate.city = [self.city copy];
        aDuplicate.stateOrProvince = [self.stateOrProvince copy];
        aDuplicate.zipOrPostalCode = [self.zipOrPostalCode copy];
        aDuplicate.countryOrRegion = [self.countryOrRegion copy];
        aDuplicate.webpageURL = [self.webpageURL copy];
        aDuplicate.webpageDescription = [self.webpageDescription copy];
        aDuplicate.notes = [self.notes copy];
    }
    return aDuplicate;
}

#pragma mark - NSCopyingProtocol

- (id)copyWithZone:(NSZone *)zone {
    return [self mutableCopyWithZone:zone];
}

#pragma mark - NSCodingProtocol

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];

    if (self) {
        return nil;
    }
    // Decoding the object
    self.ID = [aDecoder decodeIntegerForKey:@"id"];
    self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
    self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
    self.fullName = [aDecoder decodeObjectForKey:@"fullName"];
    self.emailAddress = [aDecoder decodeObjectForKey:@"emailAddress"];
    self.company = [aDecoder decodeObjectForKey:@"company"];
    self.jobTitle = [aDecoder decodeObjectForKey:@"jobTitle"];
    self.businesPhone = [aDecoder decodeObjectForKey:@"businesPhone"];
    self.homePhone = [aDecoder decodeObjectForKey:@"homePhone"];
    self.mobileNumber = [aDecoder decodeObjectForKey:@"mobileNumber"];
    self.faxNumber = [aDecoder decodeObjectForKey:@"faxNumber"];
    self.address = [aDecoder decodeObjectForKey:@"address"];
    self.city = [aDecoder decodeObjectForKey:@"city"];
    self.stateOrProvince = [aDecoder decodeObjectForKey:@"stateOrProvince"];
    self.zipOrPostalCode = [aDecoder decodeObjectForKey:@"zipOrPostalCode"];
    self.countryOrRegion = [aDecoder decodeObjectForKey:@"countryOrRegion"];
    self.webpageURL = [aDecoder decodeObjectForKey:@"webpageURL"];
    self.webpageDescription = [aDecoder decodeObjectForKey:@"webpageDescription"];
    self.notes = [aDecoder decodeObjectForKey:@"notes"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    // Encoding the object
    [aCoder encodeInteger:self.ID forKey:@"id"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.fullName forKey:@"fullName"];
    [aCoder encodeObject:self.emailAddress forKey:@"emailAddress"];
    [aCoder encodeObject:self.company forKey:@"company"];
    [aCoder encodeObject:self.jobTitle forKey:@"jobTitle"];
    [aCoder encodeObject:self.businesPhone forKey:@"businesPhone"];
    [aCoder encodeObject:self.homePhone forKey:@"homePhone"];
    [aCoder encodeObject:self.mobileNumber forKey:@"mobileNumber"];
    [aCoder encodeObject:self.faxNumber forKey:@"faxNumber"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.stateOrProvince forKey:@"stateOrProvince"];
    [aCoder encodeObject:self.zipOrPostalCode forKey:@"zipOrPostalCode"];
    [aCoder encodeObject:self.countryOrRegion forKey:@"countryOrRegion"];
    [aCoder encodeObject:self.webpageURL forKey:@"webpageURL"];
    [aCoder encodeObject:self.webpageDescription forKey:@"webpageDescription"];
    [aCoder encodeObject:self.notes forKey:@"notes"];

}

@end
