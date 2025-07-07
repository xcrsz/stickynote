//
//  SNConstantsTests.h
//  stickynote Tests
//
//  Unit tests for SNConstants
//

#import <Foundation/Foundation.h>
#import <UnitKit/UnitKit.h>
#import "SNConstants.h"

@interface SNConstantsTests : NSObject <UKTest>

// Application information tests
- (void)testApplicationConstants;

// User defaults key tests
- (void)testUserDefaultsKeys;

// Notification name tests
- (void)testNotificationNames;

// File system constants tests
- (void)testFileSystemConstants;

// UI constants tests
- (void)testUIConstants;

// Color theme name tests
- (void)testColorThemeNames;

// Error domain tests
- (void)testErrorConstants;

// Validation tests
- (void)testConstantValidation;

@end
