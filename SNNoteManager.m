//
//  SNNoteManager.m
//  stickynote
//
//  Sticky note collection lifecycle management
//  Enhanced with better theme and text color support
//

#import "SNNoteManager.h"
#import "SNNoteWindowController.h"
#import "SNPreferences.h"
#import "SNColorTheme.h"
#import "SNConstants.h"

@interface SNNoteManager ()
@property (retain) NSMutableArray<SNNoteWindowController *> *notes;
@property (retain) SNPreferences *preferences;
@property (retain) NSTimer *autoSaveTimer;
@property (assign) BOOL hasShownColorChangeMessage;
@end

@implementation SNNoteManager

- (instancetype)initWithPreferences:(SNPreferences *)preferences {
    self = [super init];
    if (self) {
        _notes = [[NSMutableArray alloc] init];
        _preferences = [preferences retain];
        _hasShownColorChangeMessage = NO;
        
        // Listen for preference changes
        [[NSNotificationCenter defaultCenter] 
            addObserver:self 
               selector:@selector(preferencesDidChange:)
                   name:SNPreferencesDidChangeNotification 
                 object:_preferences];
        
        // Listen for note close notifications
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(noteWillClose:)
                   name:SNNoteWillCloseNotification
                 object:nil];
        
        [self setupAutoSaveTimer];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self disableAutoSave];
    [_notes release];
    [_preferences release];
    [super dealloc];
}

#pragma mark - Note Lifecycle

- (void)createNewNote {
    [self createNewNoteWithText:@""];
}

- (void)createNewNoteWithText:(NSString *)text {
    SNColorTheme *currentTheme = _preferences.defaultColorTheme;
    
    SNNoteWindowController *controller = [[SNNoteWindowController alloc]
        initWithText:text
            fontSize:_preferences.defaultFontSize
     backgroundColor:currentTheme.backgroundColor];
    
    // Apply the complete theme (including text color) after creation
    [controller applyColorTheme:currentTheme];
    
    [_notes addObject:controller];
    [controller showWindow:nil];
    [controller release]; // The array retains it
    
    // Position the window slightly offset from others
    [self positionNewNote:controller];
    
    // Auto-save if enabled
    if (_preferences.autoSaveEnabled) {
        [self performSelector:@selector(saveAllNotes) 
                   withObject:nil 
                   afterDelay:1.0];
    }
}

- (void)removeNote:(SNNoteWindowController *)note {
    if ([_notes containsObject:note]) {
        [[note window] close];
        [_notes removeObject:note];
        
        // Auto-save if enabled
        if (_preferences.autoSaveEnabled) {
            [self performSelector:@selector(saveAllNotes) 
                       withObject:nil 
                       afterDelay:1.0];
        }
    }
}

- (void)positionNewNote:(SNNoteWindowController *)note {
    // Position new notes in a cascade pattern
    NSUInteger noteIndex = [_notes indexOfObject:note];
    if (noteIndex != NSNotFound) {
        CGFloat offset = (noteIndex % 10) * 25.0; // Cascade up to 10 notes
        NSPoint origin = NSMakePoint(200 + offset, 400 - offset);
        [[note window] setFrameOrigin:origin];
    }
}

#pragma mark - Collection Info

- (BOOL)hasNotes {
    return [_notes count] > 0;
}

- (NSUInteger)noteCount {
    return [_notes count];
}

- (NSArray<SNNoteWindowController *> *)allNotes {
    return [[_notes copy] autorelease];
}

#pragma mark - Persistence

- (void)saveAllNotes {
    NSString *saveDir = [SNSaveDirectory stringByExpandingTildeInPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Create directory if it doesn't exist
    NSError *error = nil;
    if (![fileManager fileExistsAtPath:saveDir]) {
        if (![fileManager createDirectoryAtPath:saveDir
                    withIntermediateDirectories:YES
                                     attributes:nil
                                          error:&error]) {
            NSLog(@"Failed to create save directory: %@", error.localizedDescription);
            return;
        }
    }
    
    // Remove old note files
    NSArray *existingFiles = [fileManager contentsOfDirectoryAtPath:saveDir error:nil];
    for (NSString *file in existingFiles) {
        if ([file hasPrefix:SNNoteFilePrefix] && [file hasSuffix:SNNoteFileExtension]) {
            NSString *filePath = [saveDir stringByAppendingPathComponent:file];
            [fileManager removeItemAtPath:filePath error:nil];
        }
    }
    
    // Save current notes
    for (NSUInteger i = 0; i < _notes.count; i++) {
        SNNoteWindowController *note = _notes[i];
        NSString *text = [note noteText];
        NSString *filename = [NSString stringWithFormat:@"%@%03lu%@", 
                             SNNoteFilePrefix, (unsigned long)i, SNNoteFileExtension];
        NSString *filePath = [saveDir stringByAppendingPathComponent:filename];
        
        if (![text writeToFile:filePath 
                    atomically:YES 
                      encoding:NSUTF8StringEncoding 
                         error:&error]) {
            NSLog(@"Failed to save note %lu: %@", (unsigned long)i, error.localizedDescription);
        }
    }
    
    NSLog(@"Saved %lu sticky notes to %@", (unsigned long)_notes.count, saveDir);
}

- (void)restoreNotesFromDisk {
    NSString *saveDir = [SNSaveDirectory stringByExpandingTildeInPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:saveDir]) {
        return; // No saved notes
    }
    
    NSError *error = nil;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:saveDir error:&error];
    if (!files) {
        NSLog(@"Failed to read save directory: %@", error.localizedDescription);
        return;
    }
    
    // Filter and sort note files
    NSString *notePattern = [SNNoteFilePrefix stringByAppendingString:@"*"];
    notePattern = [notePattern stringByAppendingString:SNNoteFileExtension];
    NSPredicate *notePredicate = [NSPredicate predicateWithFormat:
                                 @"SELF LIKE %@", notePattern];
    NSArray *noteFiles = [files filteredArrayUsingPredicate:notePredicate];
    NSArray *sortedFiles = [noteFiles sortedArrayUsingSelector:@selector(compare:)];
    
    for (NSString *file in sortedFiles) {
        NSString *filePath = [saveDir stringByAppendingPathComponent:file];
        NSString *text = [NSString stringWithContentsOfFile:filePath 
                                                    encoding:NSUTF8StringEncoding 
                                                       error:&error];
        if (text) {
            [self createNewNoteWithText:text];
        } else {
            NSLog(@"Failed to load note from %@: %@", file, error.localizedDescription);
        }
    }
    
    NSLog(@"Restored %lu sticky notes from %@", (unsigned long)sortedFiles.count, saveDir);
}

