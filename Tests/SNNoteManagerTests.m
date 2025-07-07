//
//  SNNoteManagerTests.m
//  stickynote Tests
//
//  Unit tests for SNNoteManager class implementation
//

#import "SNNoteManagerTests.h"
#import "SNTestUtilities.h"
#import "SNPreferences.h"
#import "SNColorTheme.h"
#import "SNConstants.h"
#import "SNNoteWindowController.h"
#import <AppKit/AppKit.h>

@interface SNNoteManagerTests ()
@property (retain) SNNoteManager *noteManager;
@property (retain) SNPreferences *testPreferences;
@property (assign) BOOL notificationReceived;
@property (retain) NSString *originalSaveDirectory;
@end

@implementation SNNoteManagerTests

#pragma mark - Setup and Teardown

- (void)setUp {
    // Initialize NSApplication if needed for UI tests
    if (![NSApplication sharedApplication]) {
        [NSApplication sharedApplication];
    }
    
    // Clean up test environment
    [SNTestUtilities cleanupTestDataDirectory];
    [SNTestUtilities cleanupUserDefaults];
    [SNTestUtilities createTestDataDirectory];
    
    // Create test preferences
    _testPreferences = [SNPreferences sharedPreferences];
    [_testPreferences resetToDefaults];
    _testPreferences.autoSaveEnabled = NO; // Disable auto-save for most tests
    
    // Create note manager with test preferences
    _noteManager = [[SNNoteManager alloc] initWithPreferences:_testPreferences];
    
    _notificationReceived = NO;
}

- (void)tearDown {
    // Clean up notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // Clean up note manager
    [_noteManager disableAutoSave];
    [_noteManager release];
    _noteManager = nil;
    
    // Clean up test data
    [SNTestUtilities cleanupTestDataDirectory];
    [SNTestUtilities cleanupUserDefaults];
    
    _notificationReceived = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_noteManager release];
    [super dealloc];
}

#pragma mark - Initialization Tests

- (void)testInitialization {
    UKNotNil(_noteManager, @"Note manager should initialize successfully");
    UKFalse([_noteManager hasNotes], @"New note manager should have no notes");
    UKIntsEqual([_noteManager noteCount], 0, @"New note manager should have zero note count");
}

- (void)testInitializationWithPreferences {
    // Test that note manager retains preferences reference
    UKNotNil(_noteManager, @"Note manager should initialize with preferences");
    
    // Verify it responds to preference changes
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(noteManagerNotificationReceived:)
                                                 name:SNPreferencesDidChangeNotification
                                               object:_testPreferences];
    
    // Change a preference and verify the note manager can handle it
    _testPreferences.defaultFontSize = 16.0;
    // The notification handling is tested separately
}

#pragma mark - Note Creation Tests

- (void)testCreateNewNote {
    UKIntsEqual([_noteManager noteCount], 0, @"Should start with no notes");
    
    [_noteManager createNewNote];
    
    UKIntsEqual([_noteManager noteCount], 1, @"Should have one note after creation");
    UKTrue([_noteManager hasNotes], @"Should have notes after creation");
    
    NSArray *notes = [_noteManager allNotes];
    UKIntsEqual([notes count], 1, @"allNotes should return one note");
    
    SNNoteWindowController *note = [notes objectAtIndex:0];
    UKTrue([note isKindOfClass:[SNNoteWindowController class]], @"Note should be SNNoteWindowController");
}

- (void)testCreateNewNoteWithText {
    NSString *testText = @"Test note content";
    
    [_noteManager createNewNoteWithText:testText];
    
    UKIntsEqual([_noteManager noteCount], 1, @"Should have one note after creation");
    
    NSArray *notes = [_noteManager allNotes];
    SNNoteWindowController *note = [notes objectAtIndex:0];
    UKObjectsEqual([note noteText], testText, @"Note should contain the specified text");
}

