//
//  CanvasView.m
//  Canvas
//
//  Created by 國居 貴浩 on 11/10/16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CanvasView.h"
#import "Define_list.h"

@implementation CanvasView
@synthesize penColor, penWidth;

- (void)canvasImage:(CGPoint)newPt
{
    UIGraphicsBeginImageContext(self.bounds.size);
//    UIRectFill(self.bounds);
    [canvas drawAtPoint:CGPointZero];
    if (self.eraserSW) {
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        penWidth = 33;
    }
    else{
        [penColor set];
        penWidth = 3;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, penWidth);
    
    CGContextMoveToPoint(context, curtPt.x, curtPt.y);
    CGContextAddLineToPoint(context, newPt.x, newPt.y);
    CGContextStrokePath(context);
    [canvas release];
    canvas = UIGraphicsGetImageFromCurrentImageContext();
    [canvas retain];
    UIGraphicsEndImageContext();
}

- (void)delCanvas
{/*
    UIGraphicsBeginImageContext(self.bounds.size);
    //    UIRectFill(self.bounds);
    [canvas drawAtPoint:CGPointZero];
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    [canvas release];
    canvas = UIGraphicsGetImageFromCurrentImageContext();
    [canvas retain];
    UIGraphicsEndImageContext();*/
    canvas = nil;
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [penColor release];
    [canvas release];
    [super dealloc];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    LOGLOG;
    UITouch* touch = [touches anyObject];
    curtPt = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint newPt = [touch locationInView:self];
    [self canvasImage:newPt];
    [self setNeedsDisplay];
    curtPt = newPt;
}

- (void)touchesEnd:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)setCurtPt:(CGPoint)pt
{
    curtPt = pt;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        penWidth = 3;
        self.penColor = [UIColor redColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [canvas drawAtPoint:CGPointMake(0, 0)];
}

- (UIImage*)image
{
    return canvas;
}

- (void)setImage:(UIImage *)image
{
    if (canvas == image) {
        return;
    }
    UIGraphicsBeginImageContext(self.bounds.size);
    UIRectFill(self.bounds);
    [image drawAtPoint:CGPointZero];
    [canvas release];
    canvas = UIGraphicsGetImageFromCurrentImageContext();
    [canvas retain];
    UIGraphicsEndImageContext();
    [self setNeedsDisplay];
}

@end

