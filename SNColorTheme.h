//
//  SNColorTheme.h
//  stickynote
//
//  Color theme definitions and management
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface SNColorTheme : NSObject

// Theme properties
@property (readonly) NSString *name;
@property (readonly) NSString *displayName;
@property (readonly) NSColor *backgroundColor;
@property (readonly) NSColor *textColor;

// Factory methods
+ (instancetype)themeWithName:(NSString *)name 
                  displayName:(NSString *)displayName 
              backgroundColor:(NSColor *)bgColor 
                    textColor:(NSColor *)textColor;

// Theme management
+ (NSArray<SNColorTheme *> *)availableThemes;
+ (SNColorTheme *)themeWithName:(NSString *)name;
+ (SNColorTheme *)defaultTheme;

// Utility methods
+ (NSColor *)contrastingTextColorForBackground:(NSColor *)backgroundColor;
- (BOOL)isDarkTheme;
- (NSString *)accessibilityDescription;

// Comparison
- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;

@end
