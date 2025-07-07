//
//  SNMenuManager.h
//  stickynote
//
//  Application menu system management
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@protocol SNMenuManagerDelegate <NSObject>
@required
- (void)createNewNote:(id)sender;
- (void)showPreferences:(id)sender;
- (void)increaseFontSize:(id)sender;
- (void)decreaseFontSize:(id)sender;
- (void)showAboutDialog:(id)sender;
@end

@interface SNMenuManager : NSObject

@property (assign) id<SNMenuManagerDelegate> delegate;

// Initialization
- (instancetype)initWithDelegate:(id<SNMenuManagerDelegate>)delegate;

// Menu setup
- (void)setupApplicationMenu;

@end
