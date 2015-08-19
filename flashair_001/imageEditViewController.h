//
//  imageEditViewController.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/21.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "imageView.h"

@interface imageEditViewController : UIViewController
{
    imageView* _imageView;
    
}
@property (assign) NSInteger targetID;

- (void)closeView;
- (void)update;

@end
