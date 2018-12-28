//
//  FreehandTool.m
//  Dudel
//
//  Created by xulingjiao on 2018/12/14.
//  Copyright © 2018 xulingjiao. All rights reserved.
//

#import "PathDrawingInfo.h"
#import "SyncSingleton.h"
#import "FreehandTool.h"

@implementation FreehandTool

SYNC_SINGLETON_FOR_CLASS(FreehandTool);

- (void)active {
    self.workingPath = [UIBezierPath bezierPath];
    _settingFirstPoint = YES;
}

- (void)deactive {
    PathDrawingInfo *info = [[PathDrawingInfo alloc] initWithPath:self.workingPath
                                                        fillColor:_delegate.fillColor
                                                      strokeColor:_delegate.strokeColor];
    [_delegate addDrawable:info];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _isDragging = YES;
    UIView *touchedView = [_delegate viewForUseWithTool:self];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touchedView];
    _nextSegmentPoint2 = touchPoint;
    _nextSegmentCp2 = touchPoint;
    if (_workingPath.empty) {
        _nextSegmentCp1 = touchPoint;
        _nextSegmentPoint1 = touchPoint;
        [_workingPath moveToPoint:touchPoint];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _isDragging = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _isDragging = NO;
    UIView *touchedView = [_delegate viewForUseWithTool:self];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touchedView];
    _nextSegmentCp2 = touchPoint;
    if (_settingFirstPoint) {
        _settingFirstPoint = NO;
    }
    else {
        CGPoint shiftedNextSegmentCp2  = CGPointMake(_nextSegmentPoint2.x + (_nextSegmentPoint2.x - _nextSegmentCp2.x), _nextSegmentPoint2.y + (_nextSegmentPoint2.y - _nextSegmentCp2.y));
        [_workingPath addCurveToPoint:_nextSegmentPoint2 controlPoint1:_nextSegmentCp1 controlPoint2:shiftedNextSegmentCp2];
        _nextSegmentPoint1 = _nextSegmentPoint2;
        _nextSegmentCp1 = _nextSegmentCp2;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *touchedView = [_delegate viewForUseWithTool:self];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touchedView];
    if (_settingFirstPoint) {
        _nextSegmentCp1 = touchPoint;
    }
    else {
        _nextSegmentCp2 = touchPoint;
    }
}

- (void)drawTemp {
    [_workingPath stroke];
    if (_isDragging) {
        if (_settingFirstPoint) {
            UIBezierPath *currentWorkingSegment = [UIBezierPath bezierPath];
            [currentWorkingSegment moveToPoint:_nextSegmentPoint1];
            [currentWorkingSegment addLineToPoint:_nextSegmentCp1];
            [_delegate.strokeColor setStroke];
            [currentWorkingSegment stroke];
        }
        else {
            CGPoint shiftedNextSegmentCp2 = CGPointMake(_nextSegmentPoint2.x + (_nextSegmentPoint2.x - _nextSegmentCp2.x), _nextSegmentPoint2.y + (_nextSegmentPoint2.y - _nextSegmentCp2.y));
            UIBezierPath *currentWorkingSegment = [UIBezierPath bezierPath];
            [currentWorkingSegment moveToPoint:_nextSegmentPoint1];
            [currentWorkingSegment addCurveToPoint:_nextSegmentPoint2 controlPoint1:_nextSegmentCp1 controlPoint2:shiftedNextSegmentCp2];
            [_delegate.strokeColor setStroke];
            [currentWorkingSegment stroke];
        }
        if (!CGPointEqualToPoint(_nextSegmentCp2, _nextSegmentPoint2) && !_settingFirstPoint) {
            UIBezierPath *currentWorkingSegment = [UIBezierPath bezierPath];
            [currentWorkingSegment moveToPoint:_nextSegmentCp2];
            CGPoint shiftedNextSegmentCp2 = CGPointMake(_nextSegmentPoint2.x + (_nextSegmentPoint2.x - _nextSegmentCp2.x), _nextSegmentPoint2.y + (_nextSegmentPoint2.y - _nextSegmentCp2.y));
            [currentWorkingSegment addLineToPoint:shiftedNextSegmentCp2];
            float dashPattern[] = {10.0, 7.0};
            [currentWorkingSegment setLineDash:dashPattern count:2 phase:0.0];
            [[UIColor redColor] setStroke];
            [currentWorkingSegment stroke];
        }
    }
}

@end
