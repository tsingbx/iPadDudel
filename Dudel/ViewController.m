//
//  ViewController.m
//  Dudel
//
//  Created by xulingjiao on 2018/12/14.
//  Copyright © 2018 xulingjiao. All rights reserved.
//

#import "Tool.h"
#import "ViewController.h"
#import "PencilTool.h"
#import "LineTool.h"
#import "RectangleTool.h"
#import "EllipseTool.h"
#import "FreehandTool.h"
#import "DudelView.h"

@interface ViewController ()<ToolDelegate, DudelViewDelegate>

@property (strong, nonatomic) id<Tool> currentTool;

@property (strong, nonatomic) IBOutlet DudelView *dudelView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *freehandButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *lineButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rectangleButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ellipseButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pencilButton;

@property (strong, nonatomic) UIColor *strokeColor;
@property (strong, nonatomic) UIColor *fillColor;
@property (assign, nonatomic) CGFloat strokeWidth;

@end

@implementation ViewController

- (void)deselectBarButtonItem:(UIBarButtonItem *)item {
    if ([item.customView isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)item.customView;
        btn.selected = NO;
    }
}

- (void)selectBarButtonItem:(UIBarButtonItem *)item {
    if ([item.customView isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)item.customView;
        btn.selected = YES;
    }
}

- (void)deselectAllToolButtons {
    [self deselectBarButtonItem:_freehandButton];
    [self deselectBarButtonItem:_lineButton];
    [self deselectBarButtonItem:_rectangleButton];
    [self deselectBarButtonItem:_ellipseButton];
    [self deselectBarButtonItem:_pencilButton];
}

- (void)setCurrentTool:(id<Tool>)currentTool {
    [_currentTool deactive];
    _currentTool = currentTool;
    _currentTool.delegate = self;
    [self deselectAllToolButtons];
    [_currentTool active];
    [_dudelView setNeedsDisplay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentTool = [PencilTool sharedPencilTool];
    self.fillColor = [UIColor lightGrayColor];
    self.strokeColor = [UIColor blackColor];
    self.strokeWidth = 2;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (IBAction)touchFreehandItem:(id)sender {
    self.currentTool = [FreehandTool sharedFreehandTool];
    [self selectBarButtonItem:self.freehandButton];
}

- (IBAction)touchLineItem:(id)sender {
    self.currentTool = [LineTool sharedLineTool];
    [self selectBarButtonItem:self.lineButton];
}
- (IBAction)touchRectangleItem:(id)sender {
    self.currentTool = [RectangleTool sharedRectangleTool];
    [self selectBarButtonItem:self.rectangleButton];
}

- (IBAction)touchEllipseItem:(id)sender {
    self.currentTool = [EllipseTool sharedEllipseTool];
    [self selectBarButtonItem:self.ellipseButton];
}

- (IBAction)touchPencilItem:(id)sender {
    self.currentTool = [PencilTool sharedPencilTool];
    [self selectBarButtonItem:self.pencilButton];
}

- (void)drawTemp {
    [_currentTool drawTemp];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_currentTool touchesBegan:touches withEvent:event];
    [_dudelView setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_currentTool touchesCancelled:touches withEvent:event];
    [_dudelView setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_currentTool touchesEnded:touches withEvent:event];
    [_dudelView setNeedsDisplay];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_currentTool touchesMoved:touches withEvent:event];
    [_dudelView setNeedsDisplay];
}

- (void)addDrawable:(id<Drawable>)d {
    [_dudelView.drawables addObject:d];
    [_dudelView setNeedsDisplay];
}

- (UIView *)viewForUseWithTool:(id<Tool>)t {
    return self.view;
}

@end
