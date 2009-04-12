//
//  CAYouTubePlugin.m
//  Clips YouTube Plug-in
//
//  Created by Nicholas Penree on 6/6/08.
//  Copyright 2008 Conceited Software. All rights reserved.
//

#import "CAWebVideoPlugin.h"
#import "WebVideoGrabber.h"
#import <WebKit/WebKit.h>

@implementation CAWebVideoPlugin

@synthesize currentClip, infoDict, window;

+ (CARelevance)relevanceForPivot:(CAPivot *)pivot
{
	CADatatype *dt = [pivot getDatatype:NSStringPboardType];

	if ([WebVideoGrabber hasExpectedPrefix:dt.string])
	{
		return CAVeryHighlyRelevant;
	}
	
	return CAIrrelevant;
}

+ (NSSet *)requiredTypes
{
	// We don't require any specific pasteboard types for our plugin to work
	return [NSSet setWithObject:NSStringPboardType];
}

- (void)copyClip:(CAClip *)clip
{
	self.currentClip = clip;

	CADatatype *dt = [clip.pivot getDatatype:NSStringPboardType];
	[self doWorkWithString:dt.string];
}

- (void)doWorkWithString:(NSString *)str
{
	WebVideoGrabber *grabber = [[WebVideoGrabber alloc] initWithString:str];
	
	grabber.delegate = self;
	
	[grabber grabData];	
}

- (void)pasteClip:(CAClip *)clip
{
	// Nothing to do here: default behavior when pasting a clip is to use the full range of pasteboards it generated in the first palce and let OS X handle it.
}

- (void)grabberDidGrabData:(NSDictionary *)data
{	
	self.infoDict = data;
		
	NSError *err = [infoDict objectForKey:@"error"];
	
	if (err != nil)
	{
		NSLog(@"-oembed error: %@", [err.userInfo objectForKey:@"NSLocalizedDescription"]);
		[self.currentClip validate:self];
	}
	else
	{
		self.currentClip.pivot.type = [NSNumber numberWithInt:CAWebVideoPivotType];
		
		//Let's set the name of our clip
		if ([infoDict objectForKey:@"title"])
		{
			self.currentClip.name = [infoDict objectForKey:@"title"];
		}
		
		//fail ok. i'm gonna Google how to use webview with youtube stuffz
		WebView *webView = [[WebView alloc] init]; //test		
		NSWindow *win = [[NSWindow alloc] initWithContentRect:NSZeroRect styleMask:0 backing:NSBackingStoreBuffered defer:NO]; // leaking so it wouldnt crash..
		[win setContentView:webView];
		self.window = win;
		[webView setFrameLoadDelegate:self];
		[[webView preferences] setPlugInsEnabled:YES];
		[[webView preferences] setJavaScriptEnabled:YES]; //?
		[webView release];
				
		NSString *tmpHtml = [NSString stringWithFormat:@"<html><head><style type\"text/css\">* { margin:0; padding:0; background-color:black;}</style></head><body>%@</body></html>", [infoDict objectForKey:@"html"]]; 
		[[webView mainFrame] loadHTMLString:tmpHtml baseURL:nil];
	}
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
	if (frame == [sender mainFrame])
	{		
		// Let's create an image object for our new clip

		// The Flash plugin loads asynchronously - we don't know when the video will be loaded :|... This is nasty.lol..
		
		[self performSelector:@selector(doStuff:) withObject:sender afterDelay:2.0]; //Wanna bet it doesn't work on Ollie's iBook G4?
	}
}

- (void)doStuff:(WebView *)webView
{
	[self performSelectorOnMainThread:@selector(doStuffOnMainThread:) withObject:webView waitUntilDone:YES];
}

- (void)doStuffOnMainThread:(WebView *)webView
{
	CAImageObject *imageObject = [self.currentClip imageObject];
	
	NSSize imgSize = NSMakeSize([[infoDict objectForKey:@"width"] floatValue], [[infoDict objectForKey:@"height"] floatValue]);
	NSRect rect = NSMakeRect(0, 0, imgSize.width, imgSize.height);
	[webView setFrame:rect];
	[[webView window] setFrame:rect display:YES];
	
	[webView lockFocus];
	NSBitmapImageRep *rep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:rect];
	[webView unlockFocus];
	
	NSImage *img = [[NSImage alloc] initWithSize:imgSize];
	[img addRepresentation:rep];
	
	//	NSString *path = @"/Users/drudge/Desktop/lol.tiff";
	//	[[img TIFFRepresentation] writeToFile:path atomically:NO];
	//	[[NSWorkspace sharedWorkspace] openFile:path];
	// The full-size image of the clip will be Clips' icon in our case
	imageObject.fullImage = img;
	
	// The thumbnail mode tells Clips how to compute the various thumbnails from the full image.
	// In our case, it'll be scaled.
	imageObject.thumbnailMode = [NSNumber numberWithShort:CAScaleThumbnailMode];
	
	// Is the image opaque? In our case, yes. If the value was NO, Clips would add an opaque background to the image whenever needed.
	imageObject.isOpaque = [NSNumber numberWithBool:YES];
	
	[rep release];
	[img release];
	
	// The name and image are all set up, there is nothing more for us to do: let's validate the clip.
	[self.currentClip validate:self];
}

- (void)dealloc
{
	self.window = nil;
	[super dealloc];
}

@end
