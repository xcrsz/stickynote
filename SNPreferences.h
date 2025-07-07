//
//  SNPreferences.h
//  stickynote
//
//  Application preferences data model
//

#import <Foundation/Foundation.h>

@class SNColorTheme;

extern NSString * const SNPreferencesDidChangeNotification;

@interface SNPreferences : NSObject

// Core preferences
@property (nonatomic, assign) float defaultFontSize;
@property (nonatomic, retain) SNColorTheme *defaultColorTheme;
@property (nonatomic, assign) BOOL autoSaveEnabled;
@property (nonatomic, assign) NSUInteger autoSaveInterval; // seconds

// Singleton access
+ (instancetype)sharedPreferences;

// Persistence
- (void)loadDefaults;
- (void)saveDefaults;
- (void)resetToDefaults;

// Validation
- (BOOL)isValidFontSize:(float)fontSize;
- (float)clampedFontSize:(float)fontSize;

@end
