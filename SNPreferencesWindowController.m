//
//  SNPreferencesWindowController.m
//  stickynote
//
//  Preferences window user interface controller
//  Enhanced with better layout and text color swatches
//

#import "SNPreferencesWindowController.h"
#import "SNPreferences.h"
#import "SNColorTheme.h"
#import "SNConstants.h"

@interface SNPreferencesWindowController ()

@property (retain) NSPanel *panel;
@property (retain) NSSlider *fontSlider;
@property (retain) NSTextField *fontSizeLabel;
@property (retain) NSPopUpButton *colorThemeMenu;
@property (retain) NSButton *autoSaveCheckbox;
@property (retain) NSTextField *autoSaveIntervalField;
@property (retain) NSButton *resetButton;
@property (retain) NSButton *applyButton;
@property (retain) SNPreferences *preferences;

@end

@implementation SNPreferencesWindowController

- (instancetype)initWithPreferences:(SNPreferences *)preferences {
    self = [super initWithWindow:nil];
    if (self) {
        _preferences = [preferences retain];
        [self createPreferencesWindow];
        [self setupControls];
        [self updateUI];
        
        // Listen for model changes
        [[NSNotificationCenter defaultCenter] 
            addObserver:self 
               selector:@selector(preferencesDidChange:)
                   name:SNPreferencesDidChangeNotification 
                 object:_preferences];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_preferences release];
    [_panel release];
    [_fontSlider release];
    [_fontSizeLabel release];
    [_colorThemeMenu release];
    [_autoSaveCheckbox release];
    [_autoSaveIntervalField release];
    [_resetButton release];
    [_applyButton release];
    [super dealloc];
}

#pragma mark - Window Creation

- (void)createPreferencesWindow {
    // Increased window size to accommodate all controls properly
    _panel = [[NSPanel alloc] initWithContentRect:NSMakeRect(200, 200, 480, 420)
                                        styleMask:(NSTitledWindowMask | NSClosableWindowMask)
                                          backing:NSBackingStoreBuffered
                                            defer:NO];
    [_panel setTitle:@"Preferences"];
    [_panel setLevel:NSFloatingWindowLevel];
    [self setWindow:_panel];
}

- (void)setupControls {
    NSView *contentView = [_panel contentView];
    
    // Start from top and work down with proper spacing
    CGFloat yPos = 370;  // Start higher in the taller window
    const CGFloat sectionSpacing = 28;
    const CGFloat controlSpacing = 45;
    
    // Font Size Section
    [self addSectionHeader:@"Font Settings" atY:yPos inView:contentView];
    yPos -= sectionSpacing;
    
    [self addFontControlsAtY:yPos inView:contentView];
    yPos -= controlSpacing;
    
    // Color Theme Section
    [self addSectionHeader:@"Color Theme" atY:yPos inView:contentView];
    yPos -= sectionSpacing;
    
    [self addColorThemeControlsAtY:yPos inView:contentView];
    yPos -= controlSpacing;
    
    // Auto-Save Section
    [self addSectionHeader:@"Auto-Save Settings" atY:yPos inView:contentView];
    yPos -= sectionSpacing;
    
    [self addAutoSaveControlsAtY:yPos inView:contentView];
    yPos -= controlSpacing;
    
    // Action Buttons - ensure they're visible with proper margin
    CGFloat buttonY = MAX(yPos, 25);  // At least 25px from bottom
    [self addActionButtonsAtY:buttonY inView:contentView];
}

- (void)addSectionHeader:(NSString *)title atY:(CGFloat)y inView:(NSView *)view {
    NSTextField *header = [[NSTextField alloc] initWithFrame:NSMakeRect(20, y, 440, 20)];
    [header setStringValue:title];
    [header setBezeled:NO];
    [header setDrawsBackground:NO];
    [header setEditable:NO];
    [header setSelectable:NO];
    [header setFont:[NSFont boldSystemFontOfSize:13]];
    [header setTextColor:[NSColor controlTextColor]];
    [view addSubview:header];
    [header release];
}

