//
//  SecondViewController.h
//  trollChat
//
//  Created by ドンデリス カルロス on 12/06/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController{
    IBOutlet UITextField *chatField;
    IBOutlet UIButton *trollButton;
    IBOutlet UITextView *chatView;
}
@property (nonatomic, retain) UITextField *chatField;
@property (nonatomic, retain) UIButton *trollButton;
@property (nonatomic, retain) UITextView *chatView;

- (IBAction)trollButtom:(id)sender;


@end
