# stickynote

A professional sticky notes application for GNUstep with enhanced UI and modern features.

## About

stickynote is a feature-rich sticky notes application designed for GNUstep environments like GhostBSD. It provides a clean, professional interface with advanced functionality while maintaining the lightweight nature expected from desktop utilities.

## Author

**Vic Thacker**

## License

BSD 3-Clause License (see LICENSE file for details)

## Version

0.0.1 - Initial release

## Features

### Enhanced User Interface
- **Visual color swatches** in theme selection dropdown with text preview
- **Professional preferences window** with real-time validation
- **Six color themes** including dark mode support with proper text colors
- **Floating note windows** with transparency effects

### Advanced Functionality
- **Auto-save** with configurable intervals (10-3600 seconds)
- **Batch font size operations** across all notes
- **Professional preferences management** with validation
- **Automatic note positioning** in cascade pattern
- **Persistent note storage** with error handling

### Text Color Support
- **Enhanced dark theme** with white text on dark background
- **Automatic text color application** for all themes
- **Smart contrast selection** for better readability
- **Consistent color behavior** across all note operations

### Professional Architecture
- **Single Responsibility Principle** compliance
- **Clean separation of concerns** (Model-View-Controller)
- **Memory management** with proper retain/release patterns
- **Professional naming conventions** with SN prefix
- **Comprehensive error handling** throughout

### GNUstep Compatibility
- **No external dependencies** beyond GNUstep frameworks
- **Standard Foundation/AppKit** usage only
- **Thread-safe singleton** patterns
- **Proper GNUstep build integration**

## System Requirements

- GNUstep development environment
- GNUstep GUI and Base libraries
- clang or gcc compiler
- gmake

### Tested On
- GhostBSD with GNUstep
- FreeBSD with GNUstep

## Building

### Quick Build
```bash
gmake
```

### Debug Build
```bash
gmake debug
```

### Release Build
```bash
gmake release
```

### Clean Build
```bash
gmake clean-all
gmake
```

## Installation

### System Installation
```bash
gmake install
```

### User Installation
```bash
gmake install-user
```

This installs to `~/GNUstep/Applications/stickynote.app`

## Usage

### Basic Operations
- **New Note**: File → New Note (⌘N)
- **Font Size**: Format → Bigger/Smaller (⌘+/⌘-)
- **Preferences**: Sticky Note → Preferences (⌘,)

### Command Line
The application can also be launched from command line:
```bash
sn
```

### Preferences
- **Font Size**: Adjustable from 8-72pt with real-time preview
- **Color Themes**: Six themes with visual swatches showing text and background colors
- **Auto-Save**: Configurable intervals with validation
- **Reset**: Restore all settings to defaults

### Color Themes
- **Classic Yellow**: Traditional sticky note color with dark text
- **Soft Pink**: Gentle pink background with dark text
- **Light Blue**: Calming blue tone with dark text
- **Mint Green**: Fresh green color with dark text
- **Clean White**: Professional white background with black text
- **Dark Mode**: Dark background with white text (perfect for low-light environments)

### Auto-Save
Notes are automatically saved to `~/Library/stickynote/` when auto-save is enabled. The application restores all notes on startup.

## File Structure

```
stickynote/
├── SNMain.m                          # Application entry point
├── SNAppDelegate.h/m                 # Application lifecycle
├── SNConstants.h/m                   # Shared constants
├── SNPreferences.h/m                 # Preferences data model
├── SNColorTheme.h/m                  # Color theme system
├── SNPreferencesWindowController.h/m # Preferences UI
├── SNNoteWindowController.h/m        # Individual note windows
├── SNNoteManager.h/m                 # Note collection management
├── SNMenuManager.h/m                 # Application menu system
├── Resources/
│   └── SNInfo.plist                  # Application metadata
├── GNUmakefile                       # Build configuration
├── LICENSE                           # BSD 3-Clause license
├── README.md                         # This file
├── Testing.md                        # Unit testing guide
└── Users-Guide.md                    # User documentation
```

## Development

### Architecture
The application follows Model-View-Controller architecture with clear separation:

- **Model**: `SNPreferences`, `SNColorTheme`
- **View**: Window controllers handle UI only
- **Controller**: Managers coordinate between model and view

### Code Quality
- Professional naming with SN prefix
- Comprehensive error handling
- Memory leak prevention
- Input validation throughout
- Thread-safe implementations

### Adding Features
The modular architecture makes it easy to extend:
- Add new color themes in `SNColorTheme.m`
- Add preferences in `SNPreferences.h/m`
- Add menu items in `SNMenuManager.m`
- Add note features in `SNNoteWindowController.m`

## Testing

### Unit Tests
stickynote includes comprehensive unit tests using UnitKit:

```bash
# Check if testing is available
gmake check-unitkit

# Run all tests (requires UnitKit)
gmake test

# Run with verbose output
gmake test-verbose
```

### Test Coverage
- **SNPreferences**: ~95% coverage
- **SNColorTheme**: ~90% coverage  
- **SNConstants**: ~100% coverage
- **SNNoteManager**: ~85% coverage

See `Testing.md` for detailed testing information.

## Troubleshooting

### Build Issues
```bash
# Check syntax
gmake check-syntax

# Clean build
gmake clean-all
gmake debug
```

### Runtime Issues
- Check console output for error messages
- Verify GNUstep installation
- Ensure proper file permissions for save directory

### Missing Features
This is version 0.0.1 - future versions may include:
- Rich text formatting enhancements
- Note tagging and search
- Export/import functionality
- Network synchronization
- Plugin architecture

## Contributing

This project follows professional development practices:
- Clear commit messages
- Consistent code style
- Comprehensive testing
- Documentation updates

## Version History

### 0.0.1 (Initial Release)
- Six color themes with proper text color support
- Enhanced dark mode with white text
- Professional preferences interface
- Auto-save functionality
- Comprehensive unit test suite
- Complete documentation

## Acknowledgments

Built using GNUstep frameworks and following Objective-C/Cocoa design patterns.

## Contact

For questions or contributions, please refer to the project repository or contact the author.

---

*stickynote v0.0.1 by Vic Thacker - Professional sticky notes for GNUstep*  
*Licensed under BSD 3-Clause License*
