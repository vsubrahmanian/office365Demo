//
//  ContactInfoTableViewController.h
//  office365Demo
//
//  Created by Vijay Subrahmanian on 07/04/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSOContactInfoModel.h"

@protocol ContactInfoTableViewDelegate <NSObject>

- (void)newContactAdded:(MSOContactInfoModel *)iContactInfo;
- (void)contactDeleted:(MSOContactInfoModel *)iContactInfo;

@end

@interface ContactInfoTableViewController : UITableViewController

@property (nonatomic, weak) id <ContactInfoTableViewDelegate> delegate;
@property (nonatomic, strong) MSOContactInfoModel *contactInfo;

@end
