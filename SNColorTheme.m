//
//  SNColorTheme.m
//  stickynote
//
//  Color theme definitions and management
//  Enhanced with better text color contrast
//

#import "SNColorTheme.h"
#import "SNConstants.h"

@implementation SNColorTheme

+ (instancetype)themeWithName:(NSString *)name 
                  displayName:(NSString *)displayName 
              backgroundColor:(NSColor *)bgColor 
                    textColor:(NSColor *)textColor {
    SNColorTheme *theme = [[SNColorTheme alloc] init];
    theme->_name = [name copy];
    theme->_displayName = [displayName copy];
    theme->_backgroundColor = [bgColor retain];
    theme->_textColor = [textColor retain];
    return [theme autorelease];
}

+ (NSArray<SNColorTheme *> *)availableThemes {
    static NSArray *themes = nil;
    static BOOL initialized = NO;
    
    if (!initialized) {
        @synchronized(self) {
            if (!initialized) {
                themes = [[NSArray alloc] initWithObjects:
                    // Classic Yellow - warm yellow with dark text
                    [SNColorTheme themeWithName:SNYellowThemeName
                                     displayName:@"Classic Yellow"
                                 backgroundColor:[NSColor colorWithCalibratedRed:1.0 green:1.0 blue:0.8 alpha:1.0]
                                       textColor:[NSColor colorWithCalibratedRed:0.2 green:0.2 blue:0.2 alpha:1.0]],
                    
                    // Soft Pink - light pink with dark text
                    [SNColorTheme themeWithName:SNPinkThemeName
                                     displayName:@"Soft Pink"
                                 backgroundColor:[NSColor colorWithCalibratedRed:1.0 green:0.9 blue:0.95 alpha:1.0]
                                       textColor:[NSColor colorWithCalibratedRed:0.3 green:0.2 blue:0.3 alpha:1.0]],
                    
                    // Light Blue - pale blue with dark text
                    [SNColorTheme themeWithName:SNBlueThemeName
                                     displayName:@"Light Blue"
                                 backgroundColor:[NSColor colorWithCalibratedRed:0.9 green:0.95 blue:1.0 alpha:1.0]
                                       textColor:[NSColor colorWithCalibratedRed:0.2 green:0.3 blue:0.4 alpha:1.0]],
                    
                    // Mint Green - light green with dark text
                    [SNColorTheme themeWithName:SNGreenThemeName
                                     displayName:@"Mint Green"
                                 backgroundColor:[NSColor colorWithCalibratedRed:0.9 green:1.0 blue:0.9 alpha:1.0]
                                       textColor:[NSColor colorWithCalibratedRed:0.2 green:0.4 blue:0.2 alpha:1.0]],
                    
                    // Clean White - pure white with black text
                    [SNColorTheme themeWithName:SNWhiteThemeName
                                     displayName:@"Clean White"
                                 backgroundColor:[NSColor whiteColor]
                                       textColor:[NSColor blackColor]],
                    
                    // Dark Mode - dark gray with white text (ENHANCED)
                    [SNColorTheme themeWithName:SNDarkThemeName
                                     displayName:@"Dark Mode"
                                 backgroundColor:[NSColor colorWithCalibratedRed:0.15 green:0.15 blue:0.15 alpha:1.0]
                                       textColor:[NSColor colorWithCalibratedRed:0.95 green:0.95 blue:0.95 alpha:1.0]],
                    nil];
                initialized = YES;
            }
        }
    }
    return themes;
}

+ (SNColorTheme *)themeWithName:(NSString *)name {
    for (SNColorTheme *theme in [self availableThemes]) {
        if ([theme.name isEqualToString:name]) {
            return theme;
        }
    }
    return [self defaultTheme];
}

+ (SNColorTheme *)defaultTheme {
    return [self themeWithName:SNYellowThemeName];
}

- (void)dealloc {
    [_name release];
    [_displayName release];
    [_backgroundColor release];
    [_textColor release];
    [super dealloc];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"SNColorTheme: %@ (%@) - BG:%@ Text:%@", 
            _displayName, _name, _backgroundColor, _textColor];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (![object isKindOfClass:[SNColorTheme class]]) {
        return NO;
    }
    SNColorTheme *other = (SNColorTheme *)object;
    return [self.name isEqualToString:other.name];
}

- (NSUInteger)hash {
    return [_name hash];
}

#pragma mark - Utility Methods

+ (NSColor *)contrastingTextColorForBackground:(NSColor *)backgroundColor {
    // Calculate appropriate text color for any background color
    NSColor *rgbColor = [backgroundColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    if (!rgbColor) return [NSColor blackColor];
    
    CGFloat r, g, b, a;
    [rgbColor getRed:&r green:&g blue:&b alpha:&a];
    
    // Calculate luminance using standard formula
    CGFloat luminance = 0.299 * r + 0.587 * g + 0.114 * b;
    
    // Return white text for dark backgrounds, black text for light backgrounds
    if (luminance < 0.5) {
        return [NSColor colorWithCalibratedRed:0.95 green:0.95 blue:0.95 alpha:1.0];  // Off-white
    } else {
        return [NSColor colorWithCalibratedRed:0.15 green:0.15 blue:0.15 alpha:1.0];  // Off-black
    }
}

- (BOOL)isDarkTheme {
    // Determine if this is a dark theme based on background luminance
    NSColor *rgbColor = [_backgroundColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    if (!rgbColor) return NO;
    
    CGFloat r, g, b, a;
    [rgbColor getRed:&r green:&g blue:&b alpha:&a];
    
    CGFloat luminance = 0.299 * r + 0.587 * g + 0.114 * b;
    return luminance < 0.5;
}

- (NSString *)accessibilityDescription {
    // Provide accessibility description for the theme
    NSString *bgDesc = [self isDarkTheme] ? @"Dark" : @"Light";
    return [NSString stringWithFormat:@"%@ - %@ background", _displayName, bgDesc];
}

@end
