//
//  topCollectionViewController.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/06/08.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionSectionView : UICollectionReusableView

@property (nonatomic, readonly) UILabel *titleLabel;
@end

@interface topCollectionViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
{
    
    NSMutableArray* _glbData;
    NSMutableArray* _photoData;
    
    NSMutableDictionary* _selectedData;
    
 //   UILabel* _dir;
    
    BOOL _firstSW;
    NSInteger _getCnt;
    
    //個数
    NSInteger _upCnt;
    
    //データ
    //   NSMutableData* _receiveData;
    //ターゲット
    NSInteger _target;
    
    //モード
    NSInteger _mode;
    //タッチ(選択)
    BOOL _selectSW;
        
}
@property (assign) NSInteger mode;
@property (retain, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (retain, nonatomic) UICollectionView *collectionView;

- (void)popView;
- (void)reloadTblData;

//URLスキーム(設定へ)
- (void)confOut;

- (void)updateCheck;
- (void)reloadView:(NSString *)path;

- (void)selectMode:(UIBarButtonItem*)item;

//- (void)downloadCheck:(NSMutableArray*)photoData;
- (void)getCheck;
- (void)downloadPhoto:(NSInteger)target;

//- (void)reloadCell:(NSIndexPath*)indexPath;
//- (void)fileDownload:(NSString*)filePath;

- (void)fileUpload;
- (void)confOpen;

- (void)acSuccess:(NSInteger)num;
- (void)acFalse:(NSInteger)num;

@end
