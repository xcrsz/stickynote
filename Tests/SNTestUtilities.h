//
//  SNTestUtilities.h
//  stickynote Tests
//
//  Common utilities and helpers for unit tests
//

#import <Foundation/Foundation.h>
#import <UnitKit/UnitKit.h>

@interface SNTestUtilities : NSObject

// Test data management
+ (NSString *)testDataDirectory;
+ (void)createTestDataDirectory;
+ (void)cleanupTestDataDirectory;
+ (void)cleanupUserDefaults;

// Test file helpers
+ (NSString *)createTestFile:(NSString *)filename withContent:(NSString *)content;
+ (void)removeTestFile:(NSString *)filename;
+ (BOOL)testFileExists:(NSString *)filename;

// Assertion helpers
+ (void)assertFloat:(float)actual equalsFloat:(float)expected withAccuracy:(float)accuracy message:(NSString *)message;
+ (void)assertString:(NSString *)actual equalsString:(NSString *)expected message:(NSString *)message;

// Mock NSUserDefaults for testing
+ (void)setMockUserDefault:(id)value forKey:(NSString *)key;
+ (id)getMockUserDefaultForKey:(NSString *)key;
+ (void)clearMockUserDefaults;

@end
