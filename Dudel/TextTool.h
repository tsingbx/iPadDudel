//
//  TextTool.h
//  Dudel
//
//  Created by xulingjiao on 2019/1/2.
//  Copyright © 2019 xulingjiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tool.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextTool : NSObject<Tool>

@property (weak, nonatomic) id<ToolDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *trackingTouchs;

@property (strong, nonatomic) NSMutableArray *startPoints;

@property (strong, nonatomic) UIBezierPath *completedPath;

@property (assign, nonatomic) CGFloat viewSlideDistance;

+ (instancetype)sharedTextTool;

@end

NS_ASSUME_NONNULL_END
