//
//  TextTool.m
//  Dudel
//
//  Created by xulingjiao on 2019/1/2.
//  Copyright © 2019 xulingjiao. All rights reserved.
//

#import "SyncSingleton.h"
#import "TextDrawingInfo.h"
#import "TextTool.h"

#define SHADE_TAG 1000

static CGFloat distanceBetween(const CGPoint p1, const CGPoint p2) {
    return sqrt(pow(p1.x-p2.x, 2)+pow(p1.y-p2.y, 2));
}

@interface TextTool()<UITextViewDelegate>

@end

@implementation TextTool

SYNC_SINGLETON_FOR_CLASS(TextTool);

- (instancetype)init {
    if (self = [super init]) {
        _trackingTouchs = [NSMutableArray array];
        _startPoints = [NSMutableArray array];
    }
    return self;
}

- (void)active {
    
}

- (void)deactive {
    [_trackingTouchs removeAllObjects];
    [_startPoints removeAllObjects];
    _completedPath = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    [touchedView endEditing:YES];
    UITouch *touch = [[event allTouches] anyObject];
    [_trackingTouchs addObject:touch];
    CGPoint location = [touch locationInView:touchedView];
    [_startPoints addObject:[NSValue valueWithCGPoint:location]];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *touchedView = [self.delegate viewForUseWithTool:self];
    for (UITouch *touch in [event allTouches]) {
        NSUInteger touchIndex = [_trackingTouchs indexOfObject:touch];
        if (touchIndex != NSNotFound) {
            CGPoint startPoint = [[_startPoints objectAtIndex:touchIndex] CGPointValue];
            CGPoint endPoint = [touch locationInView:touchedView];
            [_trackingTouchs removeObjectAtIndex:touchIndex];
            [_startPoints removeObjectAtIndex:touchIndex];
            if (distanceBetween(startPoint, endPoint) < 5)
                return;
            CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x-startPoint.x, endPoint.y-startPoint.y);
            self.completedPath = [UIBezierPath bezierPathWithRect:rect];
            UIView *backgroundShade = [[UIView alloc] initWithFrame:[touchedView bounds]];
            backgroundShade.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            backgroundShade.tag = SHADE_TAG;
            backgroundShade.userInteractionEnabled = NO;
            [touchedView addSubview:backgroundShade];
            UITextView *textView = [[UITextView alloc] initWithFrame:rect];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillShow:)
                                                         name:UIKeyboardWillShowNotification
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillHide:)
                                                         name:UIKeyboardWillHideNotification
                                                       object:nil];
            CGFloat keyboardHeight = 0;
            UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
            if (UIDeviceOrientationIsPortrait(orientation)) {
                keyboardHeight = 264;
            }
            else {
                keyboardHeight = 352;
            }
            CGRect viewBounds = [touchedView bounds];
            CGFloat rectMaxY = CGRectGetMaxY(viewBounds);
            CGFloat availableHeight = CGRectGetHeight(viewBounds) - keyboardHeight;
            if (rectMaxY > availableHeight) {
                _viewSlideDistance = rectMaxY - availableHeight;
            }
            else {
                _viewSlideDistance = 0;
            }
            textView.delegate = self;
            [touchedView addSubview:textView];
            textView.editable = NO;
            textView.editable = YES;
            [textView becomeFirstResponder];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)drawTemp {
    if (self.completedPath) {
        [self.delegate.strokeColor setStroke];
        [self.completedPath stroke];
    }
    else {
        UIView *touchedView = [self.delegate viewForUseWithTool:self];
        for (NSInteger i=0; i<_trackingTouchs.count; ++i) {
            UITouch *touch = _trackingTouchs[i];
            CGPoint startPoint = [_startPoints[i] CGPointValue];
            CGPoint endPoint = [touch locationInView:touchedView];
            CGRect rect = CGRectMake(startPoint.x, startPoint.y, endPoint.x-startPoint.x, endPoint.y-startPoint.y);
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
            [_delegate.strokeColor setStroke];
            [path stroke];
        }
    }
}

- (void)keyboardWillShow:(NSNotification *)n {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    [UIView beginAnimations:@"viewSlideUp" context:NULL];
    UIView *view = [self.delegate viewForUseWithTool:self];
    CGRect frame = view.frame;
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            frame.origin.x -= _viewSlideDistance;
            break;
        case UIDeviceOrientationLandscapeRight:
            frame.origin.x += _viewSlideDistance;
            break;
        case UIDeviceOrientationPortrait:
            frame.origin.y -= _viewSlideDistance;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            frame.origin.y += _viewSlideDistance;
            break;
        default:
            break;
    }
    view.frame = frame;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)n {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    [UIView beginAnimations:@"viewSlideDown" context:NULL];
    UIView *view = [self.delegate viewForUseWithTool:self];
    CGRect frame = view.frame;
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            frame.origin.x += _viewSlideDistance;
            break;
        case UIDeviceOrientationLandscapeRight:
            frame.origin.x -= _viewSlideDistance;
            break;
        case UIDeviceOrientationPortrait:
            frame.origin.y += _viewSlideDistance;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            frame.origin.y -= _viewSlideDistance;
            break;
        default:
            break;
    }
    view.frame = frame;
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    TextDrawingInfo *info = [[TextDrawingInfo alloc] initWithPath:_completedPath
                                                             text:textView.text
                                                      strokeColor:self.delegate.strokeColor
                                                             font:self.delegate.font];
    [self.delegate addDrawable:info];
    self.completedPath = nil;
    UIView *superView = [textView superview];
    [[superView viewWithTag:SHADE_TAG] removeFromSuperview];
    [textView resignFirstResponder];
    [textView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
