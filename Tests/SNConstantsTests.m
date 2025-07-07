//
//  SNConstantsTests.m
//  stickynote Tests
//
//  Unit tests for SNConstants implementation
//

#import "SNConstantsTests.h"
#import "SNTestUtilities.h"

@implementation SNConstantsTests

#pragma mark - Application Information Tests

- (void)testApplicationConstants {
    UKNotNil(SNApplicationName, @"Application name should be defined");
    UKNotNil(SNApplicationVersion, @"Application version should be defined");
    UKNotNil(SNApplicationIdentifier, @"Application identifier should be defined");
    
    UKTrue([SNApplicationName length] > 0, @"Application name should not be empty");
    UKTrue([SNApplicationVersion length] > 0, @"Application version should not be empty");
    UKTrue([SNApplicationIdentifier length] > 0, @"Application identifier should not be empty");
    
    UKObjectsEqual(SNApplicationName, @"stickynote", @"Application name should be stickynote");
    UKObjectsEqual(SNApplicationVersion, @"0.0.1", @"Application version should be 0.0.1");
    UKTrue([SNApplicationIdentifier hasPrefix:@"org."], @"Application identifier should follow reverse domain convention");
}

#pragma mark - User Defaults Key Tests

- (void)testUserDefaultsKeys {
    // Test that all user defaults keys are defined
    UKNotNil(SNDefaultFontSizeKey, @"Font size key should be defined");
    UKNotNil(SNDefaultColorThemeKey, @"Color theme key should be defined");
    UKNotNil(SNAutoSaveEnabledKey, @"Auto-save enabled key should be defined");
    UKNotNil(SNAutoSaveIntervalKey, @"Auto-save interval key should be defined");
    UKNotNil(SNWindowPositionsKey, @"Window positions key should be defined");
    
    // Test that keys are not empty
    UKTrue([SNDefaultFontSizeKey length] > 0, @"Font size key should not be empty");
    UKTrue([SNDefaultColorThemeKey length] > 0, @"Color theme key should not be empty");
    UKTrue([SNAutoSaveEnabledKey length] > 0, @"Auto-save enabled key should not be empty");
    UKTrue([SNAutoSaveIntervalKey length] > 0, @"Auto-save interval key should not be empty");
    UKTrue([SNWindowPositionsKey length] > 0, @"Window positions key should not be empty");
    
    // Test that keys have proper prefix
    UKTrue([SNDefaultFontSizeKey hasPrefix:@"SN"], @"Font size key should have SN prefix");
    UKTrue([SNDefaultColorThemeKey hasPrefix:@"SN"], @"Color theme key should have SN prefix");
    UKTrue([SNAutoSaveEnabledKey hasPrefix:@"SN"], @"Auto-save enabled key should have SN prefix");
    UKTrue([SNAutoSaveIntervalKey hasPrefix:@"SN"], @"Auto-save interval key should have SN prefix");
    UKTrue([SNWindowPositionsKey hasPrefix:@"SN"], @"Window positions key should have SN prefix");
    
    // Test that keys are unique
    NSArray *keys = @[SNDefaultFontSizeKey, SNDefaultColorThemeKey, SNAutoSaveEnabledKey, 
                     SNAutoSaveIntervalKey, SNWindowPositionsKey];
    NSSet *uniqueKeys = [NSSet setWithArray:keys];
    UKIntsEqual([keys count], [uniqueKeys count], @"All user defaults keys should be unique");
}

#pragma mark - Notification Name Tests

