//
//  RectangleTool.m
//  Dudel
//
//  Created by xulingjiao on 2018/12/14.
//  Copyright © 2018 xulingjiao. All rights reserved.
//

#import "PathDrawingInfo.h"
#import "SyncSingleton.h"
#import "RectangleTool.h"

@implementation RectangleTool

SYNC_SINGLETON_FOR_CLASS(RectangleTool);

- (instancetype)init {
    if (self = [super init]) {
        _trackingTouches = [NSMutableArray array];
        _startPoints = [NSMutableArray array];
    }
    return self;
}

- (void)active {
    
}

- (void)deactive {
    [_trackingTouches removeAllObjects];
    [_startPoints removeAllObjects];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *touchedView = [_delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches]) {
        [_trackingTouches addObject:touch];
        CGPoint location = [touch locationInView:touchedView];
        [_startPoints addObject:[NSValue valueWithCGPoint:location]];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *touchedView = [_delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches]) {
        NSUInteger touchIndex = [_trackingTouches indexOfObject:touch];
        if (touchIndex != NSNotFound) {
            CGPoint startPoint = [[_startPoints objectAtIndex:touchIndex] CGPointValue];
            CGPoint endPoint = [touch locationInView:touchedView];
            CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x-startPoint.x, endPoint.y-startPoint.y);
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
            PathDrawingInfo *info = [[PathDrawingInfo alloc] initWithPath:path
                                                                fillColor:_delegate.fillColor
                                                              strokeColor:_delegate.strokeColor];
            [_delegate addDrawable:info];
            [_trackingTouches removeObjectAtIndex:touchIndex];
            [_startPoints removeObjectAtIndex:touchIndex];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)drawTemp {
    UIView *touchedView = [_delegate viewForUseWithTool:self];
    for (NSInteger i = 0; i<[_trackingTouches count]; ++i) {
        UITouch *touch = [_trackingTouches objectAtIndex:i];
        CGPoint startPoint = [[_startPoints objectAtIndex:i] CGPointValue];
        CGPoint endPoint = [touch locationInView:touchedView];
        CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x-startPoint.x, endPoint.y-startPoint.y);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
        [_delegate.fillColor setFill];
        [path fill];
        [_delegate.strokeColor setStroke];
        [path stroke];
    }
}

@end
