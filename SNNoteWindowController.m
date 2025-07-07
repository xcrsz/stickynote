//
//  SNNoteWindowController.m - CLEAN VERSION
//  Minimal gap approach with normal window functionality
//

#import "SNNoteWindowController.h"
#import "SNColorTheme.h"
#import "SNConstants.h"

@interface SNNoteWindowController ()
@property (retain) NSTextView *textView;
@property (retain) NSScrollView *scrollView;
@property (nonatomic, retain) SNColorTheme *currentTheme;
@end

@implementation SNNoteWindowController

- (instancetype)init {
    return [self initWithText:@"" 
                     fontSize:SNDefaultFontSize 
              backgroundColor:[SNColorTheme defaultTheme].backgroundColor];
}

- (instancetype)initWithText:(NSString *)text {
    return [self initWithText:text 
                     fontSize:SNDefaultFontSize 
              backgroundColor:[SNColorTheme defaultTheme].backgroundColor];
}

- (instancetype)initWithText:(NSString *)text 
                    fontSize:(float)size 
             backgroundColor:(NSColor *)bg {
    
    NSRect frame = NSMakeRect(200, 200, SNDefaultWindowWidth, SNDefaultWindowHeight);
    NSUInteger styleMask = NSWindowStyleMaskTitled |
                           NSWindowStyleMaskClosable |
                           NSWindowStyleMaskResizable;
    
    NSWindow *window = [[NSWindow alloc] initWithContentRect:frame
                                                   styleMask:styleMask
                                                     backing:NSBackingStoreBuffered
                                                       defer:NO];
    
    self = [super initWithWindow:window];
    if (self) {
        _currentTheme = [[SNColorTheme defaultTheme] retain];
        
        [self setupTextViewWithText:text fontSize:size backgroundColor:bg];
        [self configureWindow];
        [self findAndApplyThemeForBackgroundColor:bg];
        
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(windowWillClose:)
                   name:NSWindowWillCloseNotification
                 object:window];
    }
    
    [window release];
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_textView release];
    [_scrollView release];
    [_currentTheme release];
    [super dealloc];
}

#pragma mark - Setup

