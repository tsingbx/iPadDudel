//
//  PencilTool.m
//  Dudel
//
//  Created by xulingjiao on 2018/12/14.
//  Copyright © 2018 xulingjiao. All rights reserved.
//

#import "SyncSingleton.h"
#import "PathDrawingInfo.h"
#import "PencilTool.h"

@implementation PencilTool

SYNC_SINGLETON_FOR_CLASS(PencilTool)

- (instancetype)init {
    if (self = [super init]) {
        _trackingTouches = [[NSMutableArray alloc] init];
        _startPoints = [[NSMutableArray alloc] init];
        _paths = [NSMutableArray array];
    }
    return self;
}

- (void)active {
    
}

- (void)deactive {
    [_trackingTouches removeAllObjects];
    [_startPoints removeAllObjects];
    [_paths removeAllObjects];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *touchedView = [_delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches]) {
        [_trackingTouches addObject:touch];
        CGPoint location = [touch locationInView:touchedView];
        [_startPoints addObject:[NSValue valueWithCGPoint:location]];
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineCapStyle = kCGLineCapRound;
        [path moveToPoint:location];
        [path setLineWidth:_delegate.strokeWidth];
        [path addLineToPoint:location];
        [_paths addObject:path];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self deactive];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in [event allTouches]) {
        NSUInteger touchIndex = [_trackingTouches indexOfObject:touch];
        if (touchIndex != NSNotFound) {
            UIBezierPath *path = [_paths objectAtIndex:touchIndex];
            PathDrawingInfo *info = [[PathDrawingInfo alloc] initWithPath:path
                                                                fillColor:[UIColor clearColor]
                                                              strokeColor:_delegate.strokeColor];
            [_delegate addDrawable:info];
            [_trackingTouches removeObjectAtIndex:touchIndex];
            [_startPoints removeObjectAtIndex:touchIndex];
            [_paths removeObjectAtIndex:touchIndex];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *touchedView = [_delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches]) {
        NSUInteger touchIndex = [_trackingTouches indexOfObject:touch];
        if (touchIndex != NSNotFound) {
            CGPoint location = [touch locationInView:touchedView];
            UIBezierPath *path = [_paths objectAtIndex:touchIndex];
            [path addLineToPoint:location];
        }
    }
}

- (void)drawTemp {
    for (UIBezierPath *path in _paths) {
        [_delegate.strokeColor setStroke];
        [path stroke];
    }
}

@end
