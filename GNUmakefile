#
# GNUmakefile for stickynote
# A professional sticky notes application for GNUstep
# Author: Vic Thacker
#

include $(GNUSTEP_MAKEFILES)/common.make

#
# Application Configuration
#
APP_NAME = stickynote
VERSION = 0.0.1
PACKAGE_NAME = stickynote

#
# Source Files
#
stickynote_OBJC_FILES = \
	SNMain.m \
	SNAppDelegate.m \
	SNColorTheme.m \
	SNConstants.m \
	SNMenuManager.m \
	SNNoteManager.m \
	SNNoteWindowController.m \
	SNPreferences.m \
	SNPreferencesWindowController.m

#
# Headers (for dependency tracking)
#
stickynote_HEADER_FILES = \
	SNAppDelegate.h \
	SNColorTheme.h \
	SNConstants.h \
	SNMenuManager.h \
	SNNoteManager.h \
	SNNoteWindowController.h \
	SNPreferences.h \
	SNPreferencesWindowController.h

#
# Resources
#
stickynote_RESOURCE_FILES = \
	Resources/SNInfo.plist

#
# Application Info
#
stickynote_APPLICATION_ICON = 
stickynote_MAIN_MODEL_FILE = 
stickynote_PRINCIPAL_CLASS = NSApplication

#
# Compiler Settings - Fixed warnings
#
ADDITIONAL_OBJCFLAGS += -Wall -Wextra -Wno-unused-parameter
ADDITIONAL_OBJCFLAGS += -std=gnu99 -fno-strict-aliasing
ADDITIONAL_OBJCFLAGS += -DGNUSTEP

# Remove problematic ARC flag that's being added automatically
ADDITIONAL_OBJCFLAGS += -fno-objc-arc
ADDITIONAL_LDFLAGS += -fno-objc-arc

# Suppress specific warnings for GNUstep compatibility
ADDITIONAL_OBJCFLAGS += -Wno-typedef-redefinition
ADDITIONAL_OBJCFLAGS += -Wno-unused-command-line-argument

#
# Libraries
#
stickynote_GUI_LIBS += -lgnustep-gui -lgnustep-base

#
# Build Configurations
#
ifeq ($(GNUSTEP_BUILD_DIR),)
  GNUSTEP_BUILD_DIR = .
endif

#
# Installation Settings
#
GNUSTEP_INSTALLATION_DOMAIN = USER

#
# Include Application Makefile
#
include $(GNUSTEP_MAKEFILES)/application.make

#
# Custom Targets
#

# Development targets
.PHONY: debug release clean-all install-user check-syntax

debug:: 
	$(MAKE) debug=yes strip=no

release::
	$(MAKE) debug=no strip=yes

# Enhanced clean
clean-all:: clean
	rm -rf obj
	rm -rf *.app
	rm -rf *~
	rm -rf *.orig
	rm -rf core

# User installation (no sudo required)
install-user:: all
	@echo "Installing stickynote to user GNUstep domain..."
	$(MAKE) install GNUSTEP_INSTALLATION_DOMAIN=USER

# Syntax checking
check-syntax::
	@echo "Checking syntax of all source files..."
	@for file in $(stickynote_OBJC_FILES); do \
		echo "Checking $$file..."; \
		$(CC) $(ADDITIONAL_OBJCFLAGS) -fsyntax-only -c $$file || exit 1; \
	done
	@echo "Syntax check completed successfully."

# Create command-line launcher
install-launcher:: install-user
	@echo "Creating command-line launcher..."
	@mkdir -p $(HOME)/bin
	@echo '#!/bin/sh' > $(HOME)/bin/sn
	@echo 'exec $(HOME)/GNUstep/Applications/stickynote.app/stickynote "$$@"' >> $(HOME)/bin/sn
	@chmod +x $(HOME)/bin/sn
	@echo "Launcher created at $(HOME)/bin/sn"
	@echo "Add $(HOME)/bin to your PATH to use 'sn' command"

# Package creation
package:: release
	@echo "Creating distribution package..."
	@rm -rf stickynote-$(VERSION)
	@mkdir -p stickynote-$(VERSION)
	@cp -r stickynote.app stickynote-$(VERSION)/
	@cp README.md stickynote-$(VERSION)/
	@cp Users-Guide.md stickynote-$(VERSION)/
	@cp LICENSE stickynote-$(VERSION)/
	@tar czf stickynote-$(VERSION).tar.gz stickynote-$(VERSION)
	@rm -rf stickynote-$(VERSION)
	@echo "Package created: stickynote-$(VERSION).tar.gz"

#
# Testing Support
#

# Check if UnitKit is available
check-unitkit::
	@echo "Checking for UnitKit framework..."
	@if [ -d "$(GNUSTEP_SYSTEM_LIBRARY)/Frameworks/UnitKit.framework" ]; then \
		echo "UnitKit found: $(GNUSTEP_SYSTEM_LIBRARY)/Frameworks/UnitKit.framework"; \
	else \
		echo "UnitKit not found. Testing will not be available."; \
		echo "Install UnitKit to enable unit testing."; \
		exit 1; \
	fi

