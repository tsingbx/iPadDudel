//
//  PathDrawingInfo.h
//  Dudel
//
//  Created by xulingjiao on 2018/12/14.
//  Copyright © 2018 xulingjiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drawable.h"

NS_ASSUME_NONNULL_BEGIN

@interface PathDrawingInfo : NSObject<Drawable>

@property (strong, nonatomic) UIBezierPath *path;

@property (strong, nonatomic) UIColor *fillColor;

@property (strong, nonatomic) UIColor *strokeColor;

- (instancetype)initWithPath:(UIBezierPath *)path fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor;

@end

NS_ASSUME_NONNULL_END
