// Copyright 2011 Ping Labs, Inc. All rights reserved.

#import <UIKit/UIKit.h>

@interface ParseStarterProjectViewController : UIViewController {
    IBOutlet UIButton *button1;
    IBOutlet UILabel *label1;
    IBOutlet UITextField *textField1;
}

@property (nonatomic, retain) UIButton *button1;
@property (nonatomic, retain) UILabel *label1;
@property (nonatomic, retain) UITextField *textField1;

-(IBAction)fetchData:(id)sender;

@end
