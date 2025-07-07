//
//  SNTestMain.m
//  stickynote Tests
//
//  UnitKit test runner for stickynote
//  Author: Vic Thacker
//

#import <Foundation/Foundation.h>
#import <UnitKit/UnitKit.h>

// Import test classes
#import "SNPreferencesTests.h"
#import "SNColorThemeTests.h"
#import "SNConstantsTests.h"
#import "SNNoteManagerTests.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        NSLog(@"Starting stickynote Unit Tests");
        NSLog(@"==============================");
        
        // Initialize the test framework
        UKRunner *runner = [UKRunner new];
        
        // Add test classes
        [runner runTestsInClass:[SNPreferencesTests class]];
        [runner runTestsInClass:[SNColorThemeTests class]];
        [runner runTestsInClass:[SNConstantsTests class]];
        [runner runTestsInClass:[SNNoteManagerTests class]];
        
        // Run all tests and get results
        [runner reportResults];
        
        NSLog(@"==============================");
        NSLog(@"stickynote Unit Tests Complete");
        
        // Return exit code based on test results
        return [runner hadFailures] ? 1 : 0;
    }
}