# Test executable (conditional on UnitKit)
ifeq ($(shell test -d "$(GNUSTEP_SYSTEM_LIBRARY)/Frameworks/UnitKit.framework" && echo "yes"),yes)

# Test target configuration
TEST_APP_NAME = stickynotetests
stickynotetests_OBJC_FILES = \
	Tests/SNTestMain.m \
	Tests/SNTestUtilities.m \
	Tests/SNConstantsTests.m \
	Tests/SNColorThemeTests.m \
	Tests/SNPreferencesTests.m \
	Tests/SNNoteManagerTests.m \
	SNColorTheme.m \
	SNConstants.m \
	SNPreferences.m \
	SNNoteManager.m \
	SNNoteWindowController.m

stickynotetests_HEADER_FILES = \
	Tests/SNTestUtilities.h \
	Tests/SNConstantsTests.h \
	Tests/SNColorThemeTests.h \
	Tests/SNPreferencesTests.h \
	Tests/SNNoteManagerTests.h

stickynotetests_GUI_LIBS += -lgnustep-gui -lgnustep-base -lUnitKit
stickynotetests_LIB_DIRS += -F$(GNUSTEP_SYSTEM_LIBRARY)/Frameworks

# Test targets
test:: $(TEST_APP_NAME).app
	@echo "Running stickynote unit tests..."
	@./$(TEST_APP_NAME).app/$(TEST_APP_NAME)

test-verbose:: $(TEST_APP_NAME).app
	@echo "Running stickynote unit tests (verbose)..."
	@./$(TEST_APP_NAME).app/$(TEST_APP_NAME) -verbose

test-class:: $(TEST_APP_NAME).app
	@if [ -z "$(CLASS)" ]; then \
		echo "Usage: gmake test-class CLASS=TestClassName"; \
		exit 1; \
	fi
	@echo "Running tests for class $(CLASS)..."
	@./$(TEST_APP_NAME).app/$(TEST_APP_NAME) -class $(CLASS)

# Clean test files
clean:: clean-tests
clean-tests::
	rm -rf $(TEST_APP_NAME).app
	rm -rf Tests/obj

else
# UnitKit not available - provide helpful error messages
test test-verbose test-class::
	@echo "Error: UnitKit framework not found."
	@echo "Please install UnitKit to enable unit testing."
	@echo "Run 'gmake check-unitkit' for more information."
	@exit 1
endif

#
# Documentation targets
#
docs::
	@echo "stickynote Documentation"
	@echo "======================="
	@echo "README.md - Main application documentation"
	@echo "Users-Guide.md - End user documentation"
	@echo "Testing.md - Developer testing guide"

#
# Development helpers
#

# Show build configuration
show-config::
	@echo "stickynote Build Configuration"
	@echo "=============================="
	@echo "Application: $(APP_NAME) v$(VERSION)"
	@echo "GNUstep Make: $(GNUSTEP_MAKEFILES)"
	@echo "Installation Domain: $(GNUSTEP_INSTALLATION_DOMAIN)"
	@echo "C Compiler: $(CC)"
	@echo "Additional OBJC Flags: $(ADDITIONAL_OBJCFLAGS)"
	@echo "GUI Libraries: $(stickynote_GUI_LIBS)"
	@echo ""
	@echo "Source Files:"
	@for file in $(stickynote_OBJC_FILES); do echo "  $$file"; done
	@echo ""
	@echo "Resource Files:"
	@for file in $(stickynote_RESOURCE_FILES); do echo "  $$file"; done

# Help target
help::
	@echo "stickynote GNUmakefile Help"
	@echo "=========================="
	@echo ""
	@echo "Basic Targets:"
	@echo "  all          - Build the application (default)"
	@echo "  clean        - Remove object files"
	@echo "  clean-all    - Remove all generated files"
	@echo "  install      - Install to system (requires sudo)"
	@echo "  install-user - Install to user GNUstep directory"
	@echo ""
	@echo "Build Configurations:"
	@echo "  debug        - Build with debug symbols"
	@echo "  release      - Build optimized release"
	@echo ""
	@echo "Development:"
	@echo "  check-syntax - Validate syntax of all source files"
	@echo "  show-config  - Display build configuration"
	@echo "  package      - Create distribution package"
	@echo ""
	@echo "Testing (requires UnitKit):"
	@echo "  check-unitkit - Check if UnitKit is available"
	@echo "  test         - Run all unit tests"
	@echo "  test-verbose - Run tests with verbose output"
	@echo "  test-class CLASS=name - Run specific test class"
	@echo ""
	@echo "Documentation:"
	@echo "  docs         - Show available documentation"
	@echo "  help         - Show this help message"

#
# End of GNUmakefile
#
