//
//  SNPreferencesTests.h
//  stickynote Tests
//
//  Unit tests for SNPreferences class
//

#import <Foundation/Foundation.h>
#import <UnitKit/UnitKit.h>
#import "SNPreferences.h"

@interface SNPreferencesTests : NSObject <UKTest>

// Test setup and teardown
- (void)setUp;
- (void)tearDown;

// Singleton tests
- (void)testSharedPreferencesReturnsSameInstance;
- (void)testSharedPreferencesInitializesWithDefaults;

// Property validation tests
- (void)testDefaultFontSizeValidation;
- (void)testFontSizeClamping;
- (void)testAutoSaveIntervalValidation;

// Persistence tests
- (void)testSaveAndLoadDefaults;
- (void)testResetToDefaults;

// Notification tests
- (void)testPreferenceChangeNotifications;

// Color theme tests
- (void)testColorThemeRetention;

@end
