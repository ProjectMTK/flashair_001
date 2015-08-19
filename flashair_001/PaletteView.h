//
//  PaletteView.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/07/25.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaletteView : UIView
{
    UIView* _bgView;
    UIButton* _closeBtn;
    
}
@property (retain) id delegate;

- (void)show;
- (void)close:(UIButton*)button;

- (void)paletteBtn:(UIButton*)button;
@end
