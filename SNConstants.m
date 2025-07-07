//
//  SNConstants.m
//  stickynote
//
//  Shared constants implementation
//

#import "SNConstants.h"

#pragma mark - Application Information
NSString * const SNApplicationName = @"stickynote";
NSString * const SNApplicationVersion = @"0.0.1";
NSString * const SNApplicationIdentifier = @"org.gnustep.stickynote";

#pragma mark - User Defaults Keys
NSString * const SNDefaultFontSizeKey = @"SNDefaultFontSize";
NSString * const SNDefaultColorThemeKey = @"SNDefaultColorTheme";
NSString * const SNAutoSaveEnabledKey = @"SNAutoSaveEnabled";
NSString * const SNAutoSaveIntervalKey = @"SNAutoSaveInterval";
NSString * const SNWindowPositionsKey = @"SNWindowPositions";

#pragma mark - Notification Names
NSString * const SNPreferencesDidChangeNotification = @"SNPreferencesDidChangeNotification";
NSString * const SNNoteWillCloseNotification = @"SNNoteWillCloseNotification";
NSString * const SNNoteDidBecomeActiveNotification = @"SNNoteDidBecomeActiveNotification";

#pragma mark - File System
NSString * const SNSaveDirectory = @"~/Library/stickynote";
NSString * const SNNoteFilePrefix = @"note_";
NSString * const SNNoteFileExtension = @".txt";
NSString * const SNBackupDirectory = @"~/Library/stickynote/Backups";

#pragma mark - UI Constants
const CGFloat SNMinimumFontSize = 8.0;
const CGFloat SNMaximumFontSize = 72.0;
const CGFloat SNDefaultFontSize = 14.0;

const CGFloat SNMinimumWindowWidth = 200.0;
const CGFloat SNMinimumWindowHeight = 150.0;
const CGFloat SNDefaultWindowWidth = 300.0;
const CGFloat SNDefaultWindowHeight = 200.0;

const NSUInteger SNMinAutoSaveInterval = 10;  // 10 seconds
const NSUInteger SNMaxAutoSaveInterval = 3600; // 1 hour
const NSUInteger SNDefaultAutoSaveInterval = 30; // 30 seconds

#pragma mark - Color Theme Names
NSString * const SNYellowThemeName = @"yellow";
NSString * const SNPinkThemeName = @"pink";
NSString * const SNBlueThemeName = @"blue";
NSString * const SNGreenThemeName = @"green";
NSString * const SNWhiteThemeName = @"white";
NSString * const SNDarkThemeName = @"dark";

#pragma mark - Error Domains
NSString * const SNErrorDomain = @"SNErrorDomain";
