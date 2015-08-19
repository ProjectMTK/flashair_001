//
//  NowLoadingView.m
//  cxc_manager
//
//  Created by 前 尚佳 on 2012/12/18.
//  Copyright (c) 2012年 前 尚佳. All rights reserved.
//

#import "NowLoadingView.h"

@implementation NowLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrn = [[UIScreen mainScreen] bounds];
    /*    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            // iPadで実行中
            _screenW = MAX(_scrn.size.width, _scrn.size.height);
            _screenH = MIN(_scrn.size.width, _scrn.size.height);
            _diverge_font_size = _screenH*0.05;
        }
        else {*/
            // それ以外で実行中
            _screenW = _scrn.size.width;
            _screenH = _scrn.size.height;
            _diverge_font_size = [UIFont buttonFontSize];
   //     }
        
        self.frame = CGRectMake(0, 0, _screenW, _screenH);
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5f;
        
        _loading_mark = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_loading_mark setCenter:CGPointMake(_screenW / 2, _screenH / 2)];
        
        [self addSubview:_loading_mark];
        
        [_loading_mark startAnimating];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}
@end
