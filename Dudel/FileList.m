//
//  FileList.m
//  Dudel
//
//  Created by xulingjiao on 2019/1/10.
//  Copyright © 2019 xulingjiao. All rights reserved.
//

#import "SyncSingleton.h"
#import "FileList.h"

#define DEFAULT_FILENAME_KEY @"defaultFilenameKey"

@interface FileList()

@property (strong, nonatomic) NSMutableArray *allFiles;

@property (strong, nonatomic) NSString *currentFile;

@end

@implementation FileList

SYNC_SINGLETON_FOR_CLASS(FileList);

- (instancetype)init {
    if (self = [super init]) {
        NSArray *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dirPath = [dirs firstObject];
        NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:NULL];
        NSArray *sortedFile = [files pathsMatchingExtensions:[@[@"dudeldoc"] sortedArrayUsingSelector:@selector(compare:)]];
        _allFiles = [NSMutableArray array];
        for (NSString *file in sortedFile) {
            [_allFiles addObject:[dirPath stringByAppendingPathComponent:file]];
        }
        _currentFile = [[NSUserDefaults standardUserDefaults] stringForKey:DEFAULT_FILENAME_KEY];
        if (_allFiles.count <= 0) {
            [self createAndSelectNewUntitled];
        }else if (![_allFiles containsObject:_currentFile]) {
            _currentFile = [_allFiles firstObject];
        }
    }
    return self;
}

- (void)setCurrentFile:(NSString *)currentFile {
    if (![_currentFile isEqualToString:currentFile]) {
        _currentFile = currentFile;
        [[NSUserDefaults standardUserDefaults] setObject:_currentFile forKey:DEFAULT_FILENAME_KEY];
        [[NSNotificationCenter defaultCenter] postNotificationName:FileListChangedNotification object:self];
    }
}

- (void)deleteCurrentFile {
    if (_currentFile) {
        NSUInteger filenameIndex = [_allFiles indexOfObject:_currentFile];
        NSError *error = nil;
        BOOL result = [[NSFileManager defaultManager] removeItemAtPath:_currentFile error:&error];
        if (filenameIndex != NSNotFound) {
            [_allFiles removeObjectAtIndex:filenameIndex];
            if (_allFiles.count == 0) {
                [self createAndSelectNewUntitled];
            } else {
                if (_allFiles.count == filenameIndex) {
                    filenameIndex--;
                }
                _currentFile = [_allFiles objectAtIndex:filenameIndex];
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:FileListChangedNotification object:self];
    }
}

- (void)renameFile:(NSString *)oldFilename to:(NSString *)newFilename {
    [[NSFileManager defaultManager] moveItemAtPath:oldFilename toPath:newFilename error:NULL];
    if ([_currentFile isEqualToString:oldFilename]) {
        _currentFile = newFilename;
    }
    NSUInteger nameIndex = [_allFiles indexOfObject:oldFilename];
    if (nameIndex != NSNotFound) {
        [_allFiles replaceObjectAtIndex:nameIndex withObject:newFilename];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:FileListChangedNotification object:self];
}

- (void)renameCurrentFile:(NSString *)newFilename {
    [self renameFile:_currentFile to:newFilename];
}

- (NSString *)createAndSelectNewUntitled {
    NSString *defaultFilename = [NSString stringWithFormat:@"Dudel %@.dudeldoc", [NSDate date]];
    NSArray<NSString *> *dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filename = [[dirs objectAtIndex:0] stringByAppendingPathComponent:defaultFilename];
    [[NSFileManager defaultManager] createFileAtPath:filename contents:nil attributes:nil];
    [_allFiles addObject:filename];
    [_allFiles sortedArrayUsingSelector:@selector(compare:)];
    _currentFile = filename;
    [[NSNotificationCenter defaultCenter] postNotificationName:FileListChangedNotification object:self];
    return _currentFile;
}

@end
