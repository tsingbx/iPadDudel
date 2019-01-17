//
//  TextDrawingInfo.m
//  Dudel
//
//  Created by xulingjiao on 2019/1/2.
//  Copyright © 2019 xulingjiao. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "TextDrawingInfo.h"

@implementation TextDrawingInfo

- (instancetype)initWithPath:(UIBezierPath *)path text:(NSString *)text strokeColor:(UIColor *)strokeColor font:(UIFont *)font {
    if (self = [super init]) {
        _path = path;
        _text = text;
        _strokeColor = strokeColor;
        _font = font;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.path = [aDecoder decodeObjectForKey:@"path"];
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.strokeColor = [aDecoder decodeObjectForKey:@"strokeColor"];
        self.font = [aDecoder decodeObjectForKey:@"font"];
    }
    return self;
}

- (void)draw {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attrString addAttribute:NSForegroundColorAttributeName value:self.strokeColor range:NSMakeRange(0, _text.length)];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, _text.length), self.path.CGPath, NULL);
    if (frame) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 0, self.path.bounds.origin.y);
        CGContextScaleCTM(context, 1, -1);
        CGContextTranslateCTM(context, 0, -(self.path.bounds.origin.y + self.path.bounds.size.height));
        CTFrameDraw(frame, context);
        CGContextRestoreGState(context);
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.path
                  forKey:@"path"];
    [aCoder encodeObject:self.strokeColor
                  forKey:@"strokeColor"];
    [aCoder encodeObject:self.font
                  forKey:@"font"];
    [aCoder encodeObject:self.text
                  forKey:@"text"];
}

@end
