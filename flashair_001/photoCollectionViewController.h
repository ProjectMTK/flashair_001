//
//  photoCollectionViewController.h
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/07/16.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photoCollectionSectionView : UICollectionReusableView

@property (nonatomic, readonly) UILabel *titleLabel;
@end

@interface photoCollectionViewController : UIViewController<UICollectionViewDelegate, UICollectionViewDataSource>
{
    
    NSMutableArray* _glbData;
    NSMutableArray* _photoData;
    
    NSMutableDictionary* _selectedData;
    
    UIBarButtonItem* _chkBtn;
    UIBarButtonItem* _unChkBtn;
    UIBarButtonItem* _acBtn;
    
    
    BOOL _chkedUpSW;
    BOOL _firstSW;
    NSInteger _getCnt;
    
    //個数
    NSInteger _upCnt;
    
    //ターゲット
    NSInteger _target;
    
    //モード
    NSInteger _mode;
    //タッチ(選択)
    BOOL _selectSW;
    
    //delegateからのスイッチ操作
    BOOL _refreshSW;
    
    //ボタンエリア
    UIView* _btnArea;
    
}
@property (assign) NSInteger mode;
@property (retain, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (retain, nonatomic) UICollectionView *collectionView;
@property (assign) BOOL refreshSW;

- (void)popView;
- (void)slideAction:(UIButton*)button;
- (void)slideOpen;
- (void)slideClose;
- (void)modeChg:(NSInteger)targetMode;

- (void)reloadTblData;

//URLスキーム(設定へ)
- (void)confOut;
- (void)confOpenD;
- (void)selectMode;
- (void)acAllUncheck;
- (void)acAllCheck;

- (void)chkPhotoData;

- (void)removePhotoChk;
- (void)removePhotoData;

- (void)fileUpload;
- (void)imageOpen:(UIButton*)button;
- (void)confOpen;
- (void)confOpen:(UIButton*)button;
- (void)goSettingView;

- (void)acSuccess:(NSInteger)num;
- (void)acFalse:(NSInteger)num;

- (void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath;
@end
