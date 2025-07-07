//
//  SNAppDelegate.m
//  stickynote
//
//  Application lifecycle management and coordination
//

#import "SNAppDelegate.h"
#import "SNNoteManager.h"
#import "SNPreferences.h"
#import "SNPreferencesWindowController.h"
#import "SNMenuManager.h"
#import "SNConstants.h"

@implementation SNAppDelegate

#pragma mark - Application Lifecycle

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    [self initializePreferences];
    [self initializeNoteManager];
    [self initializePreferencesController];
    [self initializeMenuSystem];
    [self restoreApplicationState];
    
    // Ensure at least one note exists
    if (![_noteManager hasNotes]) {
        [_noteManager createNewNote];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    // Don't quit when all windows are closed - sticky notes app should stay running
    return NO;
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    [self saveApplicationState];
    return NSTerminateNow;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    [self performFinalCleanup];
}

#pragma mark - Initialization

- (void)initializePreferences {
    _preferences = [[SNPreferences sharedPreferences] retain];
    [_preferences loadDefaults];
}

- (void)initializeNoteManager {
    _noteManager = [[SNNoteManager alloc] initWithPreferences:_preferences];
}

- (void)initializePreferencesController {
    _preferencesController = [[SNPreferencesWindowController alloc] 
                             initWithPreferences:_preferences];
}

- (void)initializeMenuSystem {
    _menuManager = [[SNMenuManager alloc] initWithDelegate:self];
    [_menuManager setupApplicationMenu];
}

- (void)restoreApplicationState {
    [_noteManager restoreNotesFromDisk];
}

#pragma mark - Application State Management

- (void)saveApplicationState {
    [_noteManager saveAllNotes];
    [_preferences saveDefaults];
}

- (void)performFinalCleanup {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_noteManager disableAutoSave];
}

#pragma mark - SNMenuManagerDelegate Methods

- (void)createNewNote:(id)sender {
    [_noteManager createNewNote];
}

- (void)showPreferences:(id)sender {
    [_preferencesController showWindow:sender];
}

- (void)increaseFontSize:(id)sender {
    [_noteManager increaseFontSizeForAllNotes];
}

- (void)decreaseFontSize:(id)sender {
    [_noteManager decreaseFontSizeForAllNotes];
}

- (void)showAboutDialog:(id)sender {
    NSAlert *aboutAlert = [[NSAlert alloc] init];
    
    // Main message
    [aboutAlert setMessageText:[NSString stringWithFormat:@"%@ %@", 
                               SNApplicationName, SNApplicationVersion]];
    
    // Detailed information
    NSString *aboutText = [NSString stringWithFormat:
        @"A professional sticky notes application for GNUstep\n\n"
        @"Author: Vic Thacker\n"
        @"Version: %@\n"
        @"License: BSD 3-Clause License\n\n"
        @"Features:\n"
        @"• Six beautiful color themes including dark mode\n"
        @"• Auto-save functionality\n"
        @"• Rich text formatting support\n"
        @"• Professional user interface\n"
        @"• Floating note windows\n\n"
        @"Built for GNUstep environments with modern design principles.",
        SNApplicationVersion];
    
    [aboutAlert setInformativeText:aboutText];
    [aboutAlert addButtonWithTitle:@"OK"];
    
    // Set alert style
    [aboutAlert setAlertStyle:NSInformationalAlertStyle];
    
    // Run the dialog
    [aboutAlert runModal];
    [aboutAlert release];
}

#pragma mark - Memory Management

- (void)dealloc {
    [_noteManager release];
    [_preferences release];
    [_preferencesController release];
    [_menuManager release];
    [super dealloc];
}

@end
