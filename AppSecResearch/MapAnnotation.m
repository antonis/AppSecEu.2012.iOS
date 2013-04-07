//
//  MapAnnotation.m
//  AppSecResearch
//
//  Created by Antonios Lilis on 1/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize title;
@synthesize subtitle;
@synthesize description;
@synthesize coordinate;
@synthesize pinColor;

- (void)dealloc 
{
	[super dealloc];
	self.title = nil;
	self.subtitle = nil;
    self.description = nil;
}

@end
