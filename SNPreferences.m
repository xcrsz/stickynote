//
//  SNPreferences.m
//  stickynote
//
//  Application preferences data model
//

#import "SNPreferences.h"
#import "SNColorTheme.h"
#import "SNConstants.h"

@implementation SNPreferences

+ (instancetype)sharedPreferences {
    static SNPreferences *sharedInstance = nil;
    static BOOL initialized = NO;
    
    if (!initialized) {
        @synchronized(self) {
            if (!initialized) {
                sharedInstance = [[self alloc] init];
                initialized = YES;
            }
        }
    }
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Set default values
        _defaultFontSize = SNDefaultFontSize;
        _defaultColorTheme = [[SNColorTheme defaultTheme] retain];
        _autoSaveEnabled = YES;
        _autoSaveInterval = SNDefaultAutoSaveInterval;
    }
    return self;
}

- (void)dealloc {
    [_defaultColorTheme release];
    [super dealloc];
}

#pragma mark - Property Setters

- (void)setDefaultFontSize:(float)defaultFontSize {
    float clampedSize = [self clampedFontSize:defaultFontSize];
    if (_defaultFontSize != clampedSize) {
        _defaultFontSize = clampedSize;
        [self notifyPreferencesChanged];
    }
}

- (void)setDefaultColorTheme:(SNColorTheme *)defaultColorTheme {
    if (_defaultColorTheme != defaultColorTheme) {
        [_defaultColorTheme release];
        _defaultColorTheme = [defaultColorTheme retain];
        [self notifyPreferencesChanged];
    }
}

- (void)setAutoSaveEnabled:(BOOL)autoSaveEnabled {
    if (_autoSaveEnabled != autoSaveEnabled) {
        _autoSaveEnabled = autoSaveEnabled;
        [self notifyPreferencesChanged];
    }
}

- (void)setAutoSaveInterval:(NSUInteger)autoSaveInterval {
    NSUInteger clampedInterval = MAX(SNMinAutoSaveInterval, 
                                    MIN(SNMaxAutoSaveInterval, autoSaveInterval));
    if (_autoSaveInterval != clampedInterval) {
        _autoSaveInterval = clampedInterval;
        [self notifyPreferencesChanged];
    }
}

#pragma mark - Persistence

- (void)loadDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    float savedSize = [defaults floatForKey:SNDefaultFontSizeKey];
    if (savedSize > 0) {
        _defaultFontSize = [self clampedFontSize:savedSize];
    }
    
    NSString *savedThemeName = [defaults stringForKey:SNDefaultColorThemeKey];
    if (savedThemeName) {
        SNColorTheme *theme = [SNColorTheme themeWithName:savedThemeName];
        if (theme != _defaultColorTheme) {
            [_defaultColorTheme release];
            _defaultColorTheme = [theme retain];
        }
    }
    
    if ([defaults objectForKey:SNAutoSaveEnabledKey]) {
        _autoSaveEnabled = [defaults boolForKey:SNAutoSaveEnabledKey];
    }
    
    NSUInteger savedInterval = [defaults integerForKey:SNAutoSaveIntervalKey];
    if (savedInterval > 0) {
        _autoSaveInterval = MAX(SNMinAutoSaveInterval, 
                               MIN(SNMaxAutoSaveInterval, savedInterval));
    }
}

- (void)saveDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:_defaultFontSize forKey:SNDefaultFontSizeKey];
    [defaults setObject:_defaultColorTheme.name forKey:SNDefaultColorThemeKey];
    [defaults setBool:_autoSaveEnabled forKey:SNAutoSaveEnabledKey];
    [defaults setInteger:_autoSaveInterval forKey:SNAutoSaveIntervalKey];
    [defaults synchronize];
}

- (void)resetToDefaults {
    self.defaultFontSize = SNDefaultFontSize;
    self.defaultColorTheme = [SNColorTheme defaultTheme];
    self.autoSaveEnabled = YES;
    self.autoSaveInterval = SNDefaultAutoSaveInterval;
}

#pragma mark - Validation

- (BOOL)isValidFontSize:(float)fontSize {
    return fontSize >= SNMinimumFontSize && fontSize <= SNMaximumFontSize;
}

- (float)clampedFontSize:(float)fontSize {
    return MAX(SNMinimumFontSize, MIN(SNMaximumFontSize, fontSize));
}

#pragma mark - Notifications

- (void)notifyPreferencesChanged {
    [[NSNotificationCenter defaultCenter] 
        postNotificationName:SNPreferencesDidChangeNotification 
                      object:self];
}

@end