- (void)setupTextViewWithText:(NSString *)text 
                     fontSize:(float)size 
              backgroundColor:(NSColor *)bg {
    
    NSView *contentView = [[self window] contentView];
    
    // Simple, clean approach - fill content area exactly
    _scrollView = [[NSScrollView alloc] initWithFrame:[contentView bounds]];
    [_scrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    [_scrollView setHasVerticalScroller:YES];
    [_scrollView setHasHorizontalScroller:NO];
    [_scrollView setBorderType:NSNoBorder];
    [_scrollView setBackgroundColor:bg];
    [_scrollView setDrawsBackground:YES];
    
    // Create text view
    NSRect textFrame = [[_scrollView contentView] bounds];
    _textView = [[NSTextView alloc] initWithFrame:textFrame];
    
    // Configure text view
    [_textView setMinSize:NSMakeSize(0.0, 0.0)];
    [_textView setMaxSize:NSMakeSize(FLT_MAX, FLT_MAX)];
    [_textView setVerticallyResizable:YES];
    [_textView setHorizontallyResizable:NO];
    [_textView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
    [[_textView textContainer] setContainerSize:NSMakeSize(FLT_MAX, FLT_MAX)];
    [[_textView textContainer] setWidthTracksTextView:YES];
    [_textView setFont:[NSFont systemFontOfSize:size]];
    [_textView setBackgroundColor:bg];
    [_textView setDrawsBackground:YES];
    [_textView setRichText:YES];
    [_textView setAllowsUndo:YES];
    [_textView setUsesFontPanel:YES];
    
    // Nice padding for readability
    [[_textView textContainer] setLineFragmentPadding:0.0];
    [_textView setTextContainerInset:NSMakeSize(6.0, 6.0)];
    
    if (text && [text length] > 0) {
        [_textView setString:text];
    }
    
    // Clean hierarchy
    [_scrollView setDocumentView:_textView];
    [contentView addSubview:_scrollView];
}

- (void)configureWindow {
    NSWindow *window = [self window];
    [window setTitle:@"Sticky Note"];
    [window setMinSize:NSMakeSize(SNMinimumWindowWidth, SNMinimumWindowHeight)];
    [window setLevel:NSFloatingWindowLevel];
    [window setAlphaValue:0.95];
}

- (void)findAndApplyThemeForBackgroundColor:(NSColor *)bgColor {
    NSArray *themes = [SNColorTheme availableThemes];
    for (SNColorTheme *theme in themes) {
        if ([self colorsAreEqual:bgColor to:theme.backgroundColor]) {
            [self applyColorTheme:theme];
            return;
        }
    }
    [self applyColorTheme:[SNColorTheme defaultTheme]];
}

- (BOOL)colorsAreEqual:(NSColor *)color1 to:(NSColor *)color2 {
    if (!color1 || !color2) return NO;
    
    NSColor *rgb1 = [color1 colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    NSColor *rgb2 = [color2 colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    
    if (!rgb1 || !rgb2) return NO;
    
    CGFloat r1, g1, b1, a1;
    CGFloat r2, g2, b2, a2;
    
    [rgb1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [rgb2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    const CGFloat tolerance = 0.01;
    return (fabs(r1 - r2) < tolerance && 
            fabs(g1 - g2) < tolerance && 
            fabs(b1 - b2) < tolerance && 
            fabs(a1 - a2) < tolerance);
}

#pragma mark - Content Access

- (NSString *)noteText {
    return [_textView string];
}

#pragma mark - Font Operations

- (void)increaseFontSize:(id)sender {
    NSFont *currentFont = [_textView font];
    CGFloat newSize = MIN([currentFont pointSize] + 1, SNMaximumFontSize);
    [self setFontSize:newSize];
}

- (void)decreaseFontSize:(id)sender {
    NSFont *currentFont = [_textView font];
    CGFloat newSize = MAX([currentFont pointSize] - 1, SNMinimumFontSize);
    [self setFontSize:newSize];
}

- (void)setFontSize:(float)fontSize {
    NSFont *currentFont = [_textView font];
    NSFont *newFont = [NSFont fontWithName:[currentFont fontName] size:fontSize];
    if (newFont) {
        [_textView setFont:newFont];
        
        NSRange selectedRange = [_textView selectedRange];
        if (selectedRange.length > 0) {
            NSMutableAttributedString *attrString = [[_textView textStorage] mutableCopy];
            [attrString addAttribute:NSFontAttributeName 
                               value:newFont 
                               range:selectedRange];
            [[_textView textStorage] setAttributedString:attrString];
            [attrString release];
        }
        
        [self applyColorTheme:_currentTheme];
    }
}

#pragma mark - Appearance

- (void)applyColorTheme:(SNColorTheme *)theme {
    if (!theme) return;
    
    if (_currentTheme != theme) {
        [_currentTheme release];
        _currentTheme = [theme retain];
    }
    
    // Apply colors to all available components
    [_textView setBackgroundColor:theme.backgroundColor];
    [_scrollView setBackgroundColor:theme.backgroundColor];
    [[_scrollView contentView] setBackgroundColor:theme.backgroundColor];
    [[self window] setBackgroundColor:theme.backgroundColor];
    
    [self applyTextColor:theme.textColor];
    [_textView setInsertionPointColor:theme.textColor];
    
    [_textView setSelectedTextAttributes:@{
        NSBackgroundColorAttributeName: [self contrastingColorFor:theme.backgroundColor],
        NSForegroundColorAttributeName: theme.backgroundColor
    }];
}

- (void)applyTextColor:(NSColor *)textColor {
    if (!textColor) return;
    
    NSMutableAttributedString *attributedString = [[_textView textStorage] mutableCopy];
    NSRange fullRange = NSMakeRange(0, [attributedString length]);
    
    if (fullRange.length > 0) {
        [attributedString removeAttribute:NSForegroundColorAttributeName range:fullRange];
        [attributedString addAttribute:NSForegroundColorAttributeName 
                                 value:textColor 
                                 range:fullRange];
        [[_textView textStorage] setAttributedString:attributedString];
    }
    [attributedString release];
    
    [_textView setTextColor:textColor];
    
    NSMutableDictionary *typingAttributes = [[[_textView typingAttributes] mutableCopy] autorelease];
    if (!typingAttributes) {
        typingAttributes = [NSMutableDictionary dictionary];
    }
    [typingAttributes setObject:textColor forKey:NSForegroundColorAttributeName];
    [_textView setTypingAttributes:typingAttributes];
}

- (NSColor *)contrastingColorFor:(NSColor *)backgroundColor {
    NSColor *rgbColor = [backgroundColor colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    if (!rgbColor) return [NSColor lightGrayColor];
    
    CGFloat r, g, b, a;
    [rgbColor getRed:&r green:&g blue:&b alpha:&a];
    
    CGFloat luminance = 0.299 * r + 0.587 * g + 0.114 * b;
    
    if (luminance < 0.5) {
        return [NSColor lightGrayColor];
    } else {
        return [NSColor darkGrayColor];
    }
}

- (void)setBackgroundColor:(NSColor *)color {
    if (color) {
        [_textView setBackgroundColor:color];
        [_scrollView setBackgroundColor:color];
        [[_scrollView contentView] setBackgroundColor:color];
        [[self window] setBackgroundColor:color];
        
        [self findAndApplyThemeForBackgroundColor:color];
    }
}

#pragma mark - Window Delegate Methods

- (void)windowWillClose:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter]
        postNotificationName:SNNoteWillCloseNotification
                      object:self];
}

- (void)windowDidBecomeKey:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter]
        postNotificationName:SNNoteDidBecomeActiveNotification
                      object:self];
    [self applyColorTheme:_currentTheme];
}

#pragma mark - First Responder

- (void)showWindow:(id)sender {
    [super showWindow:sender];
    [[self window] makeFirstResponder:_textView];
    [self applyColorTheme:_currentTheme];
}

#pragma mark - NSResponder Methods

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    SEL action = [menuItem action];
    
    if (action == @selector(increaseFontSize:)) {
        NSFont *font = [_textView font];
        return font && [font pointSize] < SNMaximumFontSize;
    } else if (action == @selector(decreaseFontSize:)) {
        NSFont *font = [_textView font];
        return font && [font pointSize] > SNMinimumFontSize;
    }
    
    return YES;
}

#pragma mark - Theme Management

- (SNColorTheme *)currentTheme {
    return _currentTheme;
}

@end
