//
//  SNPreferencesWindowController.h
//  stickynote
//
//  Preferences window user interface controller
//

#import <AppKit/AppKit.h>

@class SNPreferences;

@interface SNPreferencesWindowController : NSWindowController

- (instancetype)initWithPreferences:(SNPreferences *)preferences;
- (void)showWindow:(id)sender;

@end
