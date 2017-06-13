//
//  FileManager.h
//  statslite
//
//  Created by Daniel on 4/18/17.
//  Copyright © 2017 eeeccom.elcomercio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (BOOL)writeFileAtPath:(NSString *)path data:(NSData *)data;
+ (NSData *)dataFromFileAtPath:(NSString *)path;

+ (NSString *)appendingPathComponentAtDocumentDirectory:(NSString *)fileName;
+ (BOOL)fileExistsAtPath:(NSString *)path;

+ (NSURL *)appendPathComponentAtCachesDirectory:(NSString *)path;
+ (NSURL *)appendPathComponentAtDocumentDirectory:(NSString *)path;
+ (NSURL *)appendPathComponentAtCachesDirectory:(NSString *)path ifNotExistCreateDirectory:(BOOL)ifNotExist;
+ (NSURL *)appendPathComponentAtDocumentDirectory:(NSString *)path ifNotExistCreateDirectory:(BOOL)ifNotExist;
+ (BOOL)createPathAtCachesDirectory:(NSString *)path;
+ (BOOL)createPathAtDocumentDirectory:(NSString *)path;

+ (void)writeData:(NSData *)data atFilePath:(NSString *)filePath;
+ (NSData *)readDataAtFilePath:(NSString *)filePath;
+ (void)writeString:(NSString *)data atFilePath:(NSString *)filePath;
+ (NSString *)readStringAtFilePath:(NSString *)filePath;

+ (void)cleanupOldFilesAtURL:(NSURL *)url maxDirSize:(NSUInteger)maxDirSize;

@end
