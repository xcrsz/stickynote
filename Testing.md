# stickynote Unit Testing Guide

**Version 0.0.1**  
**Author: Vic Thacker**  
**Testing Framework: UnitKit**

---

## Table of Contents

1. [Overview](#overview)
2. [Testing Framework Setup](#testing-framework-setup)
3. [Running Tests](#running-tests)
4. [Test Suite Structure](#test-suite-structure)
5. [Writing New Tests](#writing-new-tests)
6. [Test Coverage](#test-coverage)
7. [Continuous Integration](#continuous-integration)
8. [Troubleshooting](#troubleshooting)

---

## Overview

stickynote uses **UnitKit**, GNUstep's unit testing framework, to ensure code quality and reliability. The test suite covers:

- **Model Classes**: Data validation, persistence, notifications
- **Core Logic**: Note management, theme handling, preferences
- **Error Handling**: Invalid inputs, file system errors
- **Integration**: Component interactions and data flow

### Testing Philosophy

- **Comprehensive Coverage**: Test all public methods and important edge cases
- **Fast Execution**: Tests should run quickly for frequent execution
- **Isolated Tests**: Each test is independent and can run in any order
- **Readable Tests**: Test names and assertions clearly describe expected behavior

---

## Testing Framework Setup

### Prerequisites

1. **UnitKit Installation**: Ensure UnitKit is available in your GNUstep environment
   ```bash
   # On most GNUstep systems, UnitKit is included
   # If not available, install from: https://github.com/gnustep/framework-UnitKit
   ```

2. **Build Dependencies**: The test suite requires the same dependencies as the main application
   ```bash
   # Verify GNUstep development environment
   which gmake
   echo $GNUSTEP_MAKEFILES
   ```

### Initial Setup

1. **Create Test Structure**:
   ```bash
   make test-setup
   # or manually:
   mkdir -p Tests
   mkdir -p Tests/Fixtures
   mkdir -p Tests/Mocks
   mkdir -p TestResults
   ```

2. **Verify UnitKit Availability**:
   ```bash
   make check-syntax
   ```

---

## Running Tests

### Basic Test Execution

#### Run All Tests
```bash
make test
```

#### Run Tests with Verbose Output
```bash
make test-verbose
```

#### Run Specific Test Class
```bash
make test-class CLASS=SNPreferencesTests
make test-class CLASS=SNColorThemeTests
make test-class CLASS=SNConstantsTests
make test-class CLASS=SNNoteManagerTests
```

### Advanced Test Options

#### Run Tests with Coverage
```bash
make test-coverage
# Generates coverage report in TestResults/Coverage/
```

#### Continuous Testing (Watch Mode)
```bash
make test-watch
# Requires inotifywait - automatically runs tests when files change
```

#### Build and Test Together
```bash
make all-with-tests
```

### Test Output

Successful test output:
```
Running stickynote Unit Tests...
==================================
SNPreferencesTests: 15 tests passed
SNColorThemeTests: 12 tests passed
SNConstantsTests: 8 tests passed
SNNoteManagerTests: 20 tests passed
==================================
Total: 55 tests passed, 0 failed
Tests completed.
```

---

## Test Suite Structure

### Test Classes Overview

```
Tests/
├── SNTestMain.m                  # Test runner entry point
├── SNTestUtilities.h/m           # Common test helpers
├── SNPreferencesTests.h/m        # Preferences model tests
├── SNColorThemeTests.h/m         # Color theme system tests
├── SNConstantsTests.h/m          # Constants validation tests
├── SNNoteManagerTests.h/m        # Note management tests
├── Fixtures/                     # Test data files
├── Mocks/                        # Mock objects
└── (future test classes)
```

### Test Categories

#### 1. SNPreferencesTests (15 tests)
- **Singleton Behavior**: Verifies singleton pattern implementation
- **Property Validation**: Tests font size and interval clamping
- **Persistence**: Save/load from NSUserDefaults
- **Notifications**: Change notifications and observer patterns
- **Color Theme Integration**: Theme retention and validation

**Key Test Methods**:
```objc
- (void)testSharedPreferencesReturnsSameInstance;
- (void)testDefaultFontSizeValidation;
- (void)testSaveAndLoadDefaults;
- (void)testPreferenceChangeNotifications;
```

#### 2. SNColorThemeTests (12 tests)
- **Factory Methods**: Theme creation and property setting
- **Theme Management**: Available themes and lookup functionality
- **Comparison**: Equality and hashing for theme objects
- **Built-in Themes**: Validation of all six default themes
- **Error Handling**: Invalid names and nil parameters

**Key Test Methods**:
```objc
- (void)testThemeCreation;
- (void)testAvailableThemes;
- (void)testThemeEquality;
- (void)testAllBuiltInThemes;
```

#### 3. SNConstantsTests (8 tests)
- **Application Information**: Name, version, identifier validation
- **User Defaults Keys**: Proper naming and uniqueness
- **File System Constants**: Directory paths and file extensions
- **UI Constants**: Font sizes, window dimensions, intervals
- **Consistency**: Value ranges and naming conventions

**Key Test Methods**:
```objc
- (void)testApplicationConstants;
- (void)testUIConstants;
- (void)testNamingConsistency;
- (void)testValueRangeConsistency;
```

#### 4. SNNoteManagerTests (20 tests)
- **Initialization**: Proper setup with preferences
- **Note Creation**: Single and multiple note creation
- **Note Management**: Count, removal, collection access
- **Persistence**: Save/restore cycle with file system
- **Auto-save**: Timer management and configuration
- **Batch Operations**: Font size changes across all notes
- **Notifications**: Preference changes and note lifecycle
- **Error Handling**: Invalid directories and corrupted files

**Key Test Methods**:
```objc
- (void)testCreateNewNote;
- (void)testSaveAndRestoreCycle;
- (void)testAutoSaveConfiguration;
- (void)testBatchOperations;
```

### Test Utilities

#### SNTestUtilities Features
- **Test Data Management**: Temporary directories and cleanup
- **File Helpers**: Create/remove test files with content
- **Assertion Helpers**: Float comparison with accuracy, string validation
- **Mock UserDefaults**: Isolated preference testing
- **Common Setup/Teardown**: Standardized test environment

---

## Writing New Tests

### Test Class Template

```objc
//
//  SNNewComponentTests.h
//  stickynote Tests
//

#import <Foundation/Foundation.h>
#import <UnitKit/UnitKit.h>
#import "SNNewComponent.h"

@interface SNNewComponentTests : NSObject <UKTest>

- (void)setUp;
- (void)tearDown;

// Test methods here
- (void)testBasicFunctionality;

@end
```

```objc
//
//  SNNewComponentTests.m
//  stickynote Tests
//

#import "SNNewComponentTests.h"
#import "SNTestUtilities.h"

@implementation SNNewComponentTests

- (void)setUp {
    // Initialize test environment
    [SNTestUtilities cleanupTestDataDirectory];
}

- (void)tearDown {
    // Clean up after tests
    [SNTestUtilities cleanupTestDataDirectory];
}

- (void)testBasicFunctionality {
    // Arrange
    SNNewComponent *component = [[SNNewComponent alloc] init];
    
    // Act
    BOOL result = [component performAction];
    
    // Assert
    UKTrue(result, @"Action should succeed");
    
    [component release];
}

@end
```

### Testing Best Practices

#### 1. Test Naming
- Use descriptive names: `testFontSizeClampingWithInvalidValues`
- Follow pattern: `test + ComponentName + Behavior + Condition`
- Be specific about what's being tested

#### 2. Test Structure (AAA Pattern)
```objc
- (void)testMethodName {
    // Arrange - Set up test data and dependencies
    SNComponent *component = [[SNComponent alloc] init];
    NSString *testInput = @"test data";
    
    // Act - Execute the method being tested
    NSString *result = [component processInput:testInput];
    
    // Assert - Verify the expected outcome
    UKObjectsEqual(result, @"expected output", @"Should process input correctly");
    
    // Cleanup if needed
    [component release];
}
```

#### 3. Assertion Guidelines
```objc
// Use specific assertions
UKObjectsEqual(actual, expected, @"Message");     // For object equality
UKTrue(condition, @"Message");                    // For boolean conditions
UKIntsEqual(actual, expected, @"Message");        // For integer comparison
UKFloatsEqual(actual, expected, 0.1, @"Message"); // For float comparison with tolerance

// Provide descriptive messages
UKTrue([array count] > 0, @"Array should contain at least one item");
UKObjectsEqual(theme.name, @"yellow", @"Default theme should be yellow");
```

#### 4. Error Testing
```objc
- (void)testErrorHandling {
    SNComponent *component = [[SNComponent alloc] init];
    
    // Test that errors are handled gracefully
    BOOL success = [component processInvalidInput:nil];
    UKFalse(success, @"Should handle nil input gracefully");
    
    // Test that component remains in valid state after error
    UKTrue([component isValid], @"Component should remain valid after error");
    
    [component release];
}
```

### Adding Tests to Build System

1. **Add test files to GNUmakefile**:
   ```makefile
   stickynotetests_OBJC_FILES += \
       Tests/SNNewComponentTests.m
   ```

2. **Include in test runner**:
   ```objc
   // In SNTestMain.m
   #import "SNNewComponentTests.h"
   
   // In main():
   [runner runTestsInClass:[SNNewComponentTests class]];
   ```

---

## Test Coverage

### Current Coverage

Based on the test suite structure:

- **SNPreferences**: ~95% coverage (all public methods, edge cases)
- **SNColorTheme**: ~90% coverage (factory methods, theme management)
- **SNConstants**: ~100% coverage (validation of all constants)
- **SNNoteManager**: ~85% coverage (core functionality, some UI limitations)

### Coverage Goals

- **Critical Components**: 95%+ coverage
- **Model Classes**: 90%+ coverage  
- **UI Controllers**: 70%+ coverage (UI testing has limitations)
- **Utility Classes**: 85%+ coverage

### Generating Coverage Reports

```bash
# Generate HTML coverage report
make test-coverage

# View coverage
open TestResults/Coverage/index.html
```

### Coverage Analysis

The coverage report shows:
- **Line Coverage**: Percentage of code lines executed
- **Function Coverage**: Percentage of functions called
- **Branch Coverage**: Percentage of decision branches taken

Focus on improving coverage for:
1. Error handling paths
2. Edge cases and boundary conditions
3. Recently added features

---

## Continuous Integration

### Build Integration

Tests are integrated into the build process:

```bash
# Full build with tests
make package
# This runs: release build + full test suite + packaging
```

### Pre-commit Testing

Recommended workflow:
```bash
# Before committing changes
make check-syntax    # Quick syntax check
make test           # Run full test suite
make clean && make  # Clean build verification
```

### Automated Testing

For automated environments:
```bash
#!/bin/bash
# CI script example

set -e  # Exit on any error

echo "Building stickynote..."
make clean
make debug

echo "Running tests..."
make test

echo "Checking for memory leaks..."
# Add memory checking tools if available

echo "Build and test successful!"
```

---

## Troubleshooting

### Common Test Failures

#### 1. UnitKit Not Found
```
Error: UnitKit framework not found
```
**Solution**: Install UnitKit or verify GNUstep installation
```bash
# Check if UnitKit is available
ls $GNUSTEP_SYSTEM_LIBRARY/Frameworks/UnitKit.framework
```

#### 2. Test Files Not Found
```
Error: Cannot find test class SNPreferencesTests
```
**Solution**: Verify test files are in GNUmakefile and compiled
```bash
make check-syntax
ls Tests/*.m
```

#### 3. NSApplication Errors in Tests
```
Error: NSApplication not initialized
```
**Solution**: Some tests require NSApplication for UI components
```objc
- (void)setUp {
    if (![NSApplication sharedApplication]) {
        [NSApplication sharedApplication];
    }
}
```

#### 4. File Permission Errors
```
Error: Permission denied writing to test directory
```
**Solution**: Ensure test directory is writable
```bash
chmod 755 /tmp/stickynotetests
```

### Performance Issues

#### Slow Test Execution
- **Reduce File I/O**: Use in-memory testing where possible
- **Mock External Dependencies**: Avoid actual file system operations
- **Parallel Execution**: Run independent test classes in parallel

#### Memory Issues
- **Proper Cleanup**: Ensure all tests clean up allocated objects
- **Autorelease Pools**: Use @autoreleasepool in test methods if needed
- **Monitor Memory**: Check for leaks in long-running test suites

### Debugging Tests

#### Running Individual Tests
```bash
# Debug specific test
make test-class CLASS=SNPreferencesTests

# Add debug output
make test-verbose
```

#### GDB Integration
```bash
# Debug test executable
gdb ./obj/stickynotetests
(gdb) run
(gdb) bt  # On crash
```

#### Logging and Output
```objc
// Add debug output to tests
- (void)testSomething {
    NSLog(@"Testing with value: %@", testValue);
    // ... test code ...
    NSLog(@"Test completed successfully");
}
```

---

## Future Testing Enhancements

### Planned Improvements

1. **UI Testing**: Automated UI testing with mock user interactions
2. **Performance Testing**: Benchmark critical operations
3. **Integration Testing**: Full application workflow tests
4. **Stress Testing**: High load and edge case scenarios

### Test Infrastructure

1. **Mock Framework**: Comprehensive mocking for external dependencies
2. **Test Data Generation**: Automated test data creation
3. **Parallel Execution**: Faster test suite execution
4. **Reporting**: Enhanced test reports with trends and metrics

---

## Conclusion

The stickynote test suite provides comprehensive coverage of core functionality, ensuring reliability and maintainability. The UnitKit framework integration allows for:

- **Rapid Development**: Quick feedback on code changes
- **Quality Assurance**: Automated verification of functionality  
- **Regression Prevention**: Early detection of broken functionality
- **Documentation**: Tests serve as executable specifications

Regular test execution and maintenance ensure that stickynote remains a robust, reliable application as it evolves.

---

*stickynote Testing Guide v0.0.1 - Ensuring Quality Through Comprehensive Testing*
