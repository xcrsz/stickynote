//
//  SNMenuManager.m
//  stickynote
//
//  Application menu system management
//

#import "SNMenuManager.h"
#import "SNConstants.h"

@implementation SNMenuManager

- (instancetype)initWithDelegate:(id<SNMenuManagerDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)setupApplicationMenu {
    NSMenu *menubar = [[NSMenu alloc] init];
    
    [self addApplicationMenuToMenubar:menubar];
    [self addFileMenuToMenubar:menubar];
    [self addEditMenuToMenubar:menubar];
    [self addFormatMenuToMenubar:menubar];
    [self addWindowMenuToMenubar:menubar];
    
    [NSApp setMainMenu:menubar];
    [menubar release];
}

#pragma mark - Menu Creation Methods

- (void)addApplicationMenuToMenubar:(NSMenu *)menubar {
    NSMenuItem *appMenuItem = [[NSMenuItem alloc] init];
    [menubar addItem:appMenuItem];
    
    NSMenu *appMenu = [[NSMenu alloc] initWithTitle:SNApplicationName];
    
    // About item - use custom about dialog
    NSMenuItem *aboutItem = [[NSMenuItem alloc] initWithTitle:[@"About " stringByAppendingString:SNApplicationName]
                                                       action:@selector(showAboutDialog:)
                                                keyEquivalent:@""];
    [aboutItem setTarget:_delegate];  // Target the delegate instead of NSApp
    [appMenu addItem:aboutItem];
    [aboutItem release];
    
    [appMenu addItem:[NSMenuItem separatorItem]];
    
    // Preferences
    NSMenuItem *prefsItem = [[NSMenuItem alloc] initWithTitle:@"Preferences..."
                                                       action:@selector(showPreferences:)
                                                keyEquivalent:@","];
    [prefsItem setTarget:_delegate];
    [prefsItem setTag:SNMenuItemTagPreferences];
    [appMenu addItem:prefsItem];
    [prefsItem release];
    
    [appMenu addItem:[NSMenuItem separatorItem]];
    
    // Services
    NSMenuItem *servicesItem = [[NSMenuItem alloc] initWithTitle:@"Services"
                                                          action:nil
                                                   keyEquivalent:@""];
    NSMenu *servicesMenu = [[NSMenu alloc] initWithTitle:@"Services"];
    [servicesItem setSubmenu:servicesMenu];
    [appMenu addItem:servicesItem];
    [NSApp setServicesMenu:servicesMenu];
    [servicesMenu release];
    [servicesItem release];
    
    [appMenu addItem:[NSMenuItem separatorItem]];
    
    // Hide/Show items
    NSMenuItem *hideItem = [[NSMenuItem alloc] initWithTitle:[@"Hide " stringByAppendingString:SNApplicationName]
                                                      action:@selector(hide:)
                                               keyEquivalent:@"h"];
    [hideItem setTarget:NSApp];
    [appMenu addItem:hideItem];
    [hideItem release];
    
    NSMenuItem *hideOthersItem = [[NSMenuItem alloc] initWithTitle:@"Hide Others"
                                                            action:@selector(hideOtherApplications:)
                                                     keyEquivalent:@"h"];
    [hideOthersItem setKeyEquivalentModifierMask:(NSCommandKeyMask | NSAlternateKeyMask)];
    [hideOthersItem setTarget:NSApp];
    [appMenu addItem:hideOthersItem];
    [hideOthersItem release];
    
    NSMenuItem *showAllItem = [[NSMenuItem alloc] initWithTitle:@"Show All"
                                                         action:@selector(unhideAllApplications:)
                                                  keyEquivalent:@""];
    [showAllItem setTarget:NSApp];
    [appMenu addItem:showAllItem];
    [showAllItem release];
    
    [appMenu addItem:[NSMenuItem separatorItem]];
    
    // Quit
    NSMenuItem *quitItem = [[NSMenuItem alloc] initWithTitle:[@"Quit " stringByAppendingString:SNApplicationName]
                                                      action:@selector(terminate:)
                                               keyEquivalent:@"q"];
    [quitItem setTarget:NSApp];
    [appMenu addItem:quitItem];
    [quitItem release];
    
    [appMenuItem setSubmenu:appMenu];
    [appMenu release];
    [appMenuItem release];
}

