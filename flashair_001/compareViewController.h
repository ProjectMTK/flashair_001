//
//  compareViewController.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/07/23.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CanvasView.h"

@interface compareViewController : UIViewController
{
    UIView* _subView;
    UIView* _leftView;
    UIView* _rightView;
    
    CanvasView* _canvas;
    
    NSInteger _mode;
    NSInteger _target;
    
    UIBarButtonItem* _gripBtn;
    UIBarButtonItem* _penBtn;
}

- (void)titleTouch;
- (void)gripMode;
- (void)penMode;

@end


@interface titleTouch : UILabel
@property (retain) id delegate;
@end