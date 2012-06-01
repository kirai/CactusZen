// Copyright 2011 Ping Labs, Inc. All rights reserved.

#import <UIKit/UIKit.h>

@interface ParseStarterProjectViewController : UIViewController {
    IBOutlet UIButton *button1;
    IBOutlet UILabel *label1;
    IBOutlet UITextField *textField1;
    
    IBOutlet UIButton *storeButton;
    IBOutlet UITextField *titleText;
    IBOutlet UITextField *descriptionText;
}

@property (nonatomic, retain) UIButton *button1;
@property (nonatomic, retain) UILabel *label1;
@property (nonatomic, retain) UITextField *textField1;

@property (nonatomic, retain) UIButton *storeButton;
@property (nonatomic, retain) UITextField *titleText;
@property (nonatomic, retain) UITextField *descriptionText;

-(IBAction)fetchData:(id)sender;
-(IBAction)storeData:(id)sender;

@end
