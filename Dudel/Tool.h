//
//  Tool.h
//  Dudel
//
//  Created by xulingjiao on 2018/12/14.
//  Copyright © 2018 xulingjiao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ToolDelegate;
@protocol Drawable;

@protocol Tool <NSObject>

@property (assign, nonatomic) id<ToolDelegate> delegate;

- (void)active;

- (void)deactive;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

- (void)drawTemp;

@end

@protocol ToolDelegate <NSObject>

- (void)addDrawable:(id<Drawable>)d;

- (UIView *)viewForUseWithTool:(id<Tool>)t;

- (UIColor *)strokeColor;

- (UIColor *)fillColor;

- (CGFloat)strokeWidth;

- (UIFont *)font;

@end

NS_ASSUME_NONNULL_END
