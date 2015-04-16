//
//  ContactFieldTableViewCell.m
//  office365Demo
//
//  Created by Vijay Subrahmanian on 07/04/15.
//  Copyright (c) 2015 Vijay Subrahmanian. All rights reserved.
//

#import "ContactFieldTableViewCell.h"

@interface ContactFieldTableViewCell() <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic) contactFieldCellStyle cellType;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;

@end


@implementation ContactFieldTableViewCell

- (id)initWithStyle:(contactFieldCellStyle)iStyle andReuseIdentifier:(NSString *)iReuseIdentifier {
    
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iReuseIdentifier];
    
    if (self) {
        self.cellType = iStyle;
        [self configureCell];
    }
    return self;
}

- (void)configureCell {
    CGRect aFieldFrame = CGRectMake(20.0f, 0.0f, self.contentView.bounds.size.width - 20.0f, self.contentView.bounds.size.height);
    // Setting appropriate fields for cells.
    switch (self.cellType) {
            
        case contactFieldCellTextField:
            self.textField = [[UITextField alloc] initWithFrame:aFieldFrame];
            self.textField.font = [UIFont systemFontOfSize:14.0f];
            self.textField.backgroundColor = [UIColor clearColor];
            self.textField.delegate = self;
            self.textField.text = self.fieldValue;
            [self.contentView addSubview:self.textField];
            break;

        case contactFieldCellTextView:
            self.textView = [[UITextView alloc] initWithFrame:aFieldFrame];
            self.textView.font = [UIFont systemFontOfSize:14.0f];
            self.textView.backgroundColor = [UIColor clearColor];
            self.textView.delegate = self;
            self.textView.text = self.fieldValue;
            [self.contentView addSubview:self.textView];
            break;
            
        default:
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    CGRect aFieldFrame = CGRectMake(20.0f, 0.0f, self.contentView.bounds.size.width - 20.0f, self.contentView.bounds.size.height);
    self.textView.frame = aFieldFrame;
    self.textField.frame = aFieldFrame;
}

- (void)setFieldPlaceHolderText:(NSString *)iFieldPlaceHolderText {
    
    if (self.textField) {
        self.textField.placeholder = iFieldPlaceHolderText;
    }
}

- (void)setFieldValue:(NSString *)iFieldValue {

    if (self.textField) {
        self.textField.text = iFieldValue;
    } else if (self.textView) {
        self.textView.text = iFieldValue;
    }
}

- (NSString *)fieldValue {
    return (self.textField.text.length) ? self.textField.text : (self.textView.text.length) ? self.textView.text : nil;
}


- (void)setEnableFieldEditing:(BOOL)iEnableFieldEditing {
    UIColor *bgColor = (iEnableFieldEditing) ? [UIColor whiteColor] : [UIColor colorWithWhite:0.95 alpha:1.0];
    self.backgroundColor = bgColor;
    self.textField.enabled = iEnableFieldEditing;
    self.textView.editable = iEnableFieldEditing;
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextView *)textView {

    if ([self.delegate respondsToSelector:@selector(fieldDidBeginEditingAtIndex:)]) {
        [self.delegate fieldDidBeginEditingAtIndex:self.fieldTableIndex];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updatedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([self.delegate respondsToSelector:@selector(fieldValueUpdated:forField:)]) {
        [self.delegate fieldValueUpdated:updatedText forField:self.fieldIdentifierKey];
    }
    return YES;
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([self.delegate respondsToSelector:@selector(fieldDidBeginEditingAtIndex:)]) {
        [self.delegate fieldDidBeginEditingAtIndex:self.fieldTableIndex];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *updatedText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    if ([self.delegate respondsToSelector:@selector(fieldValueUpdated:forField:)]) {
        [self.delegate fieldValueUpdated:updatedText forField:self.fieldIdentifierKey];
    }
    return YES;
}

@end