- (void)testMultipleNoteCreation {
    // Create several notes
    [_noteManager createNewNote];
    [_noteManager createNewNoteWithText:@"Note 1"];
    [_noteManager createNewNoteWithText:@"Note 2"];
    
    UKIntsEqual([_noteManager noteCount], 3, @"Should have three notes");
    UKTrue([_noteManager hasNotes], @"Should have notes");
    
    NSArray *notes = [_noteManager allNotes];
    UKIntsEqual([notes count], 3, @"allNotes should return three notes");
    
    // Verify each note is unique
    SNNoteWindowController *note1 = [notes objectAtIndex:0];
    SNNoteWindowController *note2 = [notes objectAtIndex:1];
    SNNoteWindowController *note3 = [notes objectAtIndex:2];
    
    UKTrue(note1 != note2, @"Notes should be different objects");
    UKTrue(note2 != note3, @"Notes should be different objects");
    UKTrue(note1 != note3, @"Notes should be different objects");
}

#pragma mark - Note Management Tests

- (void)testNoteCount {
    UKIntsEqual([_noteManager noteCount], 0, @"Should start with zero notes");
    
    [_noteManager createNewNote];
    UKIntsEqual([_noteManager noteCount], 1, @"Should have one note");
    
    [_noteManager createNewNote];
    UKIntsEqual([_noteManager noteCount], 2, @"Should have two notes");
}

- (void)testHasNotes {
    UKFalse([_noteManager hasNotes], @"Should start with no notes");
    
    [_noteManager createNewNote];
    UKTrue([_noteManager hasNotes], @"Should have notes after creation");
}

- (void)testAllNotes {
    NSArray *emptyNotes = [_noteManager allNotes];
    UKNotNil(emptyNotes, @"allNotes should never return nil");
    UKIntsEqual([emptyNotes count], 0, @"Empty note manager should return empty array");
    
    [_noteManager createNewNote];
    [_noteManager createNewNote];
    
    NSArray *notes = [_noteManager allNotes];
    UKIntsEqual([notes count], 2, @"Should return array with two notes");
    
    // Test that the array is a copy (modifications don't affect the manager)
    NSMutableArray *mutableNotes = (NSMutableArray *)notes;
    if ([mutableNotes respondsToSelector:@selector(removeAllObjects)]) {
        [mutableNotes removeAllObjects];
        UKIntsEqual([_noteManager noteCount], 2, @"Modifying returned array should not affect note manager");
    }
}

- (void)testRemoveNote {
    [_noteManager createNewNote];
    [_noteManager createNewNote];
    UKIntsEqual([_noteManager noteCount], 2, @"Should have two notes");
    
    NSArray *notes = [_noteManager allNotes];
    SNNoteWindowController *noteToRemove = [notes objectAtIndex:0];
    
    [_noteManager removeNote:noteToRemove];
    UKIntsEqual([_noteManager noteCount], 1, @"Should have one note after removal");
    
    // Test removing non-existent note
    [_noteManager removeNote:noteToRemove];
    UKIntsEqual([_noteManager noteCount], 1, @"Removing non-existent note should not change count");
    
    // Test removing nil
    [_noteManager removeNote:nil];
    UKIntsEqual([_noteManager noteCount], 1, @"Removing nil should not change count");
}

#pragma mark - Persistence Tests