- (void)addFontControlsAtY:(CGFloat)y inView:(NSView *)view {
    // Font size label
    NSTextField *fontLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(30, y, 100, 20)];
    [fontLabel setStringValue:@"Font Size:"];
    [fontLabel setBezeled:NO];
    [fontLabel setDrawsBackground:NO];
    [fontLabel setEditable:NO];
    [fontLabel setSelectable:NO];
    [view addSubview:fontLabel];
    [fontLabel release];
    
    // Font size slider - made wider
    _fontSlider = [[NSSlider alloc] initWithFrame:NSMakeRect(140, y, 220, 20)];
    [_fontSlider setMinValue:SNMinimumFontSize];
    [_fontSlider setMaxValue:SNMaximumFontSize];
    [_fontSlider setTarget:self];
    [_fontSlider setAction:@selector(fontSliderChanged:)];
    [view addSubview:_fontSlider];
    
    // Font size display - repositioned for wider window
    _fontSizeLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(370, y, 80, 20)];
    [_fontSizeLabel setBezeled:NO];
    [_fontSizeLabel setDrawsBackground:NO];
    [_fontSizeLabel setEditable:NO];
    [_fontSizeLabel setSelectable:NO];
    [_fontSizeLabel setAlignment:NSCenterTextAlignment];
    [_fontSizeLabel setFont:[NSFont systemFontOfSize:11]];
    [view addSubview:_fontSizeLabel];
}

- (void)addColorThemeControlsAtY:(CGFloat)y inView:(NSView *)view {
    NSTextField *colorLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(30, y, 100, 20)];
    [colorLabel setStringValue:@"Theme:"];
    [colorLabel setBezeled:NO];
    [colorLabel setDrawsBackground:NO];
    [colorLabel setEditable:NO];
    [colorLabel setSelectable:NO];
    [view addSubview:colorLabel];
    [colorLabel release];
    
    // Color theme dropdown - wider to show theme names and swatches properly
    _colorThemeMenu = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(140, y-2, 280, 24) pullsDown:NO];
    [self populateColorThemeMenu];
    [_colorThemeMenu setTarget:self];
    [_colorThemeMenu setAction:@selector(colorThemeChanged:)];
    [view addSubview:_colorThemeMenu];
}

- (void)addAutoSaveControlsAtY:(CGFloat)y inView:(NSView *)view {
    // Auto-save checkbox
    _autoSaveCheckbox = [[NSButton alloc] initWithFrame:NSMakeRect(30, y, 180, 20)];
    [_autoSaveCheckbox setButtonType:NSSwitchButton];
    [_autoSaveCheckbox setTitle:@"Enable Auto-Save"];
    [_autoSaveCheckbox setTarget:self];
    [_autoSaveCheckbox setAction:@selector(autoSaveToggled:)];
    [view addSubview:_autoSaveCheckbox];
    
    // Interval label
    NSTextField *intervalLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(240, y, 100, 20)];
    [intervalLabel setStringValue:@"Interval (sec):"];
    [intervalLabel setBezeled:NO];
    [intervalLabel setDrawsBackground:NO];
    [intervalLabel setEditable:NO];
    [intervalLabel setSelectable:NO];
    [view addSubview:intervalLabel];
    [intervalLabel release];
    
    // Interval field
    _autoSaveIntervalField = [[NSTextField alloc] initWithFrame:NSMakeRect(350, y, 100, 20)];
    [_autoSaveIntervalField setTarget:self];
    [_autoSaveIntervalField setAction:@selector(autoSaveIntervalChanged:)];
    [view addSubview:_autoSaveIntervalField];
}