- (void)addFileMenuToMenubar:(NSMenu *)menubar {
    NSMenuItem *fileMenuItem = [[NSMenuItem alloc] initWithTitle:@"File" action:nil keyEquivalent:@""];
    NSMenu *fileMenu = [[NSMenu alloc] initWithTitle:@"File"];
    
    // New Note
    NSMenuItem *newNoteItem = [[NSMenuItem alloc] initWithTitle:@"New Note"
                                                         action:@selector(createNewNote:)
                                                  keyEquivalent:@"n"];
    [newNoteItem setTarget:_delegate];
    [newNoteItem setTag:SNMenuItemTagNewNote];
    [fileMenu addItem:newNoteItem];
    [newNoteItem release];
    
    [fileMenu addItem:[NSMenuItem separatorItem]];
    
    // Close Window
    NSMenuItem *closeItem = [[NSMenuItem alloc] initWithTitle:@"Close Window"
                                                       action:@selector(performClose:)
                                                keyEquivalent:@"w"];
    [fileMenu addItem:closeItem];
    [closeItem release];
    
    [fileMenuItem setSubmenu:fileMenu];
    [menubar addItem:fileMenuItem];
    [fileMenu release];
    [fileMenuItem release];
}

- (void)addEditMenuToMenubar:(NSMenu *)menubar {
    NSMenuItem *editMenuItem = [[NSMenuItem alloc] initWithTitle:@"Edit" action:nil keyEquivalent:@""];
    NSMenu *editMenu = [[NSMenu alloc] initWithTitle:@"Edit"];
    
    // Standard edit operations
    NSMenuItem *undoItem = [[NSMenuItem alloc] initWithTitle:@"Undo"
                                                      action:@selector(undo:)
                                               keyEquivalent:@"z"];
    [editMenu addItem:undoItem];
    [undoItem release];
    
    NSMenuItem *redoItem = [[NSMenuItem alloc] initWithTitle:@"Redo"
                                                      action:@selector(redo:)
                                               keyEquivalent:@"Z"];
    [editMenu addItem:redoItem];
    [redoItem release];
    
    [editMenu addItem:[NSMenuItem separatorItem]];
    
    NSMenuItem *cutItem = [[NSMenuItem alloc] initWithTitle:@"Cut"
                                                     action:@selector(cut:)
                                              keyEquivalent:@"x"];
    [editMenu addItem:cutItem];
    [cutItem release];
    
    NSMenuItem *copyItem = [[NSMenuItem alloc] initWithTitle:@"Copy"
                                                      action:@selector(copy:)
                                               keyEquivalent:@"c"];
    [editMenu addItem:copyItem];
    [copyItem release];
    
    NSMenuItem *pasteItem = [[NSMenuItem alloc] initWithTitle:@"Paste"
                                                       action:@selector(paste:)
                                                keyEquivalent:@"v"];
    [editMenu addItem:pasteItem];
    [pasteItem release];
    
    NSMenuItem *deleteItem = [[NSMenuItem alloc] initWithTitle:@"Delete"
                                                        action:@selector(delete:)
                                                 keyEquivalent:@""];
    [editMenu addItem:deleteItem];
    [deleteItem release];
    
    [editMenu addItem:[NSMenuItem separatorItem]];
    
    NSMenuItem *selectAllItem = [[NSMenuItem alloc] initWithTitle:@"Select All"
                                                           action:@selector(selectAll:)
                                                    keyEquivalent:@"a"];
    [editMenu addItem:selectAllItem];
    [selectAllItem release];
    
    [editMenuItem setSubmenu:editMenu];
    [menubar addItem:editMenuItem];
    [editMenu release];
    [editMenuItem release];
}

