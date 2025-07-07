//
//  SNColorThemeTests.h
//  stickynote Tests
//
//  Unit tests for SNColorTheme class
//

#import <Foundation/Foundation.h>
#import <UnitKit/UnitKit.h>
#import "SNColorTheme.h"

@interface SNColorThemeTests : NSObject <UKTest>

// Factory method tests
- (void)testThemeCreation;
- (void)testThemeProperties;

// Theme management tests
- (void)testAvailableThemes;
- (void)testThemeWithName;
- (void)testDefaultTheme;

// Theme comparison tests
- (void)testThemeEquality;
- (void)testThemeHashing;

// Specific theme tests
- (void)testAllBuiltInThemes;
- (void)testThemeDisplayNames;

// Error handling tests
- (void)testInvalidThemeName;
- (void)testNilParameters;

@end
