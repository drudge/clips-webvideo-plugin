//
//  FlickrImageGrabber.h
//  Test oembed
//
//  Created by Nicholas Penree on 9/27/08.
//  Copyright 2008 Conceited Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <NLKit/CSOEmbedGrabberDelegate.h>
#import <NLKit/CSOEmbedGrabber.h>

@interface WebVideoGrabber : CSOEmbedGrabber
{
}

@property (readonly) NSString *apiEndpointURL;

@end
