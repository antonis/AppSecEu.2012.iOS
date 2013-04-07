//
//  SpeachViewController.m
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpeachViewController.h"

@implementation SpeachViewController

@synthesize dictionary;

- (IBAction)tweet:(id)sender {
    
    NSString *tweet;
    if([dictionary objectForKey:@"speakers"] && [[dictionary objectForKey:@"speakers"] count]>0){
        tweet = [NSString stringWithFormat:@"I'm attending %@ at #appseceu with %@",[dictionary objectForKey:@"title"], [[dictionary objectForKey:@"speakers"] componentsJoinedByString:@", "]];
        if([tweet length]>120)
            tweet = [NSString stringWithFormat:@"I'm attending %@ at #appseceu", [dictionary objectForKey:@"title"]];
    } else {
        tweet = [NSString stringWithFormat:@"I'm attending %@ at #appseceu", [dictionary objectForKey:@"title"]];
    }
    
    if([tweet length]>120)
        tweet = [tweet substringToIndex:119];
    
    tweet = [tweet stringByAppendingString:@" appsecresearch.org"];
    NSLog(@"tweet=%@",tweet);
    
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    
    [twitter setInitialText:tweet];
    
    [self presentViewController:twitter animated:YES completion:nil];
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult res) {
        
        [self dismissModalViewControllerAnimated:YES];
        
    };
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [dictionary objectForKey:@"title"];

    if([dictionary objectForKey:@"speakers"] && [[dictionary objectForKey:@"speakers"] count]>0)
        header.text = [NSString stringWithFormat:@"%@ - %@",[dictionary objectForKey:@"title"], [[dictionary objectForKey:@"speakers"] componentsJoinedByString:@", "]];
    else
        header.text = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"title"]];
    
    content.text = [dictionary objectForKey:@"description"];
    
    isBookmarked = ([dictionary objectForKey:@"bookmark"] && [[dictionary objectForKey:@"bookmark"] isEqualToString:@"YES"]);
    
    if([[dictionary objectForKey:@"track"] intValue]!=1){//not keynote
        UIBarButtonItem *bookmarkButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(isBookmarked?UIBarButtonSystemItemTrash:UIBarButtonSystemItemAdd) target:self action:@selector(bookmark:)];
        self.navigationItem.rightBarButtonItem = bookmarkButton;
        [bookmarkButton release];
    }
}

- (void)bookmark:(id)sender{
    isBookmarked = !isBookmarked;
    [dictionary setValue:isBookmarked?@"YES":@"NO" forKey:@"bookmark"];
    UIBarButtonItem *bookmarkButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(isBookmarked?UIBarButtonSystemItemTrash:UIBarButtonSystemItemAdd) target:self action:@selector(bookmark:)];
    self.navigationItem.rightBarButtonItem = bookmarkButton;
    [bookmarkButton release];
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
