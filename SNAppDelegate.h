//
//  SNAppDelegate.h
//  stickynote
//
//  Application lifecycle management and coordination
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "SNMenuManager.h"

@class SNNoteManager;
@class SNPreferences;
@class SNPreferencesWindowController;

@interface SNAppDelegate : NSObject <NSApplicationDelegate, SNMenuManagerDelegate>

// Core application components
@property (readonly) SNNoteManager *noteManager;
@property (readonly) SNPreferences *preferences;
@property (readonly) SNPreferencesWindowController *preferencesController;
@property (readonly) SNMenuManager *menuManager;

// About dialog
- (void)showAboutDialog:(id)sender;

@end
