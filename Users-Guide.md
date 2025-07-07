# stickynote User Guide

**Version 0.0.1**  
**Author: Vic Thacker**  
**Licensed under BSD 3-Clause License**  
**A Sticky Notes Application for GNUstep**

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Creating Your First Note](#creating-your-first-note)
3. [Managing Multiple Notes](#managing-multiple-notes)
4. [Customizing Your Experience](#customizing-your-experience)
5. [Auto-Save Features](#auto-save-features)
6. [Keyboard Shortcuts](#keyboard-shortcuts)
7. [Menus and Options](#menus-and-options)
8. [Tips and Tricks](#tips-and-tricks)
9. [Troubleshooting](#troubleshooting)
10. [Frequently Asked Questions](#frequently-asked-questions)

---

## Getting Started

### What is stickynote?

stickynote is a modern sticky notes application designed for GNUstep environments. It allows you to create colorful, floating notes on your desktop to keep track of important information, reminders, and quick thoughts.

### First Launch

When you start stickynote for the first time:

1. **Automatic Note Creation**: A yellow sticky note will appear automatically
2. **Note Positioning**: Notes appear in a cascading pattern so they don't overlap
3. **Floating Windows**: Notes stay on top of other applications for easy visibility
4. **Ready to Type**: Click in any note and start typing immediately

### Key Features at a Glance

- **Six Beautiful Themes**: Choose from yellow, pink, blue, green, white, or dark themes
- **Visual Theme Selection**: See color swatches when picking themes
- **Auto-Save**: Your notes are automatically saved and restored
- **Adjustable Font Sizes**: Make text larger or smaller as needed
- **Professional Interface**: Clean, modern design that's easy to use

---

## Creating Your First Note

### Starting Fresh

1. **Launch stickynote**: Double-click the application icon or run `sn` from command line
2. **Begin Typing**: Click anywhere in the note window and start typing
3. **Add Content**: Type your reminder, note, or any text you want to remember

### Basic Text Operations

- **Typing**: Simply click and type - no special actions needed
- **Selecting Text**: Click and drag to select text for formatting
- **Copy/Paste**: Use standard keyboard shortcuts (⌘C, ⌘V)
- **Undo/Redo**: Standard undo (⌘Z) and redo (⌘⇧Z) work normally

### Text Formatting

stickynote supports rich text formatting:

- **Bold Text**: Select text and press ⌘B
- **Italic Text**: Select text and press ⌘I  
- **Underline**: Select text and press ⌘U
- **Font Changes**: Use the Format menu for additional options

---

## Managing Multiple Notes

### Creating Additional Notes

**Method 1: Menu**
1. Go to **File** → **New Note**
2. Or press **⌘N**

**Method 2: Command Line**
```bash
sn --new-note
```

**Method 3: When You Need It**
- stickynote is designed for multiple notes
- Create as many as you need for different topics

### Note Organization

**Automatic Positioning**
- New notes appear slightly offset from existing ones
- This creates a neat cascade effect
- You can drag notes anywhere on screen

**Window Controls**
- **Move Notes**: Click and drag the title bar
- **Resize Notes**: Drag the bottom-right corner
- **Close Notes**: Click the X button in the title bar
- **Minimize**: Use the minimize button if available

### Managing Content

**Each Note is Independent**
- Notes save their content separately
- Closing one note doesn't affect others
- Each note remembers its position and size

---

## Customizing Your Experience

### Opening Preferences

**Access Preferences**
1. Go to **Sticky Note** → **Preferences** (or press ⌘,)
2. The Preferences window will open and float above other windows

### Font Size Settings

**Adjusting Default Font Size**
1. In Preferences, find the **Font Settings** section
2. Use the slider to adjust font size (8-72 points)
3. See the live preview showing "14 pt" (or current size)
4. This affects new notes and selected text in existing notes

**Quick Font Changes**
- **Increase Font**: Format → Bigger (⌘=)
- **Decrease Font**: Format → Smaller (⌘-)
- These work on all notes at once or selected text

### Color Themes

**Choosing a Theme**
1. In Preferences, find the **Color Theme** section
2. Click the dropdown menu
3. You'll see theme names with color swatches showing both background and text color:
   - **Classic Yellow**: Traditional sticky note color with dark text
   - **Soft Pink**: Gentle pink background with dark text
   - **Light Blue**: Calming blue tone with dark text
   - **Mint Green**: Fresh green color with dark text
   - **Clean White**: Professional white background with black text
   - **Dark Mode**: Dark background with white text (perfect for low-light use)

**Theme Application**
- New notes use the selected theme automatically
- For existing notes, you'll be asked if you want to apply the new theme
- You can choose to keep current colors or update all notes

### Auto-Save Configuration

**Enable/Disable Auto-Save**
1. In Preferences, find **Auto-Save Settings**
2. Check or uncheck **Enable Auto-Save**
3. When enabled, notes save automatically at set intervals

**Setting Save Interval**
1. Enter a number in the **Interval (sec)** field
2. Valid range: 10-3600 seconds (10 seconds to 1 hour)
3. Recommended: 30-60 seconds for most users

### Applying Changes

**Save Your Settings**
1. Click **Apply** to save your preferences
2. The button will briefly show "Saved!" as confirmation
3. Settings are automatically loaded when you restart stickynote

**Reset to Defaults**
1. Click **Reset** if you want to restore original settings
2. Confirm your choice in the dialog that appears
3. All preferences return to their default values

---

## Auto-Save Features

### How Auto-Save Works

**Automatic Protection**
- Your notes are automatically saved to your home directory
- No need to manually save - it happens in the background
- Notes are restored when you restart stickynote

**Save Location**
- Files are stored in `~/Library/stickynote/`
- Each note is saved as a separate text file
- Files are named `note_001.txt`, `note_002.txt`, etc.

### Manual Save Operations

**Immediate Save**
- Auto-save triggers when you close notes
- Also saves when you change preferences
- Background saving happens at your set interval

**What Gets Saved**
- All text content in your notes
- Note positions and sizes (planned for future versions)
- Your preference settings

### Recovery Features

**Automatic Restoration**
- When you launch stickynote, all previous notes are restored
- Notes appear in the same order you created them
- Content is exactly as you left it

**Handling Crashes**
- If stickynote closes unexpectedly, auto-save protects your work
- Recent changes (within your save interval) will be preserved
- Restart the application to recover your notes

---

## Keyboard Shortcuts

### File Operations
- **⌘N** - Create New Note
- **⌘W** - Close Current Note Window
- **⌘Q** - Quit stickynote

### Text Editing
- **⌘C** - Copy selected text
- **⌘V** - Paste text
- **⌘X** - Cut selected text
- **⌘Z** - Undo last action
- **⌘⇧Z** - Redo last undone action
- **⌘A** - Select all text in current note

### Text Formatting
- **⌘B** - Bold selected text
- **⌘I** - Italic selected text  
- **⌘U** - Underline selected text

### Font Size
- **⌘=** (or ⌘+) - Increase font size for all notes
- **⌘-** - Decrease font size for all notes

### Application
- **⌘,** - Open Preferences
- **⌘M** - Minimize current window
- **⌘H** - Hide stickynote

### Window Management
- **⌘`** - Cycle through note windows
- **F11** - Show/hide all applications (system shortcut)

---

## Menus and Options

### Sticky Note Menu

**About Sticky Note**
- Shows version information, author credits, and license details
- Displays comprehensive application information including features

**Preferences**
- Opens the preferences window for customization

**Services**
- Standard GNUstep services (text processing, etc.)

**Hide/Show Options**
- Hide Sticky Note, Hide Others, Show All

**Quit Sticky Note**
- Closes the application (notes are auto-saved first)

### File Menu

**New Note**
- Creates a fresh sticky note with current theme settings

**Close Window**
- Closes the currently active note (auto-saves first)

### Edit Menu

**Standard editing commands:**
- Undo, Redo
- Cut, Copy, Paste, Delete
- Select All

### Format Menu

**Font Size**
- **Bigger**: Increases font size for all notes
- **Smaller**: Decreases font size for all notes

**Text Style**
- Bold, Italic, Underline toggles for selected text

### Window Menu

**Standard window operations:**
- Minimize, Zoom
- Bring All to Front
- List of open note windows

---

## Tips and Tricks

### Productivity Tips

**Organization Strategies**
- Use different colored themes for different types of notes
- Keep important reminders in bright colors (yellow, pink)
- Use the dark theme for longer-term reference information or late-night work

**Content Ideas**
- Daily task lists
- Phone numbers and contact info
- Temporary passwords or codes
- Meeting notes and reminders
- Shopping lists
- Quick calculations
- Inspirational quotes

**Workflow Integration**
- Keep stickynote running in the background
- Use auto-save to protect important information
- Create new notes for different projects or contexts

### Command Line Usage

**Launch Application**
```bash
sn                    # Launch stickynote
sn --new-note         # Launch and create new note
sn --help            # Show command line options
```

**Integration with Scripts**
```bash
# Add note content from script
echo "Meeting at 3pm" | sn --stdin
```

### Visual Management

**Window Positioning**
- Arrange notes on different parts of your screen
- Keep frequently-used notes in easily visible locations
- Use the automatic cascade feature for quick note creation

**Font Size Strategy**
- Use larger fonts for important or urgent items
- Smaller fonts work well for reference information
- Adjust per-note or globally based on your needs

**Theme Selection**
- Use bright themes (yellow, pink) for urgent reminders
- Use calm themes (blue, green) for reference information
- Use dark theme in low-light environments or for extended reading

### Maintenance

**Regular Cleanup**
- Close notes you no longer need
- Deleted notes are removed from auto-save
- Keep your workspace organized

**Backup Considerations**
- Your notes are stored in `~/Library/stickynote/`
- Consider backing up this folder for important information
- Auto-save handles day-to-day protection

---

## Troubleshooting

### Common Issues

**stickynote Won't Start**
1. Check that GNUstep is properly installed
2. Verify the application has execute permissions
3. Try launching from the command line to see error messages: `sn`

**Notes Disappear**
1. Check if auto-save is enabled in Preferences
2. Look in `~/Library/stickynote/` for note files
3. Restart stickynote to trigger note restoration

**Preferences Won't Save**
1. Ensure you click "Apply" after making changes
2. Check that your home directory is writable
3. Verify stickynote has permission to write files

**Font Size Problems**
1. If fonts appear too small/large, use Format menu to adjust
2. Check Preferences for the default font size setting
3. Individual notes can have different font sizes

**Color Theme Issues**
1. If themes don't apply properly, restart stickynote
2. New notes should use the selected theme automatically
3. Use the "Apply" button in preferences to update existing notes

**Dark Theme Text Visibility**
1. The dark theme should automatically use white text
2. If text appears black on dark background, apply the theme again
3. New text should automatically use the correct color

### Performance Issues

**Too Many Notes**
- stickynote handles dozens of notes efficiently
- If performance suffers, consider closing unused notes
- Large amounts of text in individual notes may slow things down

**Memory Usage**
- stickynote is designed to be lightweight
- If memory usage seems high, restart the application: `sn`
- Auto-save ensures no data loss during restarts

### File System Issues

**Save Directory Problems**
1. Check that `~/Library/` exists and is writable
2. stickynote creates the `stickynote` subdirectory automatically
3. Manual creation: `mkdir -p ~/Library/stickynote`

**Corrupted Notes**
1. Individual note files are plain text and can be manually edited
2. Remove corrupted `.txt` files from the save directory
3. stickynote will skip unreadable files during restoration

### Command Line Issues

**Command Not Found**
1. Ensure stickynote is properly installed: `gmake install`
2. Check that the installation directory is in your PATH
3. Try absolute path: `/usr/local/bin/sn`

---

## Frequently Asked Questions

### General Usage

**Q: How many notes can I create?**
A: There's no hard limit. stickynote efficiently handles dozens of notes, though very large numbers may impact performance.

**Q: Can I change the color of individual notes?**
A: Currently, themes apply to all new notes. Individual note theming may be added in future versions.

**Q: Do notes persist between restarts?**
A: Yes! Auto-save ensures all notes are restored when you restart stickynote.

**Q: Can I export my notes?**
A: Note files are stored as plain text in `~/Library/stickynote/` and can be copied or backed up manually.

**Q: Can I use stickynote from the command line?**
A: Yes! Use `sn` to launch the application. Additional command line options may be added in future versions.

### Customization

**Q: Can I add my own color themes?**
A: Custom themes aren't currently user-configurable, but the six built-in themes cover most needs including dark mode.

**Q: How do I change the default font?**
A: Use Preferences to set the default font size. Font family changes may be added in future versions.

**Q: Can I make notes stay below other windows?**
A: Notes are designed to float above other applications for visibility. This behavior isn't currently customizable.

**Q: Why can't I see text in dark mode?**
A: The dark theme should automatically use white text. If you see issues, try applying the theme again or restart the application.

### Technical

**Q: What file format are notes saved in?**
A: Plain text (.txt) files with UTF-8 encoding, making them readable by any text editor.

**Q: How often should I set auto-save?**
A: 30-60 seconds works well for most users. Shorter intervals provide more protection but use slightly more disk I/O.

**Q: Can I sync notes between computers?**
A: Not currently built-in, but you could manually sync the `~/Library/stickynote/` folder using external tools.

### Compatibility

**Q: What systems does stickynote run on?**
A: Any system with GNUstep installed, including GhostBSD, FreeBSD, and other GNUstep-compatible environments.

**Q: Does it work with other desktop environments?**
A: Yes, stickynote works with any window manager or desktop environment that supports floating windows.

**Q: Are there plans for other platforms?**
A: stickynote is designed specifically for GNUstep. Other platforms would require separate development.

---

## Getting Help

### Built-in Help
- Menu items include standard tooltips and descriptions
- Error messages provide specific guidance when issues occur
- The About dialog shows version information and credits for support requests

### Community Support
- Check the project documentation for developer information
- Report bugs or feature requests through appropriate channels
- Contribute to the project if you have programming experience

### Self-Help Resources
- This User Guide covers all current features
- The application's behavior is designed to be intuitive
- Experimentation is safe - auto-save protects your data

---

**Thank you for using stickynote!**

*This user guide covers version 0.0.1. Features and functionality may be enhanced in future releases.*

*stickynote v0.0.1 by Vic Thacker - Licensed under BSD 3-Clause License*