- (void)addFormatMenuToMenubar:(NSMenu *)menubar {
    NSMenuItem *formatMenuItem = [[NSMenuItem alloc] initWithTitle:@"Format" action:nil keyEquivalent:@""];
    NSMenu *formatMenu = [[NSMenu alloc] initWithTitle:@"Format"];
    
    // Font Size controls
    NSMenuItem *incFontItem = [[NSMenuItem alloc] initWithTitle:@"Bigger"
                                                         action:@selector(increaseFontSize:)
                                                  keyEquivalent:@"="];
    [incFontItem setTarget:_delegate];
    [incFontItem setTag:SNMenuItemTagIncreaseFontSize];
    [formatMenu addItem:incFontItem];
    [incFontItem release];
    
    NSMenuItem *decFontItem = [[NSMenuItem alloc] initWithTitle:@"Smaller"
                                                         action:@selector(decreaseFontSize:)
                                                  keyEquivalent:@"-"];
    [decFontItem setTarget:_delegate];
    [decFontItem setTag:SNMenuItemTagDecreaseFontSize];
    [formatMenu addItem:decFontItem];
    [decFontItem release];
    
    [formatMenu addItem:[NSMenuItem separatorItem]];
    
    // Standard text formatting
    NSMenuItem *boldItem = [[NSMenuItem alloc] initWithTitle:@"Bold"
                                                      action:@selector(toggleBold:)
                                               keyEquivalent:@"b"];
    [boldItem setTag:SNMenuItemTagBold];
    [formatMenu addItem:boldItem];
    [boldItem release];
    
    NSMenuItem *italicItem = [[NSMenuItem alloc] initWithTitle:@"Italic"
                                                        action:@selector(toggleItalic:)
                                                 keyEquivalent:@"i"];
    [italicItem setTag:SNMenuItemTagItalic];
    [formatMenu addItem:italicItem];
    [italicItem release];
    
    NSMenuItem *underlineItem = [[NSMenuItem alloc] initWithTitle:@"Underline"
                                                           action:@selector(toggleUnderline:)
                                                    keyEquivalent:@"u"];
    [underlineItem setTag:SNMenuItemTagUnderline];
    [formatMenu addItem:underlineItem];
    [underlineItem release];
    
    [formatMenuItem setSubmenu:formatMenu];
    [menubar addItem:formatMenuItem];
    [formatMenu release];
    [formatMenuItem release];
}

- (void)addWindowMenuToMenubar:(NSMenu *)menubar {
    NSMenuItem *windowMenuItem = [[NSMenuItem alloc] initWithTitle:@"Window" action:nil keyEquivalent:@""];
    NSMenu *windowMenu = [[NSMenu alloc] initWithTitle:@"Window"];
    
    NSMenuItem *minimizeItem = [[NSMenuItem alloc] initWithTitle:@"Minimize"
                                                          action:@selector(performMiniaturize:)
                                                   keyEquivalent:@"m"];
    [windowMenu addItem:minimizeItem];
    [minimizeItem release];
    
    NSMenuItem *zoomItem = [[NSMenuItem alloc] initWithTitle:@"Zoom"
                                                      action:@selector(performZoom:)
                                               keyEquivalent:@""];
    [windowMenu addItem:zoomItem];
    [zoomItem release];
    
    [windowMenu addItem:[NSMenuItem separatorItem]];
    
    NSMenuItem *bringAllToFrontItem = [[NSMenuItem alloc] initWithTitle:@"Bring All to Front"
                                                                 action:@selector(arrangeInFront:)
                                                          keyEquivalent:@""];
    [bringAllToFrontItem setTarget:NSApp];
    [windowMenu addItem:bringAllToFrontItem];
    [bringAllToFrontItem release];
    
    [windowMenuItem setSubmenu:windowMenu];
    [menubar addItem:windowMenuItem];
    
    // Set as the windows menu for the application
    [NSApp setWindowsMenu:windowMenu];
    
    [windowMenu release];
    [windowMenuItem release];
}

@end
