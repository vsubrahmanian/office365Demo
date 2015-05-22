# office365Demo
Demo using for MS Office 365 iOS SDK for getting contacts

Office 365 SDK for iOS: https://github.com/OfficeDev/Office-365-SDK-for-iOS

This is a sample project to demo on Viewing, Creating, Editing and Deleting share point contacts using office365 iOS SDK.

Currently the version has helper classes for performing CRUD operations on 'Contacts' using the SDK.

More details here:
https://ayeohyes.wordpress.com/2015/04/12/sharepoint-integration-with-ios-application-contacts/


----------------------------------------
Project Implementation Details:
----------------------------------------
 In this project I have created a MSOContactHelper class that will handle the interaction with Office365 SDK for OAuth and OData fething. The formatiing of the request and parsing of the response for getting contacts from sharepoint server is also handled in this class.

 MSOContactInfoModel is a model created that will manage all the contact details. It has properties for each of the contact fields and corresponds to NSCopying and NSCoding protocols for copying or saving data to disk.
 
 The project uses a table view to display all the contacts as well as to create and edit contacts.
 
 All contacts: ContactListTableViewController
 Contact Details: ContactInfoTableViewController
 
 Each contact field is a ContactFieldTableViewCell
 
 The Cell created dynamically corresponding to the "contactRelation.plist" where the contact field display order as well as properties and types of each field is defined. Each field is identified by a name under contactFields dictionary. It contains the following properties.
 
 - identifier : This is the key in the Sharepoint contact db table
 - key : This is the name of the property used to identify the item in the model (MSOContactInfoModel)
 - type : this defines if the cell is a textField or textView (Currently the cell is configured to support only the below types)
 - title : this is the (to be localised) text for displaying the title on the cell
 - sectionTitle : this is the (to be localised) text for displaying the section title for the field.
 - placeholder : this is the placeholder text for textfields.
 - cellHeight : This is the cell height to be used for the field.
 
 The application uses splitView for iPad devices and navigation for iPhones/iPod touch devices. It uses auto layouts and should run without issues in all devices and all orientaitons.
 
 -- CocoaPods -- 
 If you have any trouble with CocoaPods, do check my blog here:
 https://ayeohyes.wordpress.com/2015/03/25/cocoapods-how-to/


This application is made available for free under Apache License version 2.0.
Check out the LICENSE document file for the "Terms of Use". 
---