- (void)addActionButtonsAtY:(CGFloat)y inView:(NSView *)view {
    // Make buttons larger and properly positioned
    const CGFloat buttonWidth = 100;
    const CGFloat buttonHeight = 34;
    const CGFloat buttonSpacing = 20;
    
    // Center the buttons horizontally in the window
    CGFloat windowWidth = [view frame].size.width;
    CGFloat totalWidth = (buttonWidth * 2) + buttonSpacing;
    CGFloat startX = (windowWidth - totalWidth) / 2;
    
    // Reset button
    _resetButton = [[NSButton alloc] initWithFrame:NSMakeRect(startX, y, buttonWidth, buttonHeight)];
    [_resetButton setTitle:@"Reset"];
    [_resetButton setTarget:self];
    [_resetButton setAction:@selector(resetToDefaults:)];
    [view addSubview:_resetButton];
    
    // Apply button
    _applyButton = [[NSButton alloc] initWithFrame:NSMakeRect(startX + buttonWidth + buttonSpacing, y, buttonWidth, buttonHeight)];
    [_applyButton setTitle:@"Apply"];
    [_applyButton setTarget:self];
    [_applyButton setAction:@selector(applyAndSave:)];
    [view addSubview:_applyButton];
    
    // Make Apply button the default (responds to Enter key)
    [_applyButton setKeyEquivalent:@"\r"];
}

#pragma mark - Color Theme Menu Management

- (void)populateColorThemeMenu {
    [_colorThemeMenu removeAllItems];
    
    NSArray<SNColorTheme *> *themes = [SNColorTheme availableThemes];
    for (SNColorTheme *theme in themes) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:theme.displayName 
                                                      action:nil 
                                               keyEquivalent:@""];
        [item setRepresentedObject:theme];
        
        // Add a color swatch to the menu item
        [self addColorSwatchToMenuItem:item withTheme:theme];
        
        [[_colorThemeMenu menu] addItem:item];
        [item release];
    }
}

- (void)addColorSwatchToMenuItem:(NSMenuItem *)item withTheme:(SNColorTheme *)theme {
    // Create a larger swatch to show both background and text color
    NSSize swatchSize = NSMakeSize(32, 16);
    NSImage *swatchImage = [[NSImage alloc] initWithSize:swatchSize];
    
    [swatchImage lockFocus];
    
    // Fill with background color
    [theme.backgroundColor setFill];
    NSRectFill(NSMakeRect(0, 0, swatchSize.width, swatchSize.height));
    
    // Add sample text in the theme's text color
    NSString *sampleText = @"Aa";
    NSDictionary *textAttributes = @{
        NSFontAttributeName: [NSFont systemFontOfSize:10],
        NSForegroundColorAttributeName: theme.textColor
    };
    
    NSSize textSize = [sampleText sizeWithAttributes:textAttributes];
    NSPoint textPoint = NSMakePoint(
        (swatchSize.width - textSize.width) / 2,
        (swatchSize.height - textSize.height) / 2
    );
    
    [sampleText drawAtPoint:textPoint withAttributes:textAttributes];
    
    // Add border
    [[NSColor grayColor] setStroke];
    [NSBezierPath setDefaultLineWidth:1.0];
    [NSBezierPath strokeRect:NSMakeRect(0.5, 0.5, swatchSize.width-1, swatchSize.height-1)];
    
    [swatchImage unlockFocus];
    
    [item setImage:swatchImage];
    [swatchImage release];
}

#pragma mark - UI Updates

- (void)updateUI {
    [_fontSlider setFloatValue:_preferences.defaultFontSize];
    [_fontSizeLabel setStringValue:[NSString stringWithFormat:@"%.0f pt", _preferences.defaultFontSize]];
    
    // Select the correct color theme
    NSArray *items = [[_colorThemeMenu menu] itemArray];
    for (NSMenuItem *item in items) {
        SNColorTheme *theme = [item representedObject];
        if ([theme.name isEqualToString:_preferences.defaultColorTheme.name]) {
            [_colorThemeMenu selectItem:item];
            break;
        }
    }
    
    [_autoSaveCheckbox setState:_preferences.autoSaveEnabled ? NSOnState : NSOffState];
    [_autoSaveIntervalField setStringValue:[NSString stringWithFormat:@"%lu", 
                                           (unsigned long)_preferences.autoSaveInterval]];
    [_autoSaveIntervalField setEnabled:_preferences.autoSaveEnabled];
}

