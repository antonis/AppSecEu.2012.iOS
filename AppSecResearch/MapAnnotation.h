//
//  MapAnnotation.h
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject<MKAnnotation> {
	
	CLLocationCoordinate2D	coordinate;
	NSString*				title;
	NSString*				subtitle;
    NSString*               description;
    MKPinAnnotationColor    pinColor;
}

@property (nonatomic, assign)	CLLocationCoordinate2D	coordinate;
@property (nonatomic, copy)		NSString*				title;
@property (nonatomic, copy)		NSString*				subtitle;
@property (nonatomic, copy)		NSString*				description;
@property (nonatomic, assign)	MKPinAnnotationColor    pinColor;

@end