//
//  SNPreferencesTests.m
//  stickynote Tests
//
//  Unit tests for SNPreferences class implementation
//

#import "SNPreferencesTests.h"
#import "SNTestUtilities.h"
#import "SNConstants.h"
#import "SNColorTheme.h"

@interface SNPreferencesTests ()
@property (retain) SNPreferences *preferences;
@property (assign) BOOL notificationReceived;
@end

@implementation SNPreferencesTests

#pragma mark - Test Setup and Teardown

- (void)setUp {
    // Clean up any existing state
    [SNTestUtilities cleanupUserDefaults];
    [SNTestUtilities clearMockUserDefaults];
    
    // Get fresh preferences instance
    _preferences = [SNPreferences sharedPreferences];
    _notificationReceived = NO;
    
    // Reset preferences to defaults for each test
    [_preferences resetToDefaults];
}

- (void)tearDown {
    // Clean up after each test
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [SNTestUtilities cleanupUserDefaults];
    _notificationReceived = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

#pragma mark - Singleton Tests

- (void)testSharedPreferencesReturnsSameInstance {
    SNPreferences *prefs1 = [SNPreferences sharedPreferences];
    SNPreferences *prefs2 = [SNPreferences sharedPreferences];
    
    UKObjectsEqual(prefs1, prefs2, @"sharedPreferences should return the same instance");
    UKTrue(prefs1 == prefs2, @"sharedPreferences should return identical pointers");
}

- (void)testSharedPreferencesInitializesWithDefaults {
    SNPreferences *prefs = [SNPreferences sharedPreferences];
    
    UKFloatsEqual(prefs.defaultFontSize, SNDefaultFontSize, 0.1, @"Should initialize with default font size");
    UKTrue(prefs.autoSaveEnabled, @"Should initialize with auto-save enabled");
    UKIntsEqual(prefs.autoSaveInterval, SNDefaultAutoSaveInterval, @"Should initialize with default auto-save interval");
    UKNotNil(prefs.defaultColorTheme, @"Should initialize with a default color theme");
}

#pragma mark - Property Validation Tests

- (void)testDefaultFontSizeValidation {
    // Test valid font size
    _preferences.defaultFontSize = 14.0;
    UKFloatsEqual(_preferences.defaultFontSize, 14.0, 0.1, @"Should accept valid font size");
    
    // Test minimum clamping
    _preferences.defaultFontSize = 5.0;  // Below minimum
    UKFloatsEqual(_preferences.defaultFontSize, SNMinimumFontSize, 0.1, @"Should clamp to minimum font size");
    
    // Test maximum clamping
    _preferences.defaultFontSize = 100.0;  // Above maximum
    UKFloatsEqual(_preferences.defaultFontSize, SNMaximumFontSize, 0.1, @"Should clamp to maximum font size");
}

- (void)testFontSizeClamping {
    // Test isValidFontSize method
    UKTrue([_preferences isValidFontSize:12.0], @"12.0 should be valid font size");
    UKTrue([_preferences isValidFontSize:SNMinimumFontSize], @"Minimum font size should be valid");
    UKTrue([_preferences isValidFontSize:SNMaximumFontSize], @"Maximum font size should be valid");
    
    UKFalse([_preferences isValidFontSize:5.0], @"5.0 should be invalid (too small)");
    UKFalse([_preferences isValidFontSize:100.0], @"100.0 should be invalid (too large)");
    
    // Test clampedFontSize method
    UKFloatsEqual([_preferences clampedFontSize:5.0], SNMinimumFontSize, 0.1, @"Should clamp small values to minimum");
    UKFloatsEqual([_preferences clampedFontSize:100.0], SNMaximumFontSize, 0.1, @"Should clamp large values to maximum");
    UKFloatsEqual([_preferences clampedFontSize:14.0], 14.0, 0.1, @"Should not clamp valid values");
}

- (void)testAutoSaveIntervalValidation {
    // Test valid interval
    _preferences.autoSaveInterval = 60;
    UKIntsEqual(_preferences.autoSaveInterval, 60, @"Should accept valid interval");
    
    // Test minimum clamping
    _preferences.autoSaveInterval = 5;  // Below minimum
    UKIntsEqual(_preferences.autoSaveInterval, SNMinAutoSaveInterval, @"Should clamp to minimum interval");
    
    // Test maximum clamping
    _preferences.autoSaveInterval = 5000;  // Above maximum
    UKIntsEqual(_preferences.autoSaveInterval, SNMaxAutoSaveInterval, @"Should clamp to maximum interval");
}

#pragma mark - Persistence Tests

- (void)testSaveAndLoadDefaults {
    // Set some test values
    _preferences.defaultFontSize = 16.0;
    _preferences.autoSaveEnabled = NO;
    _preferences.autoSaveInterval = 45;
    
    SNColorTheme *blueTheme = [SNColorTheme themeWithName:@"blue"];
    _preferences.defaultColorTheme = blueTheme;
    
    // Save to defaults
    [_preferences saveDefaults];
    
    // Create new preferences instance and load
    [_preferences resetToDefaults];  // Reset to defaults first
    [_preferences loadDefaults];     // Then load saved values
    
    // Verify loaded values
    UKFloatsEqual(_preferences.defaultFontSize, 16.0, 0.1, @"Font size should be loaded correctly");
    UKFalse(_preferences.autoSaveEnabled, @"Auto-save enabled should be loaded correctly");
    UKIntsEqual(_preferences.autoSaveInterval, 45, @"Auto-save interval should be loaded correctly");
    UKObjectsEqual(_preferences.defaultColorTheme.name, @"blue", @"Color theme should be loaded correctly");
}

- (void)testResetToDefaults {
    // Set some non-default values
    _preferences.defaultFontSize = 20.0;
    _preferences.autoSaveEnabled = NO;
    _preferences.autoSaveInterval = 120;
    
    // Reset to defaults
    [_preferences resetToDefaults];
    
    // Verify default values
    UKFloatsEqual(_preferences.defaultFontSize, SNDefaultFontSize, 0.1, @"Font size should reset to default");
    UKTrue(_preferences.autoSaveEnabled, @"Auto-save should reset to enabled");
    UKIntsEqual(_preferences.autoSaveInterval, SNDefaultAutoSaveInterval, @"Auto-save interval should reset to default");
    UKObjectsEqual(_preferences.defaultColorTheme, [SNColorTheme defaultTheme], @"Color theme should reset to default");
}

#pragma mark - Notification Tests

- (void)testPreferenceChangeNotifications {
    // Register for notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferencesDidChange:)
                                                 name:SNPreferencesDidChangeNotification
                                               object:_preferences];
    
    // Change a preference
    _notificationReceived = NO;
    _preferences.defaultFontSize = 18.0;
    
    // Verify notification was sent
    UKTrue(_notificationReceived, @"Notification should be sent when preference changes");
    
    // Test that identical values don't trigger notifications
    _notificationReceived = NO;
    _preferences.defaultFontSize = 18.0;  // Same value
    
    UKFalse(_notificationReceived, @"Notification should not be sent for identical values");
}

