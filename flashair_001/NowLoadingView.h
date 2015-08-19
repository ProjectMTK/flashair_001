//
//  NowLoadingView.h
//  cxc_manager
//
//  Created by 前 尚佳 on 2012/12/18.
//  Copyright (c) 2012年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NowLoadingView : UIView {
    CGRect _scrn;
    int _screenW;
    int _screenH;
    int _diverge_font_size;
    //黒幕
    UIActivityIndicatorView* _loading_mark;
}

@end
