//
//  CanvasView.h
//  Canvas
//
//  Created by 國居 貴浩 on 11/10/16.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CanvasView : UIView {
    UIImage*    canvas;
    CGPoint     curtPt;
}
@property (retain) UIColor* penColor;
@property (assign) float penWidth;
@property (assign) BOOL eraserSW;

- (UIImage*)image;
- (void)setImage:(UIImage *)image;
- (void)delCanvas;
- (void)canvasImage:(CGPoint)newPt;
- (void)setCurtPt:(CGPoint)pt;
@end