#pragma mark - Action Methods

- (void)fontSliderChanged:(id)sender {
    float newSize = [_fontSlider floatValue];
    _preferences.defaultFontSize = newSize;
    [_fontSizeLabel setStringValue:[NSString stringWithFormat:@"%.0f pt", newSize]];
}

- (void)colorThemeChanged:(id)sender {
    // GNUstep compatible: cast to NSMenuItem since selectedItem returns id<NSMenuItem>
    id<NSMenuItem> selectedItemProtocol = [_colorThemeMenu selectedItem];
    NSMenuItem *selectedItem = (NSMenuItem *)selectedItemProtocol;
    SNColorTheme *theme = [selectedItem representedObject];
    if (theme) {
        _preferences.defaultColorTheme = theme;
    }
}

- (void)autoSaveToggled:(id)sender {
    BOOL enabled = ([_autoSaveCheckbox state] == NSOnState);
    _preferences.autoSaveEnabled = enabled;
    [_autoSaveIntervalField setEnabled:enabled];
}

- (void)autoSaveIntervalChanged:(id)sender {
    NSUInteger interval = [[_autoSaveIntervalField stringValue] integerValue];
    if (interval >= SNMinAutoSaveInterval && interval <= SNMaxAutoSaveInterval) {
        _preferences.autoSaveInterval = interval;
    } else {
        // Reset to valid value if out of range
        [_autoSaveIntervalField setStringValue:[NSString stringWithFormat:@"%lu", 
                                               (unsigned long)_preferences.autoSaveInterval]];
        
        // Show validation message
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Invalid Auto-Save Interval"];
        [alert setInformativeText:[NSString stringWithFormat:
                                  @"Please enter a value between %lu and %lu seconds.", 
                                  (unsigned long)SNMinAutoSaveInterval,
                                  (unsigned long)SNMaxAutoSaveInterval]];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        [alert release];
    }
}

- (void)resetToDefaults:(id)sender {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Reset Preferences"];
    [alert setInformativeText:@"Are you sure you want to reset all preferences to their default values?"];
    [alert addButtonWithTitle:@"Reset"];
    [alert addButtonWithTitle:@"Cancel"];
    
    NSInteger response = [alert runModal];
    [alert release];
    
    if (response == NSAlertFirstButtonReturn) {
        [_preferences resetToDefaults];
        [self updateUI];
    }
}

- (void)applyAndSave:(id)sender {
    [_preferences saveDefaults];
    
    // Provide visual feedback
    NSString *originalTitle = [_applyButton title];
    [_applyButton setTitle:@"Saved!"];
    [_applyButton setEnabled:NO];
    
    // Reset button state after delay using GNUstep compatible method
    [self performSelector:@selector(resetApplyButton:) 
               withObject:originalTitle 
               afterDelay:1.5];
}

- (void)resetApplyButton:(NSString *)originalTitle {
    [_applyButton setTitle:originalTitle];
    [_applyButton setEnabled:YES];
}

#pragma mark - Notifications

- (void)preferencesDidChange:(NSNotification *)notification {
    [self updateUI];
}

#pragma mark - Window Management

- (void)showWindow:(id)sender {
    [_preferences loadDefaults]; // Refresh from disk
    [self updateUI];
    [super showWindow:sender];
    [_panel center];
    [_panel makeKeyAndOrderFront:nil];
}

- (BOOL)windowShouldClose:(id)sender {
    // Auto-save when closing preferences
    [_preferences saveDefaults];
    return YES;
}

@end
