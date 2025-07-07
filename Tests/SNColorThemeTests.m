//
//  SNColorThemeTests.m
//  stickynote Tests
//
//  Unit tests for SNColorTheme class implementation
//

#import "SNColorThemeTests.h"
#import "SNTestUtilities.h"
#import "SNConstants.h"
#import <AppKit/AppKit.h>

@implementation SNColorThemeTests

#pragma mark - Factory Method Tests

- (void)testThemeCreation {
    NSString *name = @"testTheme";
    NSString *displayName = @"Test Theme";
    NSColor *bgColor = [NSColor redColor];
    NSColor *textColor = [NSColor blackColor];
    
    SNColorTheme *theme = [SNColorTheme themeWithName:name
                                          displayName:displayName
                                      backgroundColor:bgColor
                                            textColor:textColor];
    
    UKNotNil(theme, @"Theme creation should succeed");
    UKObjectsEqual(theme.name, name, @"Theme name should be set correctly");
    UKObjectsEqual(theme.displayName, displayName, @"Theme display name should be set correctly");
    UKObjectsEqual(theme.backgroundColor, bgColor, @"Background color should be set correctly");
    UKObjectsEqual(theme.textColor, textColor, @"Text color should be set correctly");
}

- (void)testThemeProperties {
    SNColorTheme *theme = [SNColorTheme themeWithName:@"test"
                                          displayName:@"Test"
                                      backgroundColor:[NSColor blueColor]
                                            textColor:[NSColor whiteColor]];
    
    // Test that properties are readonly and don't change unexpectedly
    NSString *originalName = theme.name;
    NSString *originalDisplayName = theme.displayName;
    
    UKObjectsEqual(theme.name, originalName, @"Name should remain constant");
    UKObjectsEqual(theme.displayName, originalDisplayName, @"Display name should remain constant");
    UKNotNil(theme.backgroundColor, @"Background color should not be nil");
    UKNotNil(theme.textColor, @"Text color should not be nil");
}

#pragma mark - Theme Management Tests

- (void)testAvailableThemes {
    NSArray *themes = [SNColorTheme availableThemes];
    
    UKNotNil(themes, @"Available themes should not be nil");
    UKTrue([themes count] >= 6, @"Should have at least 6 built-in themes");
    
    // Test that all themes are SNColorTheme objects
    for (id theme in themes) {
        UKTrue([theme isKindOfClass:[SNColorTheme class]], @"All items should be SNColorTheme objects");
    }
    
    // Test that calling multiple times returns the same array (singleton behavior)
    NSArray *themes2 = [SNColorTheme availableThemes];
    UKObjectsEqual(themes, themes2, @"Multiple calls should return the same array");
}

- (void)testThemeWithName {
    // Test valid theme names
    SNColorTheme *yellowTheme = [SNColorTheme themeWithName:SNYellowThemeName];
    UKNotNil(yellowTheme, @"Should find yellow theme");
    UKObjectsEqual(yellowTheme.name, SNYellowThemeName, @"Should return correct theme");
    
    SNColorTheme *darkTheme = [SNColorTheme themeWithName:SNDarkThemeName];
    UKNotNil(darkTheme, @"Should find dark theme");
    UKObjectsEqual(darkTheme.name, SNDarkThemeName, @"Should return correct theme");
    
    // Test invalid theme name
    SNColorTheme *invalidTheme = [SNColorTheme themeWithName:@"nonexistent"];
    UKNotNil(invalidTheme, @"Should return default theme for invalid name");
    UKObjectsEqual(invalidTheme, [SNColorTheme defaultTheme], @"Should return default theme for invalid name");
}

- (void)testDefaultTheme {
    SNColorTheme *defaultTheme = [SNColorTheme defaultTheme];
    
    UKNotNil(defaultTheme, @"Default theme should not be nil");
    UKObjectsEqual(defaultTheme.name, SNYellowThemeName, @"Default theme should be yellow");
    UKNotNil(defaultTheme.backgroundColor, @"Default theme should have background color");
    UKNotNil(defaultTheme.textColor, @"Default theme should have text color");
}

#pragma mark - Theme Comparison Tests

- (void)testThemeEquality {
    SNColorTheme *theme1 = [SNColorTheme themeWithName:SNYellowThemeName];
    SNColorTheme *theme2 = [SNColorTheme themeWithName:SNYellowThemeName];
    SNColorTheme *theme3 = [SNColorTheme themeWithName:SNPinkThemeName];
    
    // Test equality
    UKTrue([theme1 isEqual:theme2], @"Themes with same name should be equal");
    UKFalse([theme1 isEqual:theme3], @"Themes with different names should not be equal");
    
    // Test self-equality
    UKTrue([theme1 isEqual:theme1], @"Theme should be equal to itself");
    
    // Test nil comparison
    UKFalse([theme1 isEqual:nil], @"Theme should not be equal to nil");
    
    // Test non-theme object comparison
    UKFalse([theme1 isEqual:@"not a theme"], @"Theme should not be equal to non-theme object");
}

