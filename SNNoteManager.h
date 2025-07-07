//
//  SNNoteManager.h
//  stickynote
//
//  Sticky note collection lifecycle management
//

#import <Foundation/Foundation.h>

@class SNPreferences;
@class SNNoteWindowController;
@class SNColorTheme;

@interface SNNoteManager : NSObject

// Initialization
- (instancetype)initWithPreferences:(SNPreferences *)preferences;

// Note lifecycle
- (void)createNewNote;
- (void)createNewNoteWithText:(NSString *)text;
- (void)removeNote:(SNNoteWindowController *)note;

// Collection info
- (BOOL)hasNotes;
- (NSUInteger)noteCount;
- (NSArray<SNNoteWindowController *> *)allNotes;

// Persistence
- (void)saveAllNotes;
- (void)restoreNotesFromDisk;

// Batch operations
- (void)increaseFontSizeForAllNotes;
- (void)decreaseFontSizeForAllNotes;
- (void)applyPreferencesToAllNotes;

// Theme operations
- (void)previewThemeOnAllNotes:(SNColorTheme *)theme;
- (void)revertThemePreview;

// Auto-save
- (void)enableAutoSave;
- (void)disableAutoSave;

@end
