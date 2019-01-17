//
//  FileListViewController.h
//  Dudel
//
//  Created by xulingjiao on 2019/1/17.
//  Copyright © 2019 xulingjiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define FileListControllerSelectFileNotification @"FileListControllerSelectFile"

#define FileListControllerFilename @"FileListControllerFilename"

@interface FileListViewController : UITableViewController

@property (strong, nonatomic) NSString *currentDocumentFilename;

@property (strong, nonatomic) NSArray *documents;

@end

NS_ASSUME_NONNULL_END
