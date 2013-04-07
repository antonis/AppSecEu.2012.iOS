//
//  MenuView.m
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "UIImage+OverlayColor.h"
#import "MenuTableViewCell.h"
#import "NewsViewController.h"
#import "EventMapViewController.h"
#import "InfoWebViewController.h"
#import "SpeakersViewController.h"
#import "ZBarReaderViewController.h"

#include <QuartzCore/QuartzCore.h>

#define kCellText @"CellText"
#define kCellImage @"CellImage"

@interface MenuViewController()

@property (nonatomic, strong) UITableView *menuTable;
@property (nonatomic, strong) NSArray *cellContents;
@property (retain, nonatomic) NewsViewController *news;
@property (retain, nonatomic) SpeakersViewController *speakers;
@property (retain, nonatomic) EventMapViewController *map;

@end

@implementation MenuViewController

@synthesize menuTable = menuTable_;
@synthesize cellContents = cellContents_;
@synthesize news = _news;
@synthesize map = _map;
@synthesize speakers = _speakers;

#pragma mark - Actions

#pragma mark - View lifecycle

- (void) qrcodeButton {
    NSLog(@"qrcodeButton");
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    
    [reader dismissModalViewControllerAnimated: YES];
    
    NSString *urlString = symbol.data;
    NSLog(@"qrcodeButton.urlString=%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (void) owaspLink {
    NSURL *url = [NSURL URLWithString:@"http://www.appsecresearch.org/"];
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);//fixes bug adding gap at the top
            
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    NSMutableArray *contents = [[NSMutableArray alloc] init];
    [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-program"], kCellImage, @"Schedule", kCellText, nil]];
    [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-news"], kCellImage, @"News", kCellText, nil]];
    //[contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-people"], kCellImage, @"Speakers", kCellText, nil]];
    [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-training"], kCellImage, @"Training", kCellText, nil]];
    [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-social"], kCellImage, @"Social Events", kCellText, nil]];
    [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-map"], kCellImage, @"Map", kCellText, nil]];
    [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-transport"], kCellImage, @"Transport", kCellText, nil]];
    [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-travel"], kCellImage, @"Travel", kCellText, nil]];
    [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-sponsors"], kCellImage, @"Sponsors", kCellText, nil]];
    [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-info"], kCellImage, @"Info", kCellText, nil]];
    [contents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[UIImage invertImageNamed:@"m-about"], kCellImage, @"About", kCellText, nil]];
    self.cellContents = contents;
    
    UIButton *footerLogo = [UIButton buttonWithType:UIButtonTypeCustom];
    [footerLogo setFrame:CGRectMake(100.0f,SCREEN_HEIGHT-80.0f, 57.0f, 57.0f)];
    [footerLogo setImage:[UIImage imageNamed:@"MenuIcon.png"] forState:UIControlStateNormal];
    [footerLogo addTarget:self action:@selector(owaspLink) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footerLogo];
    
    UIButton *qrcodeLogo = [UIButton buttonWithType:UIButtonTypeCustom];
    [qrcodeLogo setFrame:CGRectMake(0.0f,SCREEN_HEIGHT-80.0f, 57.0f, 57.0f)];
    [qrcodeLogo setImage:[UIImage imageNamed:@"qrcode.png"] forState:UIControlStateNormal];
    [qrcodeLogo addTarget:self action:@selector(qrcodeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qrcodeLogo];
    
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_WIDTH, SCREEN_HEIGHT-90) style:UITableViewStylePlain];
    self.menuTable = tableView;
    
    self.menuTable.backgroundColor = [UIColor clearColor];
    self.menuTable.delegate = self;
    self.menuTable.dataSource = self;
    [self.view addSubview:self.menuTable];
    [self.menuTable reloadData];
            
    _news = [[NewsViewController alloc] init];
    _speakers = [[SpeakersViewController alloc] init];
    _map = [[EventMapViewController alloc] initWithNibName:@"EventMapViewController" bundle:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cellContents_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	cell.textLabel.text = [[cellContents_ objectAtIndex:indexPath.row] objectForKey:kCellText];
	cell.imageView.image = [[cellContents_ objectAtIndex:indexPath.row] objectForKey:kCellImage];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0;
}

InfoWebViewController *credits;
InfoWebViewController *transport;
InfoWebViewController *info;
InfoWebViewController *sponsors;
InfoWebViewController *social;
InfoWebViewController *training;
InfoWebViewController *travel;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {  
    
    if(!credits){
        credits = [[InfoWebViewController alloc] init];
        credits.pageTitle = @"About";
        credits.filePath = [[NSBundle mainBundle] pathForResource:@"licenses" ofType:@"txt"];
    }
    if(!transport){
        transport = [[InfoWebViewController alloc] init];
        transport.pageTitle = @"Transport";
        transport.filePath = [[NSBundle mainBundle] pathForResource:@"transport" ofType:@"html"];
    }
    if(!info){
        info = [[InfoWebViewController alloc] init];
        info.pageTitle = @"Info";
        info.filePath = [[NSBundle mainBundle] pathForResource:@"info" ofType:@"html"];
    }
    if(!sponsors){
        sponsors = [[InfoWebViewController alloc] init];
        sponsors.pageTitle = @"Sponsors";
        sponsors.filePath = [[NSBundle mainBundle] pathForResource:@"sponsors" ofType:@"html"];
    }
    if(!training){
        training = [[InfoWebViewController alloc] init];
        training.pageTitle = @"Training";
        training.filePath = [[NSBundle mainBundle] pathForResource:@"training" ofType:@"html"];
    }
    if(!social){
        social = [[InfoWebViewController alloc] init];
        social.pageTitle = @"Social";
        social.filePath = [[NSBundle mainBundle] pathForResource:@"social" ofType:@"html"];
    }
    if(!travel){
        travel = [[InfoWebViewController alloc] init];
        travel.pageTitle = @"Travel";
        travel.filePath = [[NSBundle mainBundle] pathForResource:@"travel" ofType:@"html"];
    }
    
    switch (indexPath.row)
    {
        case 0://Schedule
            [appDelegate setDefaultFrontViewController];
            break;
        case 1://News
            [appDelegate setFrontViewController:_news];
            break;
//        case 2://Speakers
//            [appDelegate setFrontViewController:_speakers];
//            break;
        case 2://Training
            [appDelegate setFrontViewController:training];
            break;
        case 3://Social
            [appDelegate setFrontViewController:social];
            break;
        case 4://Map
            [appDelegate setFrontViewController:_map];
            break;
        case 5://Transport
            [appDelegate setFrontViewController:transport];
            break;
        case 6://Travel
            [appDelegate setFrontViewController:travel];
            break;
        case 7://Sponsors
            [appDelegate setFrontViewController:sponsors];
            break;
        case 8://Info
            [appDelegate setFrontViewController:info];
            break;
        default:
            [appDelegate setFrontViewController:credits];
            break;
    }
}

@end
