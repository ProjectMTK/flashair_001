//
//  cusColView.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/07/17.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@class cusColView;

//  ThumbnailViewデリゲート
@protocol cusColViewDelegate<NSObject>

//  タップされたサムネイルのインディックスを通知する。
- (void)ColView:(cusColView*)colView didSelectIndex:(NSInteger)index;
@end

@interface cusColView : UIScrollView
{
    NSArray*    _thumbnails;
    UIView*     _selectedView;   //  選択されているサムネイル
    CGSize      _thumbnaileSize; //  サムネイル矩形サイズ
    NSInteger   _countInRow;     //  横に何個、並ぶか
}
- (void)setThumbnails:(NSArray*)thumbnails;
- (void)reloadData;
@property (assign) id<cusColViewDelegate> colDelegate;
@property (assign) id chkDelegate;
@end