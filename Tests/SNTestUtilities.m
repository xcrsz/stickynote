//
//  SNTestUtilities.m
//  stickynote Tests
//
//  Common utilities and helpers for unit tests implementation
//

#import "SNTestUtilities.h"

static NSMutableDictionary *mockUserDefaults = nil;

@implementation SNTestUtilities

#pragma mark - Test Data Management

+ (NSString *)testDataDirectory {
    NSString *tempDir = NSTemporaryDirectory();
    return [tempDir stringByAppendingPathComponent:@"stickynotetests"];
}

+ (void)createTestDataDirectory {
    NSString *testDir = [self testDataDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:testDir]) {
        NSError *error = nil;
        BOOL success = [fileManager createDirectoryAtPath:testDir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
        if (!success) {
            NSLog(@"Failed to create test directory: %@", error.localizedDescription);
        }
    }
}

+ (void)cleanupTestDataDirectory {
    NSString *testDir = [self testDataDirectory];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:testDir]) {
        NSError *error = nil;
        BOOL success = [fileManager removeItemAtPath:testDir error:&error];
        if (!success) {
            NSLog(@"Failed to cleanup test directory: %@", error.localizedDescription);
        }
    }
}

+ (void)cleanupUserDefaults {
    // Reset NSUserDefaults to clean state for testing
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Remove test-specific keys
    NSArray *testKeys = @[@"SNDefaultFontSize", @"SNDefaultColorTheme", 
                         @"SNAutoSaveEnabled", @"SNAutoSaveInterval"];
    
    for (NSString *key in testKeys) {
        [defaults removeObjectForKey:key];
    }
    
    [defaults synchronize];
}

#pragma mark - Test File Helpers

+ (NSString *)createTestFile:(NSString *)filename withContent:(NSString *)content {
    [self createTestDataDirectory];
    
    NSString *testDir = [self testDataDirectory];
    NSString *filePath = [testDir stringByAppendingPathComponent:filename];
    
    NSError *error = nil;
    BOOL success = [content writeToFile:filePath
                             atomically:YES
                               encoding:NSUTF8StringEncoding
                                  error:&error];
    
    if (!success) {
        NSLog(@"Failed to create test file %@: %@", filename, error.localizedDescription);
        return nil;
    }
    
    return filePath;
}

+ (void)removeTestFile:(NSString *)filename {
    NSString *testDir = [self testDataDirectory];
    NSString *filePath = [testDir stringByAppendingPathComponent:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error = nil;
        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
        if (!success) {
            NSLog(@"Failed to remove test file %@: %@", filename, error.localizedDescription);
        }
    }
}

+ (BOOL)testFileExists:(NSString *)filename {
    NSString *testDir = [self testDataDirectory];
    NSString *filePath = [testDir stringByAppendingPathComponent:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

#pragma mark - Assertion Helpers

+ (void)assertFloat:(float)actual equalsFloat:(float)expected withAccuracy:(float)accuracy message:(NSString *)message {
    float difference = fabsf(actual - expected);
    if (difference > accuracy) {
        NSString *fullMessage = [NSString stringWithFormat:@"%@ - Expected: %f, Actual: %f, Difference: %f", 
                                message, expected, actual, difference];
        UKFail(fullMessage);
    }
}

+ (void)assertString:(NSString *)actual equalsString:(NSString *)expected message:(NSString *)message {
    if (![actual isEqualToString:expected]) {
        NSString *fullMessage = [NSString stringWithFormat:@"%@ - Expected: '%@', Actual: '%@'", 
                                message, expected, actual];
        UKFail(fullMessage);
    }
}

#pragma mark - Mock NSUserDefaults

+ (void)setMockUserDefault:(id)value forKey:(NSString *)key {
    if (!mockUserDefaults) {
        mockUserDefaults = [[NSMutableDictionary alloc] init];
    }
    [mockUserDefaults setObject:value forKey:key];
}

+ (id)getMockUserDefaultForKey:(NSString *)key {
    return [mockUserDefaults objectForKey:key];
}

+ (void)clearMockUserDefaults {
    [mockUserDefaults removeAllObjects];
}

@end