- (void)testNotificationNames {
    UKNotNil(SNPreferencesDidChangeNotification, @"Preferences change notification should be defined");
    UKNotNil(SNNoteWillCloseNotification, @"Note will close notification should be defined");
    UKNotNil(SNNoteDidBecomeActiveNotification, @"Note did become active notification should be defined");
    
    UKTrue([SNPreferencesDidChangeNotification length] > 0, @"Preferences change notification should not be empty");
    UKTrue([SNNoteWillCloseNotification length] > 0, @"Note will close notification should not be empty");
    UKTrue([SNNoteDidBecomeActiveNotification length] > 0, @"Note did become active notification should not be empty");
    
    // Test notification naming convention
    UKTrue([SNPreferencesDidChangeNotification hasPrefix:@"SN"], @"Preferences notification should have SN prefix");
    UKTrue([SNNoteWillCloseNotification hasPrefix:@"SN"], @"Note close notification should have SN prefix");
    UKTrue([SNNoteDidBecomeActiveNotification hasPrefix:@"SN"], @"Note active notification should have SN prefix");
    
    UKTrue([SNPreferencesDidChangeNotification hasSuffix:@"Notification"], @"Preferences notification should have Notification suffix");
    UKTrue([SNNoteWillCloseNotification hasSuffix:@"Notification"], @"Note close notification should have Notification suffix");
    UKTrue([SNNoteDidBecomeActiveNotification hasSuffix:@"Notification"], @"Note active notification should have Notification suffix");
}

#pragma mark - File System Constants Tests

- (void)testFileSystemConstants {
    UKNotNil(SNSaveDirectory, @"Save directory should be defined");
    UKNotNil(SNNoteFilePrefix, @"Note file prefix should be defined");
    UKNotNil(SNNoteFileExtension, @"Note file extension should be defined");
    UKNotNil(SNBackupDirectory, @"Backup directory should be defined");
    
    UKTrue([SNSaveDirectory length] > 0, @"Save directory should not be empty");
    UKTrue([SNNoteFilePrefix length] > 0, @"Note file prefix should not be empty");
    UKTrue([SNNoteFileExtension length] > 0, @"Note file extension should not be empty");
    UKTrue([SNBackupDirectory length] > 0, @"Backup directory should not be empty");
    
    // Test file extension format
    UKTrue([SNNoteFileExtension hasPrefix:@"."], @"File extension should start with dot");
    
    // Test directory paths
    UKTrue([SNSaveDirectory hasPrefix:@"~"], @"Save directory should be in user home");
    UKTrue([SNBackupDirectory hasPrefix:@"~"], @"Backup directory should be in user home");
    
    // Test that save directory reflects new app name
    UKTrue([SNSaveDirectory containsString:@"stickynote"], @"Save directory should contain stickynote");
}

#pragma mark - UI Constants Tests

- (void)testUIConstants {
    // Test font size constants
    UKTrue(SNMinimumFontSize > 0, @"Minimum font size should be positive");
    UKTrue(SNMaximumFontSize > SNMinimumFontSize, @"Maximum font size should be greater than minimum");
    UKTrue(SNDefaultFontSize >= SNMinimumFontSize, @"Default font size should be at least minimum");
    UKTrue(SNDefaultFontSize <= SNMaximumFontSize, @"Default font size should be at most maximum");
    
    // Test reasonable font size values
    UKTrue(SNMinimumFontSize >= 6.0, @"Minimum font size should be at least 6pt");
    UKTrue(SNMaximumFontSize <= 144.0, @"Maximum font size should be at most 144pt");
    UKTrue(SNDefaultFontSize >= 10.0 && SNDefaultFontSize <= 20.0, @"Default font size should be reasonable");
    
    // Test window size constants
    UKTrue(SNMinimumWindowWidth > 0, @"Minimum window width should be positive");
    UKTrue(SNMinimumWindowHeight > 0, @"Minimum window height should be positive");
    UKTrue(SNDefaultWindowWidth >= SNMinimumWindowWidth, @"Default width should be at least minimum");
    UKTrue(SNDefaultWindowHeight >= SNMinimumWindowHeight, @"Default height should be at least minimum");
    
    // Test reasonable window size values
    UKTrue(SNMinimumWindowWidth >= 100.0, @"Minimum window width should be at least 100px");
    UKTrue(SNMinimumWindowHeight >= 100.0, @"Minimum window height should be at least 100px");
    UKTrue(SNDefaultWindowWidth >= 200.0, @"Default window width should be reasonable");
    UKTrue(SNDefaultWindowHeight >= 150.0, @"Default window height should be reasonable");
    
    // Test auto-save interval constants
    UKTrue(SNMinAutoSaveInterval > 0, @"Minimum auto-save interval should be positive");
    UKTrue(SNMaxAutoSaveInterval > SNMinAutoSaveInterval, @"Maximum auto-save interval should be greater than minimum");
    UKTrue(SNDefaultAutoSaveInterval >= SNMinAutoSaveInterval, @"Default auto-save interval should be at least minimum");
    UKTrue(SNDefaultAutoSaveInterval <= SNMaxAutoSaveInterval, @"Default auto-save interval should be at most maximum");
    
    // Test reasonable auto-save values (in seconds)
    UKTrue(SNMinAutoSaveInterval >= 5, @"Minimum auto-save should be at least 5 seconds");
    UKTrue(SNMaxAutoSaveInterval <= 7200, @"Maximum auto-save should be at most 2 hours");
    UKTrue(SNDefaultAutoSaveInterval >= 10 && SNDefaultAutoSaveInterval <= 300, @"Default auto-save should be reasonable");
}

