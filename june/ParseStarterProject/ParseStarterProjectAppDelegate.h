// Copyright 2011 Ping Labs, Inc. All rights reserved.

#import <UIKit/UIKit.h>

@class ParseStarterProjectViewController;

@interface ParseStarterProjectAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet ParseStarterProjectViewController *viewController;

- (void)subscribeFinished:(NSNumber *)result error:(NSError *)error;

@end
