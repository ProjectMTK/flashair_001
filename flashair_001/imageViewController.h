//
//  imageViewController.h
//  flashair_001
//
//  Created by 前 尚佳 on 2015/04/06.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageView.h"
#import "CanvasView.h"
#import "PaletteView.h"

@interface imageViewController : UIViewController 
{
    imageView* _imageView;
    PaletteView* _paletteView;
 /*
    UIBarButtonItem* _eraserBtn;
    UIBarButtonItem* _penBtn;*/
    
}
@property (assign) NSInteger targetID;

- (void)closeView;
- (void)confViewOpen;
- (void)openPalette:(UIBarButtonItem*)button;
- (void)gestureSW:(NSInteger)mode;
- (void)setTitleLabel;

@end
