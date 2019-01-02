//
//  TextDrawingInfo.h
//  Dudel
//
//  Created by xulingjiao on 2019/1/2.
//  Copyright © 2019 xulingjiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drawable.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextDrawingInfo : NSObject<Drawable>

@property (strong, nonatomic) UIBezierPath *path;

@property (strong, nonatomic) UIColor *strokeColor;

@property (strong, nonatomic) UIFont *font;

@property (strong, nonatomic) NSString *text;

- (instancetype)initWithPath:(UIBezierPath *)path text:(NSString *)text strokeColor:(UIColor *)strokeColor font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
