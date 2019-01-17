//
//  FileListViewController.m
//  Dudel
//
//  Created by xulingjiao on 2019/1/17.
//  Copyright © 2019 xulingjiao. All rights reserved.
//

#import "FileList.h"
#import "FileListViewController.h"

@interface FileListViewController ()

@end

@implementation FileListViewController

- (void)reloadData {
    self.currentDocumentFilename = [FileList sharedFileList].currentFile;
    self.documents = [FileList sharedFileList].allFiles;
    [self.tableView reloadData];
}

- (void)fileListChanged:(NSNotification *)note {
    [self reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fileListChanged:)
                                                 name:FileListChangedNotification
                                               object:[FileList sharedFileList]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.documents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSString *file = self.documents[indexPath.row];
    cell.textLabel.text = [[file lastPathComponent] stringByDeletingPathExtension];
    if ([file isEqualToString:self.currentDocumentFilename]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[_documents objectAtIndex:indexPath.row] forKey:FileListControllerFilename];
    [[NSNotificationCenter defaultCenter] postNotificationName:FileListControllerSelectFileNotification object:self userInfo:userInfo];
    [self reloadData];
}

@end
