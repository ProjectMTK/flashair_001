//
//  keyboardViewController.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/19.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface keyboardViewController : UIViewController
{
    id _delegate;
    NSMutableString* _targetName;

    UILabel* _nameLabel;
    
    NSDictionary* _alphabets;
}

@property (assign) id delegate;
@property (assign, readwrite) NSMutableString* targetName;

- (void)closeView;
- (void)update;

- (void)btnTouch:(UIButton*)button;
- (void)btnTouchOneDel:(UIButton*)button;
- (void)btnTouchAllDel:(UIButton*)button;

@end
