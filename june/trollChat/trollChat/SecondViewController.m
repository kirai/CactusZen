//
//  SecondViewController.m
//  trollChat
//
//  Created by ドンデリス カルロス on 12/06/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SecondViewController.h"
#import "Parse/Parse.h"

@implementation SecondViewController

@synthesize chatField;
@synthesize trollButton;
@synthesize chatView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(someTimer) userInfo:nil repeats:YES];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)trollButtom:(id)sender {
    NSString *message = [[NSString alloc] init];
    
    message = chatField.text;
    NSLog(@"%@", chatView.text);    
    
    [self sendChatMessage:message];
}

- (void)sendChatMessage:(NSString *) message {
    
    PFObject *testObject = [PFObject objectWithClassName:@"chat"];
    [testObject setObject:message forKey:@"troll"];
    [testObject save];
}

- (void)someTimer
{
    NSLog(@"Hi");
    
    PFQuery *query = [PFQuery queryWithClassName:@"chat"];
    //    PFObject *gameScore = [query getObjectWithId:@"RM0yqE3eS0"];
    //    NSLog(@"%@", [gameScore objectForKey:@"troll"]);
    
    NSArray *objects = [query findObjects];
    chatView.text = @"";
    [objects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //        NSString *chat = [gameScore objectForKey:@"troll"];        
        chatView.text = [NSString stringWithFormat:@"%@\n%@", chatView.text, [obj objectForKey:@"troll"]];
        
    }];
}
@end
