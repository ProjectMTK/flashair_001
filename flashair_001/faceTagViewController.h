//
//  faceTagViewController.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/22.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface faceTagViewController : UIViewController
{
    id _delegate;
    
    NSInteger _targetTag;
}

@property (assign) id delegate;
@property (assign) NSInteger targetTag;

- (void)closeView;
- (void)update;

- (void)btnTouch:(UIButton*)button;

@end
