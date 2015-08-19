//
//  homeViewController.h
//  flashair_001
//
//  Created by 前 尚佳 on 2015/03/16.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "collectionView.h"
#import "AsyncImageView.h"

@interface homeViewController : UIViewController <collectionViewDelegate> {
    
    collectionView* _colView;
    NSMutableArray* _colData;
    
    UILabel* _dir;
    
}
- (BOOL)chkHolding:(NSInteger)index;

@end


@interface collectionDataView : UIView {
    
    AsyncImageView* _ImageView;
}


@property (assign) BOOL holdSW;
@property (assign) NSString* imageName;
@property (assign) NSString* titleStr;
@property (assign) NSString* bodyStr;

- (void)imageLoadError:(NSInteger)tag;
- (void)imageLoadComplete:(NSInteger)tag;

@end