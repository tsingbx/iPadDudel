//
//  FileList.h
//  Dudel
//
//  Created by xulingjiao on 2019/1/10.
//  Copyright © 2019 xulingjiao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define FileListChangedNotification @"FileListChanged"

@interface FileList : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *allFiles;

@property (strong, nonatomic, readonly) NSString *currentFile;

+ (instancetype)sharedFileList;

- (void)deleteCurrentFile;

- (void)renameFile:(NSString *)oldFilename to:(NSString *)newFilename;

- (void)renameCurrentFile:(NSString *)newFilename;

- (NSString *)createAndSelectNewUntitled;

@end

NS_ASSUME_NONNULL_END
