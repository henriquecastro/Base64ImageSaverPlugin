//
//  Base64ImageSaverPlugin.m
//  Base64ImageSaverPlugin PhoneGap/Cordova plugin
//
//  Created by Tommy-Carlos Williams on 29/03/12.
//  Copyright (c) 2012 Tommy-Carlos Williams. All rights reserved.
//  MIT Licensed
//

#import "Base64ImageSaverPlugin.h"
#import <Cordova/CDV.h>

@implementation Base64ImageSaverPlugin
@synthesize callbackId;

//-(CDVPlugin*) initWithWebView:(UIWebView*)theWebView
//{
//    self = (Base64ImageSaverPlugin*)[super initWithWebView:theWebView];
//    return self;
//}

- (void)saveImageDataToLibrary:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
    NSData* imageData = [[NSData alloc] initWithBase64EncodedString:[command.arguments objectAtIndex:0] options:0];
    
    UIImage* image = [[[UIImage alloc] initWithData:imageData] autorelease];    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        NSLog(@"ERROR: %@",error);
        CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:error.description];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
    }
    else  // No errors
    {
        // Show message image successfully saved
        NSLog(@"IMAGE SAVED!");
        CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString:@"Image saved"];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
    }
}

- (void)dealloc
{   
    [callbackId release];
    [super dealloc];
}


@end