//
//  DudelView.h
//  Dudel
//
//  Created by xulingjiao on 2018/12/14.
//  Copyright © 2018 xulingjiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Drawable.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DudelViewDelegate <NSObject>

- (void)drawTemp;

@end

@interface DudelView : UIView

@property (weak, nonatomic) IBOutlet id<DudelViewDelegate> delegate;

@property (retain, nonatomic) NSMutableArray<id<Drawable>> *drawables;

@end

NS_ASSUME_NONNULL_END