#pragma mark - Batch Operations

- (void)increaseFontSizeForAllNotes {
    for (SNNoteWindowController *note in _notes) {
        [note increaseFontSize:nil];
    }
}

- (void)decreaseFontSizeForAllNotes {
    for (SNNoteWindowController *note in _notes) {
        [note decreaseFontSize:nil];
    }
}

- (void)applyPreferencesToAllNotes {
    SNColorTheme *currentTheme = _preferences.defaultColorTheme;
    
    // Apply current color theme to all existing notes
    for (SNNoteWindowController *note in _notes) {
        [note applyColorTheme:currentTheme];
    }
    
    // Show user feedback with theme information
    if ([_notes count] > 0) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Theme Applied"];
        [alert setInformativeText:[NSString stringWithFormat:
                                  @"Applied \"%@\" theme to %lu note(s).\n\nBackground and text colors have been updated.", 
                                  currentTheme.displayName,
                                  (unsigned long)[_notes count]]];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        [alert release];
    }
}

#pragma mark - Theme Operations

- (void)previewThemeOnAllNotes:(SNColorTheme *)theme {
    // Temporarily apply theme to all notes for preview
    for (SNNoteWindowController *note in _notes) {
        [note applyColorTheme:theme];
    }
}

- (void)revertThemePreview {
    // Revert all notes back to the saved preference theme
    SNColorTheme *currentTheme = _preferences.defaultColorTheme;
    for (SNNoteWindowController *note in _notes) {
        [note applyColorTheme:currentTheme];
    }
}

#pragma mark - Auto-save

- (void)enableAutoSave {
    [self setupAutoSaveTimer];
}

- (void)disableAutoSave {
    [self stopAutoSaveTimer];
}

- (void)setupAutoSaveTimer {
    if (_preferences.autoSaveEnabled) {
        [self startAutoSaveTimer];
    } else {
        [self stopAutoSaveTimer];
    }
}

- (void)startAutoSaveTimer {
    [self stopAutoSaveTimer]; // Stop existing timer
    
    if (_preferences.autoSaveEnabled && _preferences.autoSaveInterval > 0) {
        _autoSaveTimer = [[NSTimer scheduledTimerWithTimeInterval:_preferences.autoSaveInterval
                                                           target:self
                                                         selector:@selector(autoSaveTimerFired:)
                                                         userInfo:nil
                                                          repeats:YES] retain];
        NSLog(@"Auto-save enabled with %lu second interval", (unsigned long)_preferences.autoSaveInterval);
    }
}

- (void)stopAutoSaveTimer {
    if (_autoSaveTimer) {
        [_autoSaveTimer invalidate];
        [_autoSaveTimer release];
        _autoSaveTimer = nil;
        NSLog(@"Auto-save timer stopped");
    }
}

- (void)autoSaveTimerFired:(NSTimer *)timer {
    if ([_notes count] > 0) {
        [self saveAllNotes];
    }
}

#pragma mark - Notification Handlers

- (void)preferencesDidChange:(NSNotification *)notification {
    // Update auto-save timer when preferences change
    [self setupAutoSaveTimer];
    
    // Optionally apply new preferences to existing notes
    // (We could make this a preference itself)
    if (!_hasShownColorChangeMessage && [_notes count] > 0) {
        _hasShownColorChangeMessage = YES;
        // Show dialog after a short delay to let the UI update
        [self performSelector:@selector(showColorChangeDialog) 
                   withObject:nil 
                   afterDelay:0.5];
    }
}

- (void)showColorChangeDialog {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Preference Changes"];
    [alert setInformativeText:@"Would you like to apply the new color theme to existing notes?"];
    [alert addButtonWithTitle:@"Apply"];
    [alert addButtonWithTitle:@"Keep Current"];
    
    if ([alert runModal] == NSAlertFirstButtonReturn) {
        [self applyPreferencesToAllNotes];
    }
    [alert release];
}

- (void)noteWillClose:(NSNotification *)notification {
    SNNoteWindowController *closingNote = [notification object];
    if ([_notes containsObject:closingNote]) {
        [_notes removeObject:closingNote];
        
        // Auto-save after note removal
        if (_preferences.autoSaveEnabled) {
            [self performSelector:@selector(saveAllNotes) 
                       withObject:nil 
                       afterDelay:1.0];
        }
    }
}

@end
