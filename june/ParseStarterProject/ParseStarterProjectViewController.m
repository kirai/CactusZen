// Copyright 2011 Ping Labs, Inc. All rights reserved.

#import "ParseStarterProjectViewController.h"
#import <Parse/Parse.h>

@implementation ParseStarterProjectViewController

@synthesize button1;
@synthesize label1;
@synthesize textField1;

@synthesize storeButton;
@synthesize titleText;
@synthesize descriptionText;

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

-(IBAction)fetchData:(id)sender 
{
    NSString *parseObjectId = [[NSString alloc] init];
    parseObjectId = textField1.text;
    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
    PFObject *parseObject = [query getObjectWithId:parseObjectId];
    NSString *title = [parseObject objectForKey:@"title"];
    NSString *description = [parseObject objectForKey:@"description"];
    NSString *result = [title stringByAppendingString:description];

    label1.text = result;
}

-(IBAction)storeData:(id)sender 
{
    NSString *title = [[NSString alloc] init];
    NSString *description = [[NSString alloc] init];

    title = titleText.text;
    description = descriptionText.text;
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:title forKey:@"title"];
    [testObject setObject:description forKey:@"description"];
    [testObject save];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
