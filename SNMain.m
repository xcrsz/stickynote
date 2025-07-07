//
//  SNMain.m
//  stickynote
//
//  A GNUstep Sticky Notes Application
//  Clean, professional application entry point
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "SNAppDelegate.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Initialize the application
        NSApplication *app = [NSApplication sharedApplication];
        
        // Create and set the application delegate
        SNAppDelegate *delegate = [[SNAppDelegate alloc] init];
        [app setDelegate:delegate];
        
        // Configure application behavior for GNUstep
        // Note: setActivationPolicy is macOS-specific, not needed for GNUstep
        
        // Start the main event loop
        return NSApplicationMain(argc, argv);
    }
}
