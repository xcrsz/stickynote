//
//  SNConstants.h
//  stickynote
//
//  Shared constants and definitions
//

#import <Foundation/Foundation.h>

#pragma mark - Application Information
extern NSString * const SNApplicationName;
extern NSString * const SNApplicationVersion;
extern NSString * const SNApplicationIdentifier;

#pragma mark - User Defaults Keys
extern NSString * const SNDefaultFontSizeKey;
extern NSString * const SNDefaultColorThemeKey;
extern NSString * const SNAutoSaveEnabledKey;
extern NSString * const SNAutoSaveIntervalKey;
extern NSString * const SNWindowPositionsKey;

#pragma mark - Notification Names
extern NSString * const SNPreferencesDidChangeNotification;
extern NSString * const SNNoteWillCloseNotification;
extern NSString * const SNNoteDidBecomeActiveNotification;

#pragma mark - File System
extern NSString * const SNSaveDirectory;
extern NSString * const SNNoteFilePrefix;
extern NSString * const SNNoteFileExtension;
extern NSString * const SNBackupDirectory;

#pragma mark - UI Constants
extern const CGFloat SNMinimumFontSize;
extern const CGFloat SNMaximumFontSize;
extern const CGFloat SNDefaultFontSize;

extern const CGFloat SNMinimumWindowWidth;
extern const CGFloat SNMinimumWindowHeight;
extern const CGFloat SNDefaultWindowWidth;
extern const CGFloat SNDefaultWindowHeight;

extern const NSUInteger SNMinAutoSaveInterval;
extern const NSUInteger SNMaxAutoSaveInterval;
extern const NSUInteger SNDefaultAutoSaveInterval;

#pragma mark - Color Theme Names
extern NSString * const SNYellowThemeName;
extern NSString * const SNPinkThemeName;
extern NSString * const SNBlueThemeName;
extern NSString * const SNGreenThemeName;
extern NSString * const SNWhiteThemeName;
extern NSString * const SNDarkThemeName;

#pragma mark - Menu Item Tags
typedef NS_ENUM(NSInteger, SNMenuItemTag) {
    SNMenuItemTagNewNote = 1000,
    SNMenuItemTagPreferences = 1001,
    SNMenuItemTagIncreaseFontSize = 1002,
    SNMenuItemTagDecreaseFontSize = 1003,
    SNMenuItemTagBold = 1004,
    SNMenuItemTagItalic = 1005,
    SNMenuItemTagUnderline = 1006
};

#pragma mark - Error Domains
extern NSString * const SNErrorDomain;

typedef NS_ENUM(NSInteger, SNErrorCode) {
    SNErrorCodeFileNotFound = 1000,
    SNErrorCodeInvalidFormat = 1001,
    SNErrorCodePermissionDenied = 1002,
    SNErrorCodeDiskFull = 1003,
    SNErrorCodeNetworkError = 1004
};
