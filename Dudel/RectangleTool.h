//
//  RectangleTool.h
//  Dudel
//
//  Created by xulingjiao on 2018/12/14.
//  Copyright © 2018 xulingjiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"

NS_ASSUME_NONNULL_BEGIN

@interface RectangleTool : NSObject<Tool>

@property (assign, nonatomic) id<ToolDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *trackingTouches;

@property (strong, nonatomic) NSMutableArray *startPoints;

+ (instancetype)sharedRectangleTool;

@end

NS_ASSUME_NONNULL_END
