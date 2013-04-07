//
//  EventMapViewController.m
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventMapViewController.h"
#import "MapAnnotation.h"
#import "ActionSheetStringPicker.h"
#import "MapOverlay.h"
#import "MapOverlayView.h"

@implementation EventMapViewController

@synthesize mapView;
@synthesize actionSheetPicker = _actionSheetPicker;

- (void) flyTo:(NSArray*)pointGroup{
    MKMapRect flyTo = MKMapRectNull;
	for (id <MKAnnotation> annotation in pointGroup) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo)) {
            flyTo = pointRect;
        } else {
            flyTo = MKMapRectUnion(flyTo, pointRect);
        }
    }    
    mapView.visibleMapRect = flyTo;
}

- (void)filterSelected:(NSString*) selected {
    NSLog(@"filterSelected=%@",selected);
    if([selected isEqualToString:@"DIT, University of Athens (Venue)"]){
        [self flyTo:groupDIT];
    } else if([selected isEqualToString:@"Transport"]){
        [self flyTo:groupTransport];
    } else if([selected isEqualToString:@"Ya Cafe (Social Event)"]){
        [self flyTo:groupYa];
    } else if([selected isEqualToString:@"Kostis Palamas (Social Event)"]){
        [self flyTo:groupPalamas];
    }
}


