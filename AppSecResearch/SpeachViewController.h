//
//  SpeachViewController.h
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface SpeachViewController : UIViewController {
    IBOutlet UILabel *header;
    IBOutlet UITextView *content;
    BOOL isBookmarked;
}

@property (nonatomic, retain) NSDictionary *dictionary;

- (IBAction)tweet:(id)sender;

@end
