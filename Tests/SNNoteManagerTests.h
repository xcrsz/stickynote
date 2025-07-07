//
//  SNNoteManagerTests.h
//  stickynote Tests
//
//  Unit tests for SNNoteManager class
//

#import <Foundation/Foundation.h>
#import <UnitKit/UnitKit.h>
#import "SNNoteManager.h"

@interface SNNoteManagerTests : NSObject <UKTest>

// Setup and teardown
- (void)setUp;
- (void)tearDown;

// Initialization tests
- (void)testInitialization;
- (void)testInitializationWithPreferences;

// Note creation tests
- (void)testCreateNewNote;
- (void)testCreateNewNoteWithText;
- (void)testMultipleNoteCreation;

// Note management tests
- (void)testNoteCount;
- (void)testHasNotes;
- (void)testAllNotes;
- (void)testRemoveNote;

// Persistence tests
- (void)testSaveAllNotes;
- (void)testRestoreNotesFromDisk;
- (void)testSaveAndRestoreCycle;

// Auto-save tests
- (void)testAutoSaveConfiguration;
- (void)testEnableDisableAutoSave;

// Batch operations tests
- (void)testIncreaseFontSizeForAllNotes;
- (void)testDecreaseFontSizeForAllNotes;
- (void)testApplyPreferencesToAllNotes;

// Notification handling tests
- (void)testPreferencesChangeHandling;
- (void)testNoteCloseHandling;

// Error handling tests
- (void)testInvalidDirectoryHandling;
- (void)testCorruptedFileHandling;

@end