- (void)showFilter:(id)sender{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [self filterSelected:selectedValue];
    };
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker) {
        NSLog(@"Picker Canceled");
    };
    
    NSMutableArray *tracks = [[NSMutableArray alloc] init];
    [tracks addObject:@"DIT, University of Athens (Venue)"];
    [tracks addObject:@"Transport"];
    [tracks addObject:@"Ya Cafe (Social Event)"];
    [tracks addObject:@"Kostis Palamas (Social Event)"];
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select POI" rows:tracks initialSelection:0 doneBlock:done cancelBlock:cancel origin:sender];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.title = @"Map";
    
    if (![self.navigationItem rightBarButtonItem]) {
        UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(showFilter:)];
        
        self.navigationItem.rightBarButtonItem = filterButton;
        [filterButton release];
    }
    
    MapOverlay * mapOverlay = [[MapOverlay alloc] init];
    [mapView addOverlay:mapOverlay];
    [mapOverlay release];
	
	CLLocationCoordinate2D ditUoA;
    ditUoA.latitude = 37.96830;
    ditUoA.longitude = 23.76675;
	
	CLLocationCoordinate2D uoa250;
    uoa250.latitude = 37.96799;
    uoa250.longitude = 23.76617;
	
	CLLocationCoordinate2D kaisariani224;
    kaisariani224.latitude = 37.96717;
    kaisariani224.longitude = 23.76506;
	
	CLLocationCoordinate2D metroEvagelismos;
    metroEvagelismos.latitude = 37.97625;
    metroEvagelismos.longitude = 23.74708;
    
    CLLocationCoordinate2D evagelismos224;
    evagelismos224.latitude = 37.97646;
    evagelismos224.longitude = 23.74809;
    
    CLLocationCoordinate2D divaniCaravel;
    divaniCaravel.latitude = 37.973204;
    divaniCaravel.longitude = 23.751390;
    
    CLLocationCoordinate2D kostisPalamas;
    kostisPalamas.latitude = 37.980367;
    kostisPalamas.longitude = 23.735447;
    
    CLLocationCoordinate2D panepistimioStation;
    panepistimioStation.latitude = 37.980122;
    panepistimioStation.longitude = 23.733205;
    
    CLLocationCoordinate2D yaCafe;
    yaCafe.latitude = 37.986710;
    yaCafe.longitude = 23.774714;
    
    CLLocationCoordinate2D katechakiStation;
    katechakiStation.latitude = 37.992984;
    katechakiStation.longitude = 23.776088;
	
	MapAnnotation* anDIT=[[MapAnnotation alloc] init];
	anDIT.coordinate=ditUoA;
	anDIT.title=@"Department of Informatics and Telecommunications";
	anDIT.subtitle=@"University of Athens";
    anDIT.pinColor = MKPinAnnotationColorRed;
	
	MapAnnotation* anBusUoA=[[MapAnnotation alloc] init];
	anBusUoA.coordinate=uoa250;
	anBusUoA.title=@"Bus stop";
	anBusUoA.subtitle=@"Take 250 bus from here";
    anBusUoA.pinColor = MKPinAnnotationColorGreen;
	
	MapAnnotation* anBusKaisariani=[[MapAnnotation alloc] init];
	anBusKaisariani.coordinate=kaisariani224;
	anBusKaisariani.title=@"Bus stop";
	anBusKaisariani.subtitle=@"Take 224 bus or 01 minibus";
    anBusKaisariani.pinColor = MKPinAnnotationColorGreen;
	
	MapAnnotation* anBusEvangelismos=[[MapAnnotation alloc] init];
	anBusEvangelismos.coordinate=evagelismos224;
	anBusEvangelismos.title=@"Bus stop";
	anBusEvangelismos.subtitle=@"Take 224 bus, 250 bus or 01 minibus";
    anBusEvangelismos.pinColor = MKPinAnnotationColorGreen;
    
    MapAnnotation* anMetroEvangelismos=[[MapAnnotation alloc] init];
	anMetroEvangelismos.coordinate=metroEvagelismos;
	anMetroEvangelismos.title=@"Evangelismos";
	anMetroEvangelismos.subtitle=@"Metro station";
    anMetroEvangelismos.pinColor = MKPinAnnotationColorPurple;
    
    MapAnnotation* anDivaniCaravel=[[MapAnnotation alloc] init];
	anDivaniCaravel.coordinate=divaniCaravel;
	anDivaniCaravel.title=@"Divani Caravel";
	anDivaniCaravel.subtitle=@"Hotel";
    anDivaniCaravel.pinColor = MKPinAnnotationColorPurple;
    
    MapAnnotation* anMetroPanepistimio=[[MapAnnotation alloc] init];
	anMetroPanepistimio.coordinate=panepistimioStation;
	anMetroPanepistimio.title=@"Panepistimio";
	anMetroPanepistimio.subtitle=@"Metro station";
    anMetroPanepistimio.pinColor = MKPinAnnotationColorPurple;
    
    MapAnnotation* anKostisPalamas=[[MapAnnotation alloc] init];
	anKostisPalamas.coordinate=kostisPalamas;
	anKostisPalamas.title=@"Kostis Palamas";
	anKostisPalamas.subtitle=@"Social Event";
    anKostisPalamas.pinColor = MKPinAnnotationColorRed;
    
    MapAnnotation* anYaCafe=[[MapAnnotation alloc] init];
	anYaCafe.coordinate=yaCafe;
	anYaCafe.title=@"Ya Cafe";
	anYaCafe.subtitle=@"Social Event";
    anYaCafe.pinColor = MKPinAnnotationColorRed;
    
    MapAnnotation* anMetroKatechaki=[[MapAnnotation alloc] init];
	anMetroKatechaki.coordinate=katechakiStation;
	anMetroKatechaki.title=@"Katechaki";
	anMetroKatechaki.subtitle=@"Metro station";
    anMetroKatechaki.pinColor = MKPinAnnotationColorPurple;
	
	[mapView addAnnotation:anDIT];
	[mapView addAnnotation:anBusUoA];
	[mapView addAnnotation:anBusKaisariani];
	[mapView addAnnotation:anBusEvangelismos];
    [mapView addAnnotation:anMetroEvangelismos];
    [mapView addAnnotation:anDivaniCaravel];
    [mapView addAnnotation:anMetroPanepistimio];
    [mapView addAnnotation:anKostisPalamas];
    [mapView addAnnotation:anYaCafe];
    [mapView addAnnotation:anMetroKatechaki];
    
    groupYa=[[NSMutableArray alloc] init];
	[groupYa addObject:anYaCafe];
	[groupYa addObject:anMetroKatechaki];
    
    groupPalamas=[[NSMutableArray alloc] init];
	[groupPalamas addObject:anKostisPalamas];
	[groupPalamas addObject:anMetroPanepistimio];
    
    groupDIT=[[NSMutableArray alloc] init];
	[groupDIT addObject:anDIT];
    
    groupTransport=[[NSMutableArray alloc] init];
	[groupTransport addObject:anDIT];
	[groupTransport addObject:anBusUoA];
	[groupTransport addObject:anBusEvangelismos];
    [groupTransport addObject:anMetroEvangelismos];
	
    [self flyTo:groupDIT];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    if (annotation==self.mapView.userLocation)
        return nil;
    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myannotation"];
    newAnnotation.pinColor = ((MapAnnotation*)annotation).pinColor;
    newAnnotation.animatesDrop = YES;
    newAnnotation.canShowCallout = YES;
    return newAnnotation;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    MapOverlay *mapOverlay = overlay;
    MapOverlayView *mapOverlayView = [[[MapOverlayView alloc] initWithOverlay:mapOverlay] autorelease];
    
    return mapOverlayView;
    
}

- (void)dealloc {
    self.actionSheetPicker = nil;
    [super dealloc];
}

@end