#pragma mark - Color Theme Name Tests

- (void)testColorThemeNames {
    UKNotNil(SNYellowThemeName, @"Yellow theme name should be defined");
    UKNotNil(SNPinkThemeName, @"Pink theme name should be defined");
    UKNotNil(SNBlueThemeName, @"Blue theme name should be defined");
    UKNotNil(SNGreenThemeName, @"Green theme name should be defined");
    UKNotNil(SNWhiteThemeName, @"White theme name should be defined");
    UKNotNil(SNDarkThemeName, @"Dark theme name should be defined");
    
    UKTrue([SNYellowThemeName length] > 0, @"Yellow theme name should not be empty");
    UKTrue([SNPinkThemeName length] > 0, @"Pink theme name should not be empty");
    UKTrue([SNBlueThemeName length] > 0, @"Blue theme name should not be empty");
    UKTrue([SNGreenThemeName length] > 0, @"Green theme name should not be empty");
    UKTrue([SNWhiteThemeName length] > 0, @"White theme name should not be empty");
    UKTrue([SNDarkThemeName length] > 0, @"Dark theme name should not be empty");
    
    // Test that theme names are unique
    NSArray *themeNames = @[SNYellowThemeName, SNPinkThemeName, SNBlueThemeName,
                           SNGreenThemeName, SNWhiteThemeName, SNDarkThemeName];
    NSSet *uniqueThemeNames = [NSSet setWithArray:themeNames];
    UKIntsEqual([themeNames count], [uniqueThemeNames count], @"All theme names should be unique");
    
    // Test theme name conventions (should be lowercase, simple)
    for (NSString *themeName in themeNames) {
        UKObjectsEqual(themeName, [themeName lowercaseString], @"Theme names should be lowercase");
        UKFalse([themeName containsString:@" "], @"Theme names should not contain spaces");
    }
}

#pragma mark - Error Domain Tests

- (void)testErrorConstants {
    UKNotNil(SNErrorDomain, @"Error domain should be defined");
    UKTrue([SNErrorDomain length] > 0, @"Error domain should not be empty");
    UKTrue([SNErrorDomain hasPrefix:@"SN"], @"Error domain should have SN prefix");
    
    // Test error codes are defined (by checking they compile)
    SNErrorCode testCode = SNErrorCodeFileNotFound;
    UKTrue(testCode == SNErrorCodeFileNotFound, @"Error codes should be defined");
    
    // Test that error codes have reasonable values
    UKTrue(SNErrorCodeFileNotFound >= 1000, @"Error codes should start at 1000 or higher");
    UKTrue(SNErrorCodeInvalidFormat != SNErrorCodeFileNotFound, @"Error codes should be unique");
    UKTrue(SNErrorCodePermissionDenied != SNErrorCodeFileNotFound, @"Error codes should be unique");
}

