//
//  PathDrawingInfo.m
//  Dudel
//
//  Created by xulingjiao on 2018/12/14.
//  Copyright © 2018 xulingjiao. All rights reserved.
//

#import "PathDrawingInfo.h"

@implementation PathDrawingInfo

- (instancetype)initWithPath:(UIBezierPath *)path fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor {
    if (self = [super init]) {
        _path = path;
        _fillColor = fillColor;
        _strokeColor = strokeColor;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        self.path = [aDecoder decodeObjectForKey:@"path"];
        self.fillColor = [aDecoder decodeObjectForKey:@"fillColor"];
        self.strokeColor = [aDecoder decodeObjectForKey:@"strokeColor"];
    }
    return self;
}

- (void)draw {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    if (self.fillColor) {
        [self.fillColor setFill];
        [self.path fill];
    }
    if (self.strokeColor) {
        [self.strokeColor setStroke];
        [self.path stroke];
    }
    CGContextRestoreGState(context);
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.path
                  forKey:@"path"];
    [aCoder encodeObject:self.fillColor
                  forKey:@"fillColor"];
    [aCoder encodeObject:self.strokeColor
                  forKey:@"strokeColor"];
}

@end
