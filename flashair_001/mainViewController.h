//
//  mainViewController.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/10.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mainViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate>

@property (retain, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (retain, nonatomic) UICollectionView *collectionView;


- (void)goSettingView;

//URLスキーム(設定へ)
- (void)confOut;
@end