- (void)testThemeHashing {
    SNColorTheme *theme1 = [SNColorTheme themeWithName:SNYellowThemeName];
    SNColorTheme *theme2 = [SNColorTheme themeWithName:SNYellowThemeName];
    SNColorTheme *theme3 = [SNColorTheme themeWithName:SNPinkThemeName];
    
    // Equal objects should have equal hashes
    UKIntsEqual([theme1 hash], [theme2 hash], @"Equal themes should have equal hashes");
    
    // Different objects should preferably have different hashes
    UKTrue([theme1 hash] != [theme3 hash], @"Different themes should have different hashes");
}

#pragma mark - Specific Theme Tests

- (void)testAllBuiltInThemes {
    NSArray *expectedThemeNames = @[
        SNYellowThemeName,
        SNPinkThemeName,
        SNBlueThemeName,
        SNGreenThemeName,
        SNWhiteThemeName,
        SNDarkThemeName
    ];
    
    NSArray *themes = [SNColorTheme availableThemes];
    
    // Test that all expected themes exist
    for (NSString *expectedName in expectedThemeNames) {
        BOOL found = NO;
        for (SNColorTheme *theme in themes) {
            if ([theme.name isEqualToString:expectedName]) {
                found = YES;
                
                // Test that each theme has proper properties
                UKNotNil(theme.displayName, @"Theme %@ should have display name", expectedName);
                UKNotNil(theme.backgroundColor, @"Theme %@ should have background color", expectedName);
                UKNotNil(theme.textColor, @"Theme %@ should have text color", expectedName);
                UKTrue([theme.displayName length] > 0, @"Theme %@ should have non-empty display name", expectedName);
                
                break;
            }
        }
        UKTrue(found, @"Should find theme with name %@", expectedName);
    }
}

- (void)testThemeDisplayNames {
    NSArray *themes = [SNColorTheme availableThemes];
    NSMutableSet *displayNames = [NSMutableSet set];
    
    for (SNColorTheme *theme in themes) {
        UKNotNil(theme.displayName, @"All themes should have display names");
        UKTrue([theme.displayName length] > 0, @"Display names should not be empty");
        
        // Test that display names are unique
        UKFalse([displayNames containsObject:theme.displayName], @"Display names should be unique");
        [displayNames addObject:theme.displayName];
        
        // Test that display names are user-friendly (not just the internal name)
        UKFalse([theme.displayName isEqualToString:theme.name], @"Display name should be different from internal name");
    }
}

#pragma mark - Error Handling Tests

- (void)testInvalidThemeName {
    // Test empty string
    SNColorTheme *emptyTheme = [SNColorTheme themeWithName:@""];
    UKObjectsEqual(emptyTheme, [SNColorTheme defaultTheme], @"Empty string should return default theme");
    
    // Test nil name
    SNColorTheme *nilTheme = [SNColorTheme themeWithName:nil];
    UKObjectsEqual(nilTheme, [SNColorTheme defaultTheme], @"Nil name should return default theme");
    
    // Test case sensitivity
    SNColorTheme *uppercaseTheme = [SNColorTheme themeWithName:@"YELLOW"];
    UKObjectsEqual(uppercaseTheme, [SNColorTheme defaultTheme], @"Wrong case should return default theme");
}

- (void)testNilParameters {
    // Test theme creation with nil parameters
    SNColorTheme *themeWithNilName = [SNColorTheme themeWithName:nil
                                                     displayName:@"Test"
                                                 backgroundColor:[NSColor redColor]
                                                       textColor:[NSColor blackColor]];
    UKNotNil(themeWithNilName, @"Should handle nil name gracefully");
    
    SNColorTheme *themeWithNilDisplayName = [SNColorTheme themeWithName:@"test"
                                                            displayName:nil
                                                        backgroundColor:[NSColor redColor]
                                                              textColor:[NSColor blackColor]];
    UKNotNil(themeWithNilDisplayName, @"Should handle nil display name gracefully");
    
    // Colors can be nil in some cases, but typically shouldn't be
    SNColorTheme *themeWithNilColors = [SNColorTheme themeWithName:@"test"
                                                       displayName:@"Test"
                                                   backgroundColor:nil
                                                         textColor:nil];
    UKNotNil(themeWithNilColors, @"Should handle nil colors gracefully");
}

#pragma mark - Performance and Memory Tests

- (void)testThemeCreationPerformance {
    // Test that theme creation is reasonably fast
    NSDate *startTime = [NSDate date];
    
    for (int i = 0; i < 100; i++) {
        SNColorTheme *theme = [SNColorTheme themeWithName:SNYellowThemeName];
        (void)theme; // Suppress unused variable warning
    }
    
    NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:startTime];
    UKTrue(elapsed < 1.0, @"Creating 100 themes should take less than 1 second");
}

- (void)testAvailableThemesConsistency {
    // Test that availableThemes returns consistent results
    NSArray *themes1 = [SNColorTheme availableThemes];
    NSArray *themes2 = [SNColorTheme availableThemes];
    
    UKIntsEqual([themes1 count], [themes2 count], @"Theme count should be consistent");
    
    for (NSUInteger i = 0; i < [themes1 count]; i++) {
        SNColorTheme *theme1 = [themes1 objectAtIndex:i];
        SNColorTheme *theme2 = [themes2 objectAtIndex:i];
        UKObjectsEqual(theme1.name, theme2.name, @"Theme names should be consistent");
    }
}

@end
