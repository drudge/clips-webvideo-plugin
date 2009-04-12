//
//  CAWebVideoPlugin.h
//  Clips YouTube Plug-in
//
//  Created by Nico on 6/6/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Clips Kit/Clips Kit.h>
#import <NLKit/CSOEmbedGrabberDelegate.h>

@interface CAWebVideoPlugin : NSObject <CAPluginProtocol, CSOEmbedGrabberDelegate>
{
	CAClip *currentClip;
	NSDictionary *infoDict;
	NSWindow *window;
}

@property (nonatomic, retain) CAClip *currentClip;
@property (retain) NSDictionary *infoDict;
@property (retain) NSWindow *window;

- (void)doWorkWithString:(NSString *)str;

@end