- (void)testSaveAllNotes {
    // Create some notes with content
    [_noteManager createNewNoteWithText:@"Note 1 content"];
    [_noteManager createNewNoteWithText:@"Note 2 content"];
    
    // Save notes
    [_noteManager saveAllNotes];
    
    // Verify files were created
    UKTrue([SNTestUtilities testFileExists:@"note_000.txt"], @"First note file should exist");
    UKTrue([SNTestUtilities testFileExists:@"note_001.txt"], @"Second note file should exist");
    
    // Verify file contents
    NSString *testDir = [SNTestUtilities testDataDirectory];
    NSString *note1Path = [testDir stringByAppendingPathComponent:@"note_000.txt"];
    NSString *note2Path = [testDir stringByAppendingPathComponent:@"note_001.txt"];
    
    NSString *note1Content = [NSString stringWithContentsOfFile:note1Path encoding:NSUTF8StringEncoding error:nil];
    NSString *note2Content = [NSString stringWithContentsOfFile:note2Path encoding:NSUTF8StringEncoding error:nil];
    
    UKObjectsEqual(note1Content, @"Note 1 content", @"First note content should be saved correctly");
    UKObjectsEqual(note2Content, @"Note 2 content", @"Second note content should be saved correctly");
}

- (void)testRestoreNotesFromDisk {
    // Create test files
    [SNTestUtilities createTestFile:@"note_000.txt" withContent:@"Restored note 1"];
    [SNTestUtilities createTestFile:@"note_001.txt" withContent:@"Restored note 2"];
    
    // Restore notes
    [_noteManager restoreNotesFromDisk];
    
    UKIntsEqual([_noteManager noteCount], 2, @"Should restore two notes");
    
    NSArray *notes = [_noteManager allNotes];
    SNNoteWindowController *note1 = [notes objectAtIndex:0];
    SNNoteWindowController *note2 = [notes objectAtIndex:1];
    
    UKObjectsEqual([note1 noteText], @"Restored note 1", @"First note should have correct content");
    UKObjectsEqual([note2 noteText], @"Restored note 2", @"Second note should have correct content");
}

- (void)testSaveAndRestoreCycle {
    // Create notes
    [_noteManager createNewNoteWithText:@"Cycle test 1"];
    [_noteManager createNewNoteWithText:@"Cycle test 2"];
    
    // Save notes
    [_noteManager saveAllNotes];
    
    // Clear current notes (simulate app restart)
    // Note: We can't actually clear the notes without complex mocking, 
    // so we'll create a new manager and test restoration
    SNNoteManager *newManager = [[SNNoteManager alloc] initWithPreferences:_testPreferences];
    [newManager restoreNotesFromDisk];
    
    UKIntsEqual([newManager noteCount], 2, @"New manager should restore two notes");
    
    NSArray *restoredNotes = [newManager allNotes];
    SNNoteWindowController *note1 = [restoredNotes objectAtIndex:0];
    SNNoteWindowController *note2 = [restoredNotes objectAtIndex:1];
    
    UKObjectsEqual([note1 noteText], @"Cycle test 1", @"First restored note should have correct content");
    UKObjectsEqual([note2 noteText], @"Cycle test 2", @"Second restored note should have correct content");
    
    [newManager release];
}

#pragma mark - Auto-save Tests

- (void)testAutoSaveConfiguration {
    // Test that auto-save respects preferences
    _testPreferences.autoSaveEnabled = YES;
    _testPreferences.autoSaveInterval = 60;
    
    [_noteManager enableAutoSave];
    // Auto-save timer testing is complex and would require mocking NSTimer
    // For now, we test that the methods don't crash
    
    [_noteManager disableAutoSave];
    // Test passes if no exception is thrown
}

- (void)testEnableDisableAutoSave {
    [_noteManager enableAutoSave];
    // Test that this doesn't crash
    
    [_noteManager disableAutoSave];
    // Test that this doesn't crash
    
    // Multiple calls should be safe
    [_noteManager disableAutoSave];
    [_noteManager enableAutoSave];
    [_noteManager enableAutoSave];
}

#pragma mark - Batch Operations Tests

- (void)testIncreaseFontSizeForAllNotes {
    // Create some notes
    [_noteManager createNewNote];
    [_noteManager createNewNote];
    
    // Test that batch operation doesn't crash
    [_noteManager increaseFontSizeForAllNotes];
    
    // The actual font size changes would require testing the individual note controllers
    // For now, we test that the method executes without error
    UKIntsEqual([_noteManager noteCount], 2, @"Note count should remain unchanged");
}