- (void)preferencesDidChange:(NSNotification *)notification {
    _notificationReceived = YES;
    UKObjectsEqual(notification.object, _preferences, @"Notification object should be the preferences instance");
}

#pragma mark - Color Theme Tests

- (void)testColorThemeRetention {
    SNColorTheme *originalTheme = _preferences.defaultColorTheme;
    UKNotNil(originalTheme, @"Should have an initial color theme");
    
    // Set a new theme
    SNColorTheme *pinkTheme = [SNColorTheme themeWithName:@"pink"];
    _preferences.defaultColorTheme = pinkTheme;
    
    UKObjectsEqual(_preferences.defaultColorTheme, pinkTheme, @"Should retain new color theme");
    UKObjectsEqual(_preferences.defaultColorTheme.name, @"pink", @"Should have correct theme name");
}

#pragma mark - Edge Cases and Error Handling

- (void)testNilColorThemeHandling {
    SNColorTheme *originalTheme = _preferences.defaultColorTheme;
    
    // Try to set nil theme (should be handled gracefully)
    _preferences.defaultColorTheme = nil;
    
    // Should either keep the original theme or set to default
    UKNotNil(_preferences.defaultColorTheme, @"Color theme should never be nil");
}

- (void)testMultiplePropertyChanges {
    // Register for notifications
    __block int notificationCount = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(countNotification:)
                                                 name:SNPreferencesDidChangeNotification
                                               object:_preferences];
    
    // Change multiple properties
    _preferences.defaultFontSize = 16.0;
    _preferences.autoSaveEnabled = NO;
    _preferences.autoSaveInterval = 60;
    
    // Should have received multiple notifications
    UKTrue(notificationCount >= 3, @"Should receive notification for each property change");
}

- (void)countNotification:(NSNotification *)notification {
    static int count = 0;
    count++;
    // This is a simple counter for the test above
}

@end
