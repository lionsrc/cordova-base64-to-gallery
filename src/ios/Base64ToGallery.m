//
//  Base64ToGallery.m
//  Base64ToGallery PhoneGap/Cordova plugin
//
//  Created by Tommy-Carlos Williams on 29/03/12.
//  Copyright (c) 2012 Tommy-Carlos Williams. All rights reserved.
//	MIT Licensed
//

#import "Base64ToGallery.h"
#import <Cordova/CDV.h>

@implementation Base64ToGallery
@synthesize callbackId;

//-(CDVPlugin*) initWithWebView:(UIWebView*)theWebView
//{
//    self = (Base64ToGallery*)[super initWithWebView:theWebView];
//    return self;
//}


- (void) saveImageFromUrl:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
    NSString *url = [command.arguments objectAtIndex:0];
    
    UIImage *pic = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    UIImageWriteToSavedPhotosAlbum(pic, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)saveImageDataToLibrary:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
//	NSData* imageData = [NSData dataFromBase64String:[command.arguments objectAtIndex:0]];
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:[command.arguments objectAtIndex:0] options:NSDataBase64DecodingIgnoreUnknownCharacters];

    UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];

    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    CDVPluginResult* result = nil;

    // Was there an error?
    if (error != NULL) {
        NSLog(@"ERROR: %@", error);

        result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:error.description];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];

//		[self.webView stringByEvaluatingJavaScriptFromString:[result toErrorCallbackString: self.callbackId]];

    // No errors
    } else {

		result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];

//        [self.webView stringByEvaluatingJavaScriptFromString:[result toSuccessCallbackString: self.callbackId]];
    }
}

- (void)dealloc
{
	[callbackId release];
    [super dealloc];
}

@end