- (void)testDecreaseFontSizeForAllNotes {
    [_noteManager createNewNote];
    [_noteManager createNewNote];
    
    [_noteManager decreaseFontSizeForAllNotes];
    
    UKIntsEqual([_noteManager noteCount], 2, @"Note count should remain unchanged");
}

- (void)testApplyPreferencesToAllNotes {
    [_noteManager createNewNote];
    [_noteManager createNewNote];
    
    // This method shows a dialog, so we test that it doesn't crash
    // In a full test environment, we might mock the NSAlert
    [_noteManager applyPreferencesToAllNotes];
    
    UKIntsEqual([_noteManager noteCount], 2, @"Note count should remain unchanged");
}

#pragma mark - Notification Handling Tests

- (void)testPreferencesChangeHandling {
    // Register for notifications to verify the note manager handles them
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(noteManagerNotificationReceived:)
                                                 name:SNPreferencesDidChangeNotification
                                               object:_testPreferences];
    
    // Change a preference
    _testPreferences.autoSaveEnabled = YES;
    
    // The note manager should handle this notification internally
    // We can't easily test the internal behavior, but we can verify it doesn't crash
}

- (void)testNoteCloseHandling {
    [_noteManager createNewNote];
    UKIntsEqual([_noteManager noteCount], 1, @"Should have one note");
    
    NSArray *notes = [_noteManager allNotes];
    SNNoteWindowController *note = [notes objectAtIndex:0];
    
    // Simulate note close notification
    [[NSNotificationCenter defaultCenter] postNotificationName:SNNoteWillCloseNotification
                                                        object:note];
    
    // The note manager should handle this and remove the note
    // Note: This might not work perfectly in the test environment without full UI
    // but it tests that the notification handling doesn't crash
}

- (void)noteManagerNotificationReceived:(NSNotification *)notification {
    _notificationReceived = YES;
}

#pragma mark - Error Handling Tests

- (void)testInvalidDirectoryHandling {
    // Test saving to an invalid directory
    // This is challenging to test directly, but we can test that it doesn't crash
    [_noteManager createNewNoteWithText:@"Test content"];
    [_noteManager saveAllNotes];
    
    // If we reach here without crashing, the error handling worked
}

- (void)testCorruptedFileHandling {
    // Create a corrupted file
    [SNTestUtilities createTestFile:@"note_000.txt" withContent:nil];
    
    // Test that restoration handles corrupted files gracefully
    [_noteManager restoreNotesFromDisk];
    
    // Should not crash, though the exact behavior depends on implementation
}

#pragma mark - Edge Cases Tests

- (void)testEmptyNoteContent {
    [_noteManager createNewNoteWithText:@""];
    [_noteManager createNewNoteWithText:nil];
    
    UKIntsEqual([_noteManager noteCount], 2, @"Should handle empty/nil content");
    
    [_noteManager saveAllNotes];
    // Should save without error
}

- (void)testLargeNumberOfNotes {
    // Create many notes to test performance and limits
    for (int i = 0; i < 50; i++) {
        [_noteManager createNewNoteWithText:[NSString stringWithFormat:@"Note %d", i]];
    }
    
    UKIntsEqual([_noteManager noteCount], 50, @"Should handle many notes");
    
    // Test that operations still work with many notes
    [_noteManager saveAllNotes];
    UKIntsEqual([_noteManager noteCount], 50, @"Note count should remain stable after save");
}

- (void)testConcurrentOperations {
    // Test multiple operations in sequence
    [_noteManager createNewNote];
    [_noteManager saveAllNotes];
    [_noteManager createNewNote];
    [_noteManager increaseFontSizeForAllNotes];
    [_noteManager saveAllNotes];
    
    UKIntsEqual([_noteManager noteCount], 2, @"Should handle sequential operations correctly");
}

@end
