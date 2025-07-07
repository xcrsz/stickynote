//
//  SNNoteWindowController.h
//  stickynote
//
//  Individual sticky note window controller
//  Enhanced with better theme and text color support
//

#import <AppKit/AppKit.h>

@class SNColorTheme;

@interface SNNoteWindowController : NSWindowController

// Initialization
- (instancetype)init;
- (instancetype)initWithText:(NSString *)text;
- (instancetype)initWithText:(NSString *)text 
                    fontSize:(float)size 
             backgroundColor:(NSColor *)bg;

// Content access
- (NSString *)noteText;

// Font operations
- (void)increaseFontSize:(id)sender;
- (void)decreaseFontSize:(id)sender;
- (void)setFontSize:(float)fontSize;

// Appearance and theming
- (void)applyColorTheme:(SNColorTheme *)theme;
- (void)setBackgroundColor:(NSColor *)color;
- (SNColorTheme *)currentTheme;

// Menu validation
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem;

@end
