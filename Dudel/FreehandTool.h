//
//  FreehandTool.h
//  Dudel
//
//  Created by xulingjiao on 2018/12/14.
//  Copyright © 2018 xulingjiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"

NS_ASSUME_NONNULL_BEGIN

@interface FreehandTool : NSObject<Tool>

@property (assign, nonatomic) id<ToolDelegate> delegate;
@property (strong, nonatomic) UIBezierPath *workingPath;
@property (assign, nonatomic) CGPoint nextSegmentPoint1;
@property (assign, nonatomic) CGPoint nextSegmentPoint2;
@property (assign, nonatomic) CGPoint nextSegmentCp1;
@property (assign, nonatomic) CGPoint nextSegmentCp2;
@property (assign, nonatomic) BOOL isDragging;
@property (assign, nonatomic) BOOL settingFirstPoint;

+ (instancetype)sharedFreehandTool;

@end

NS_ASSUME_NONNULL_END
