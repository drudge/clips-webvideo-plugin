//
//  WebVideoGrabber.m
//  Clips YouTube Plug-in
//
//  Created by Nicholas Penree on 9/27/08.
//  Copyright 2008 Conceited Software. All rights reserved.
//

#import "WebVideoGrabber.h"

@implementation WebVideoGrabber

@synthesize apiEndpointURL;

+ (BOOL) hasExpectedPrefix:(NSString *)anURL
{
	NSString *someURL = [anURL lowercaseString];
	
	BOOL hasPrefix = ([someURL hasPrefix:@"http://www.youtube.com/watch"] ||
					  [someURL hasPrefix:@"http://youtube.com/watch"] || 
					  [someURL hasPrefix:@"http://www.vimeo.com/"] ||
					  [someURL hasPrefix:@"http://vimeo.com/"] || 
					  [someURL hasPrefix:@"http://collegehumor.com/video"] ||
					  [someURL hasPrefix:@"http://www.collegehumor.com/video"] || 
					  [someURL hasPrefix:@"http://revision3.com/"] ||
					  [someURL hasPrefix:@"http://www.revision3.com/"] ||
					  [someURL hasPrefix:@"http://funnyordie.com/videos/"] ||
					  [someURL hasPrefix:@"http://www.funnyordie.com/videos/"] ||
					  [someURL hasPrefix:@"http://video.google.com/videoplay?"] ||
					  [someURL hasPrefix:@"http://www.hulu.com/watch/"] ||
					  [someURL hasPrefix:@"http://metacafe.com/watch/"] ||
					  [someURL hasPrefix:@"http://www.metacafe.com/watch/"] ||
					  [someURL hasPrefix:@"http://slideshare.net/"] ||
					  [someURL hasPrefix:@"http://www.slideshare.net/"] ||
					  [someURL hasPrefix:@"http://viddler.com/explore/"] ||
					  [someURL hasPrefix:@"http://www.viddler.com/explore/"] ||
					  [someURL hasPrefix:@"http://qik.com/"] ||
					  [someURL hasPrefix:@"http://www.qik.com/"]);
	
	return hasPrefix;
}


- (NSString *)apiEndpointURL
{
	return @"http://oohembed.com/oohembed/";
}

@end
