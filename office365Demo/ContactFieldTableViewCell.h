//
//  ContactFieldTableViewCell.h
//  office365Demo
//
//  Created by Vijay Subrahmanian on 07/04/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    contactFieldCellTextField,
    contactFieldCellTextView
} contactFieldCellStyle;

@protocol ContactFieldTableViewCellDelegate <NSObject>

- (void)fieldDidBeginEditingAtIndex:(NSIndexPath *)iIndexPath;

@required

- (void)fieldValueUpdated:(NSString *)iFieldValue forField:(NSString *)iFieldIdentifier;

@end

@interface ContactFieldTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL enableFieldEditing;
@property (nonatomic, strong) NSString *fieldValue;
@property (nonatomic, strong) NSIndexPath *fieldTableIndex;
@property (nonatomic, strong) NSString *fieldIdentifierKey;
@property (nonatomic, strong) NSString *fieldPlaceHolderText;
@property (nonatomic, weak) id<ContactFieldTableViewCellDelegate> delegate;

- (id)initWithStyle:(contactFieldCellStyle)iStyle andReuseIdentifier:(NSString *)iReuseIdentifier;

@end
