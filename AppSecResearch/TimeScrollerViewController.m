//
//  RootViewController.m
//  TimerScroller
//
//  Created by Andrew Carter on 12/4/11.

#import "TimeScrollerViewController.h"
#import "SpeachViewController.h"
#import "AbstractActionSheetPicker.h"
#import "ActionSheetStringPicker.h"
#import "AppDelegate.h"

#define CELL_WIDTH self.view.bounds.size.width
#define CELL_HEIGHT 100.0f
#define CELL_MARGIN 2.0f

@implementation TimeScrollerViewController

@synthesize data;
@synthesize actionSheetPicker = _actionSheetPicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.parentViewController revealToggle:nil];//show the menu on load
    
    self.title = @"Schedule";
    
    if (![self.navigationItem rightBarButtonItem]) {
        UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(showFilter:)];
        
        self.navigationItem.rightBarButtonItem = filterButton;
        [filterButton release];
    }
    
    selectedTrack = -1;
    [data addObjectsFromArray:appDelegate.speaches];
    
    
}
       
- (void)filterSelected:(NSString*) selected {
    NSLog(@"filterSelected=%@",selected);
    selectedTrack = -1;
    for (NSDictionary *d in appDelegate.tracks){
        if([[d objectForKey:@"name"] isEqualToString:selected]){
            selectedTrack = [[d objectForKey:@"id"] intValue];
        }
    }
    NSLog(@"filterSelected.id=%d",selectedTrack);
    [data removeAllObjects];
    //TODO: generalize
    if(selectedTrack==0){//My Track
        for (NSDictionary *s in appDelegate.speaches) {
            BOOL isBookmarked = ([s objectForKey:@"bookmark"] && [[s objectForKey:@"bookmark"] isEqualToString:@"YES"]);
            if ([[s objectForKey:@"track"] intValue]==0
                ||[[s objectForKey:@"track"] intValue]==1//Keynote
                ||isBookmarked ) {
                [data addObject:s];
            }
        }
    } else {        
        if (selectedTrack==-1) {
            [data addObjectsFromArray:appDelegate.speaches];
        } else {        
            for (NSDictionary *s in appDelegate.speaches) {
                if ([[s objectForKey:@"track"] intValue]==selectedTrack) {
                    [data addObject:s];
                }
            }
        }
    }
    [_tableView reloadData];
}
                                         
- (void)showFilter:(id)sender{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [self filterSelected:selectedValue];
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Picker Canceled");
    };
    
    NSMutableArray *tracks = [[NSMutableArray alloc] init];
    [tracks addObject:@"All"];
    for (NSDictionary *d in appDelegate.tracks)
        [tracks addObject:[d objectForKey:@"name"]];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Track" rows:tracks initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        _timeScroller = [[TimeScroller alloc] initWithDelegate:self];
        
        _tableView = [[UITableView alloc] initWithFrame:VIEW_FRAME style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
                
        data = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)dealloc {
    self.actionSheetPicker = nil;
    [data dealloc];
    [_tableView release];
    [_timeScroller release];
    [super dealloc];
}

- (void)loadView {
    
    UIView *view = [[UIView alloc] initWithFrame:VIEW_FRAME];
    
    [view addSubview:_tableView];
    
    self.view = view;
    [view release];
    
}

#pragma mark TimeScrollerDelegate Methods

- (UITableView *)tableViewForTimeScroller:(TimeScroller *)timeScroller {
    return _tableView;
}

- (NSDate *)dateForCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    NSDictionary *dictionary = [data objectAtIndex:indexPath.row];
    
    BOOL isBookmarked = ([dictionary objectForKey:@"bookmark"] && [[dictionary objectForKey:@"bookmark"] isEqualToString:@"YES"]);
    [_timeScroller isGreen:isBookmarked];
    
    NSDate *date = [dictionary objectForKey:@"start"];
    return date;
}

#pragma mark UIScrollViewDelegateMethods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_timeScroller scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_timeScroller scrollViewDidEndDecelerating];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [_timeScroller scrollViewDidEndDecelerating];
    }
}

