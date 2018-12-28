//
//  DudelView.m
//  Dudel
//
//  Created by xulingjiao on 2018/12/14.
//  Copyright © 2018 xulingjiao. All rights reserved.
//

#import "DudelView.h"

@implementation DudelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _drawables = [NSMutableArray arrayWithCapacity:100];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _drawables = [NSMutableArray arrayWithCapacity:100];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    for (id<Drawable> d in _drawables) {
        [d draw];
    }
    [_delegate drawTemp];
}

@end
