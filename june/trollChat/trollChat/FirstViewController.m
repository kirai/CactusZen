//
//  FirstViewController.m
//  trollChat
//
//  Created by ドンデリス カルロス on 12/06/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    ABAddressBookRef book = ABAddressBookCreate();
	
    // Count of Addressbook
    //CFIndex cnt = ABAddressBookGetPersonCount(book);	
	
    //AllRecords of Addressbook
    CFArrayRef records = ABAddressBookCopyArrayOfAllPeople(book);
    for (int i = 0; i < CFArrayGetCount(records); i++) {
        ABRecordRef person = CFArrayGetValueAtIndex(records, i);	
		
        CFDateRef cfdate = ABRecordCopyValue(person, kABPersonModificationDateProperty);
        
        // 名前関係	
          NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *name = [NSString stringWithFormat:@"%@", firstName];

        // メモ		
        NSString *memo = (__bridge NSString *)ABRecordCopyValue(person, kABPersonNoteProperty);
		
        NSString *tel1, *tel2;
        // 電話番号
        ABMultiValueRef tels = ABRecordCopyValue(person, kABPersonPhoneProperty);
        if (ABMultiValueGetCount(tels) > 0) {
            tel1 = (__bridge NSString *)ABMultiValueCopyValueAtIndex(tels, 0);
            // Tel2
            if (ABMultiValueGetCount(tels) > 1) {
                tel2 = (__bridge NSString *)ABMultiValueCopyValueAtIndex(tels, 1);
            }
        }
		
        // E-mail
        ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
        NSString *email;
        if (ABMultiValueGetCount(emails) > 0) {
            email = (__bridge NSString *)ABMultiValueCopyValueAtIndex(emails, 0);
        }
        
        [UIAppDelegate.addressBook addObject:name];
    }
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [UIAppDelegate.addressBook count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }

    NSString *name = [UIAppDelegate.addressBook objectAtIndex:indexPath.row];
    
    cell.textLabel.text = name;
    
    return cell;
}

@end
