//
//  AppDelegate.h
//  trollChat
//
//  Created by ドンデリス カルロス on 12/06/11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSMutableArray *_addressBook;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *addressBook;

#define UIAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@end