#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([[[data objectAtIndex:indexPath.row] objectForKey:@"track"] intValue]==0) return;
    SpeachViewController *speach= [[SpeachViewController alloc] initWithNibName:@"SpeachViewController" bundle:nil];
    speach.dictionary = [data objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:speach animated:YES];
	[speach release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:CGRectMake(	0.0f,	0.0f,	CELL_WIDTH, CELL_HEIGHT)] autorelease];
    //Date
    UILabel *lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(CELL_MARGIN, CELL_MARGIN, CELL_WIDTH/3.0f-2.0f*CELL_MARGIN, CELL_HEIGHT/2.0f-2.0f*CELL_MARGIN)];
    lblTemp.tag = 1;
    lblTemp.textColor = [UIColor darkGrayColor];
    lblTemp.textAlignment = UITextAlignmentCenter;
    lblTemp.lineBreakMode = UILineBreakModeWordWrap;
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.numberOfLines = 2;
    [cell.contentView addSubview:lblTemp];
    [lblTemp release];
    //Time
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(CELL_MARGIN, CELL_HEIGHT/2.0f+CELL_MARGIN, CELL_WIDTH/3.0f-2.0f*CELL_MARGIN, CELL_HEIGHT/2.0f-2.0f*CELL_MARGIN)];
    lblTemp.tag = 2;
    lblTemp.textColor = [UIColor darkTextColor];
    lblTemp.textAlignment = UITextAlignmentCenter;
    lblTemp.lineBreakMode = UILineBreakModeWordWrap;
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.numberOfLines = 2;
    [cell.contentView addSubview:lblTemp];
    [lblTemp release];
    //Title
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(CELL_WIDTH/3.0f+CELL_MARGIN, CELL_MARGIN, 2.0f*CELL_WIDTH/3.0f-2.0f*CELL_MARGIN, CELL_HEIGHT/2.0f-2.0f*CELL_MARGIN)];
    lblTemp.tag = 3;
    lblTemp.textColor = [UIColor darkTextColor];
    lblTemp.textAlignment = UITextAlignmentLeft;
    lblTemp.lineBreakMode = UILineBreakModeWordWrap;
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.numberOfLines = 2;
    [cell.contentView addSubview:lblTemp];
    [lblTemp release];
    //Subtitle
    lblTemp = [[UILabel alloc] initWithFrame:CGRectMake(CELL_WIDTH/3.0f+CELL_MARGIN, CELL_HEIGHT/2.0f+CELL_MARGIN, 2.0f*CELL_WIDTH/3.0f-2.0f*CELL_MARGIN, CELL_HEIGHT/2.0f-2.0f*CELL_MARGIN)];
    lblTemp.tag = 4;
    lblTemp.textColor = [UIColor darkGrayColor];
    lblTemp.textAlignment = UITextAlignmentLeft;
    lblTemp.lineBreakMode = UILineBreakModeWordWrap;
    lblTemp.backgroundColor = [UIColor clearColor];
    lblTemp.numberOfLines = 2;
    [cell.contentView addSubview:lblTemp];
    [lblTemp release];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *identifier = @"TableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [self getCellContentView:identifier];
    }
    
    UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
    UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];
    UILabel *lblTemp3 = (UILabel *)[cell viewWithTag:3];
    UILabel *lblTemp4 = (UILabel *)[cell viewWithTag:4];
        
    NSDictionary *dictionary = [data objectAtIndex:indexPath.row];
        
    NSDate *start = [dictionary objectForKey:@"start"];
    NSDate *end = [dictionary objectForKey:@"end"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:TIMEZONE_ABBREVIATION]];
    [dateFormatter setDateFormat:@"EEEE"];
    lblTemp1.text = [NSString stringWithFormat:@"%@\n%@",[dateFormatter stringFromDate:start], [dictionary objectForKey:@"place"]];
    [dateFormatter setDateFormat:@"h:mm a"];
    lblTemp2.text = [NSString stringWithFormat:@"%@\n%@",[dateFormatter stringFromDate:start],[dateFormatter stringFromDate:end]];
    [dateFormatter release];
    
    lblTemp3.text = [dictionary objectForKey:@"title"];
    
    if([dictionary objectForKey:@"speakers"] && [[dictionary objectForKey:@"speakers"] count]>0)
        lblTemp4.text = [[dictionary objectForKey:@"speakers"] componentsJoinedByString:@", "];
    else
        lblTemp4.text = @"";
    
    switch ([[dictionary objectForKey:@"track"] intValue]) {
        case 4:
            cell.contentView.backgroundColor = UIColorFromRGB(0x3A89C9);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 3:
            cell.contentView.backgroundColor = UIColorFromRGB(0xE9F2F9);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 2:
            cell.contentView.backgroundColor = UIColorFromRGB(0x9CC4E4);
            lblTemp1.textColor = [UIColor darkGrayColor];
            lblTemp2.textColor = [UIColor darkTextColor];
            lblTemp3.textColor = [UIColor darkTextColor];
            lblTemp4.textColor = [UIColor darkGrayColor];
            break;
        case 1:
            cell.contentView.backgroundColor = UIColorFromRGB(0xF26C4F);
            lblTemp1.textColor = [UIColor lightTextColor];
            lblTemp2.textColor = [UIColor whiteColor];
            lblTemp3.textColor = [UIColor whiteColor];
            lblTemp4.textColor = [UIColor lightTextColor];
            break;
        default:
            cell.contentView.backgroundColor = UIColorFromRGB(0x1B325F);
            lblTemp1.textColor = [UIColor lightGrayColor];
            lblTemp2.textColor = [UIColor lightTextColor];
            lblTemp3.textColor = [UIColor lightTextColor];
            lblTemp4.textColor = [UIColor lightGrayColor];
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = cell.contentView.backgroundColor;
}

@end
