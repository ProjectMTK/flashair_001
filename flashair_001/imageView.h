//
//  imageView.h
//  flashair_001
//
//  Created by 前 尚佳 on 2015/04/06.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanvasView.h"

@interface imageView : UIView <UIScrollViewDelegate> {
    
    id _delegate;
//    UIView* _subView;
    UIImageView* _imageView;
    CanvasView* _canvas;
//    UIView* _canvas;
}

@property (assign) BOOL eraserSW;
@property (assign) NSInteger targetID;
@property (assign, readwrite) id delegate;

- (void)delCanvas;
- (void)setPenColor:(UIColor*)color;
- (void)nextImage;
- (void)preImage;
@end