#pragma mark - Validation Tests

- (void)testConstantValidation {
    // Test that font size constants form a valid range
    float fontRange = SNMaximumFontSize - SNMinimumFontSize;
    UKTrue(fontRange >= 10.0, @"Font size range should be at least 10 points");
    
    // Test that window size constants are proportional
    float windowRatio = SNDefaultWindowWidth / SNDefaultWindowHeight;
    UKTrue(windowRatio >= 1.0 && windowRatio <= 3.0, @"Default window should have reasonable aspect ratio");
    
    // Test that auto-save intervals make sense
    UKTrue(SNDefaultAutoSaveInterval >= SNMinAutoSaveInterval * 2, @"Default auto-save should be at least 2x minimum");
    UKTrue(SNMaxAutoSaveInterval >= SNDefaultAutoSaveInterval * 10, @"Maximum auto-save should be at least 10x default");
}

#pragma mark - Consistency Tests

- (void)testNamingConsistency {
    // Test that all string constants follow naming conventions
    NSArray *allStringConstants = @[
        SNApplicationName, SNApplicationVersion, SNApplicationIdentifier,
        SNDefaultFontSizeKey, SNDefaultColorThemeKey, SNAutoSaveEnabledKey,
        SNAutoSaveIntervalKey, SNWindowPositionsKey,
        SNPreferencesDidChangeNotification, SNNoteWillCloseNotification,
        SNNoteDidBecomeActiveNotification,
        SNSaveDirectory, SNNoteFilePrefix, SNNoteFileExtension, SNBackupDirectory,
        SNYellowThemeName, SNPinkThemeName, SNBlueThemeName,
        SNGreenThemeName, SNWhiteThemeName, SNDarkThemeName,
        SNErrorDomain
    ];
    
    for (NSString *constant in allStringConstants) {
        UKNotNil(constant, @"All string constants should be non-nil");
        UKTrue([constant isKindOfClass:[NSString class]], @"All string constants should be NSString objects");
        UKTrue([constant length] > 0, @"All string constants should be non-empty");
    }
}

- (void)testValueRangeConsistency {
    // Test that numeric constants are within expected ranges
    UKTrue(SNMinimumFontSize > 0 && SNMinimumFontSize < 20, @"Minimum font size should be reasonable");
    UKTrue(SNMaximumFontSize > 20 && SNMaximumFontSize < 200, @"Maximum font size should be reasonable");
    UKTrue(SNDefaultFontSize > 8 && SNDefaultFontSize < 24, @"Default font size should be reasonable");
    
    UKTrue(SNMinimumWindowWidth > 50 && SNMinimumWindowWidth < 500, @"Minimum window width should be reasonable");
    UKTrue(SNMinimumWindowHeight > 50 && SNMinimumWindowHeight < 500, @"Minimum window height should be reasonable");
    UKTrue(SNDefaultWindowWidth > 100 && SNDefaultWindowWidth < 1000, @"Default window width should be reasonable");
    UKTrue(SNDefaultWindowHeight > 100 && SNDefaultWindowHeight < 1000, @"Default window height should be reasonable");
    
    UKTrue(SNMinAutoSaveInterval >= 1 && SNMinAutoSaveInterval <= 60, @"Minimum auto-save interval should be reasonable");
    UKTrue(SNMaxAutoSaveInterval >= 300 && SNMaxAutoSaveInterval <= 10800, @"Maximum auto-save interval should be reasonable");
    UKTrue(SNDefaultAutoSaveInterval >= 10 && SNDefaultAutoSaveInterval <= 600, @"Default auto-save interval should be reasonable");
}

@end
