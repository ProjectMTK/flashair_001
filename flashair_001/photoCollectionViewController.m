//
//  photoCollectionViewController.m
//  flashair_001
//
//  Created by MAETAKAYOSHI on 2015/07/16.
//  Copyright (c) 2015年 前 尚佳. All rights reserved.
//

#import "photoCollectionViewController.h"
#import "Define_list.h"
#import "base_DataController.h"
//#import "topViewCell.h"
#import "common.h"
#import "imageViewController.h"
#import "settingViewController.h"
#import "configViewController.h"
#import "compareViewController.h"
#import "FontAwesomeStr.h"

#import "slideMenuView.h"
#import "UserDataCheck.h"

@implementation photoCollectionSectionView

- (void)dealloc
{
    [_titleLabel release];
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGRect rect = frame;
        rect.origin.x = 8;
        rect.origin.y = 0;
        _titleLabel = [[UILabel alloc] initWithFrame:rect];
        [self addSubview:_titleLabel];
    }
    return self;
}
@end

@interface photoCollectionViewController ()

@end

@implementation photoCollectionViewController

static NSString * const cellID = @"cell";
static NSString * const headerID = @"header";

@synthesize mode = _mode;
@synthesize refreshSW = _refreshSW;


- (void)dealloc
{
    self.flowLayout = nil;
    self.collectionView = nil;
    [_chkBtn release];
    [_unChkBtn release];
    [_unChkBtn2 release];
    [_acBtn release];
    [_btnArea release];
    [_glbData release];
    [_photoData release];
    [_selectedData release];
    [super dealloc];
}

- (void)viewDidLoad {
    LOGLOG;
    [super viewDidLoad];
    
    _refreshSW = YES;

    NSMutableArray* ary = [[NSMutableArray alloc]init];
    [base_DataController selTBL:10
                           data:ary
                       strWhere:@""];
    
    if ([[[ary objectAtIndex:0] objectForKey:@"login"] length] <= 0 &&
        [[[ary objectAtIndex:0] objectForKey:@"pass"] length] <= 0 &&
        [[[ary objectAtIndex:0] objectForKey:@"app_serv"] length] <= 0
        ) {
        [self goSettingView];
    }
    [ary release];
    
    
    
    //   self.mode = 0;
    _upCnt = 0;
    _getCnt = 0;
    _selectSW = NO;
    _chkedUpSW = NO;
    
    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc]init];
    
    leftBtn.title = [FontAwesomeStr getICONStr:@"fa-bars"];
    [leftBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_0,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    leftBtn.target = self;
    leftBtn.tag = 1;
    leftBtn.action = @selector(slideAction:);
    
    self.navigationItem.leftBarButtonItem = leftBtn;
    [self.navigationItem.leftBarButtonItem setEnabled:YES];
    [leftBtn release];
    
    //すべてチェックするボタン
    _chkBtn = [[UIBarButtonItem alloc]init];
    _chkBtn.title = [FontAwesomeStr getICONStr:@"fa-check-square-o"];
    [_chkBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P5,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    _chkBtn.target = self;
    _chkBtn.action = @selector(acAllCheck);
    
    //UNチェックボタン
    _unChkBtn = [[UIBarButtonItem alloc]init];
    _unChkBtn.title = [FontAwesomeStr getICONStr:@"fa-square-o"];
    [_unChkBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P5,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    _unChkBtn.target = self;
    _unChkBtn.action = @selector(acAllUncheck);
    
    //UNチェックボタン2
    _unChkBtn2 = [[UIBarButtonItem alloc]init];
    _unChkBtn2.title = [FontAwesomeStr getICONStr:@"fa-minus-square-o"];
    [_unChkBtn2 setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P5,
                                        NSForegroundColorAttributeName:UICOLOR_BLU_01
                                        } forState:UIControlStateNormal];
    _unChkBtn2.target = self;
    _unChkBtn2.action = @selector(acAllUncheck);
    
    //チェックしたデータを操作する
    _acBtn = [[UIBarButtonItem alloc]init];
    _acBtn.title = [FontAwesomeStr getICONStr:@"fa-cog"];
    [_acBtn setTitleTextAttributes:@{NSFontAttributeName:FA_ICON_FONT_P5,
                                      NSForegroundColorAttributeName:UICOLOR_BLU_01
                                      } forState:UIControlStateNormal];
    _acBtn.target = self;
    _acBtn.action = @selector(selectAction);
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_acBtn, _chkBtn, nil];
    [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:NO];
    [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setEnabled:YES];

    
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout.itemSize = CGSizeMake(240, 180);
    self.flowLayout.sectionInset = UIEdgeInsetsMake(16, 16, 32, 16);
    self.flowLayout.headerReferenceSize = CGSizeMake(100, 30);
    //  self.flowLayout.minimumLineSpacing = 16;
    //  self.flowLayout.minimumInteritemSpacing = 16;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, (HEAD_HEIGHT_PLUS_HEIGHT), self.view.frame.size.width, self.view.frame.size.height - (HEAD_HEIGHT_PLUS_HEIGHT)) collectionViewLayout:self.flowLayout];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerClass:[photoCollectionSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.allowsMultipleSelection = YES;
    
    slideMenuView* menuView = [[slideMenuView alloc]initWithFrame:CGRectMake(0, 0, SLIDEMENU_WIDTH, self.view.frame.size.height)];
    menuView.delegate = self;
    [self.view addSubview:menuView];
    [self.view sendSubviewToBack:menuView];
    
    _btnArea = [[UIView alloc]init];
    _btnArea.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, HEAD_HEIGHT_PLUS_HEIGHT);
    _btnArea.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_btnArea];
    
    UIButton* upBtnAll = [[UIButton alloc]init];
    upBtnAll.frame = CGRectMake(5, 5, (self.view.frame.size.width - 20) * 0.5, HEAD_HEIGHT_PLUS_HEIGHT - 10);
    [upBtnAll addTarget:self action:@selector(fileUpload) forControlEvents:UIControlEventTouchUpInside];
    upBtnAll.backgroundColor = [UIColor colorWithRed:0.11 green:0.13 blue:0.53 alpha:1.0];
    upBtnAll.layer.cornerRadius = 5;
    upBtnAll.clipsToBounds = true;
    [[upBtnAll layer] setCornerRadius:1.3f];
    [_btnArea addSubview:upBtnAll];
    [upBtnAll release];
    
    UILabel* btnALabel = [[UILabel alloc]init];
    btnALabel.frame = upBtnAll.frame;
    [_btnArea addSubview:btnALabel];
    btnALabel.text = @"すべてをExport";
    btnALabel.textAlignment = NSTextAlignmentCenter;
    btnALabel.textColor = [UIColor whiteColor];
    btnALabel.font = BASE_SYS_FONT_P3;
    
    UIButton* upBtnChk = [[UIButton alloc]init];
    upBtnChk.frame = CGRectMake(((self.view.frame.size.width - 20) * 0.5) + 10, 5, (self.view.frame.size.width - 20) * 0.5, HEAD_HEIGHT_PLUS_HEIGHT - 10);
    [upBtnChk addTarget:self action:@selector(fileUploadChk) forControlEvents:UIControlEventTouchUpInside];
    upBtnChk.backgroundColor = [UIColor colorWithRed:0.11 green:0.13 blue:0.53 alpha:1.0];
    upBtnChk.layer.cornerRadius = 5;
    upBtnChk.clipsToBounds = true;
    [[upBtnChk layer] setCornerRadius:1.3f];
    [_btnArea addSubview:upBtnChk];
    [upBtnChk release];
    
    UILabel* btnCLabel = [[UILabel alloc]init];
    btnCLabel.frame = upBtnChk.frame;
    [_btnArea addSubview:btnCLabel];
    btnCLabel.text = @"チェックしたものをExport";
    btnCLabel.textAlignment = NSTextAlignmentCenter;
    btnCLabel.textColor = [UIColor whiteColor];
    btnCLabel.font = BASE_SYS_FONT_P3;
    
    
    _glbData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:10
                           data:_glbData
                       strWhere:@""];
    /*
    _photoData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:_photoData
                       strWhere:@"WHERE stat = 1 ORDER BY id DESC"];
    */
    _selectedData = [[NSMutableDictionary alloc]init];
    
    //定期的に画像が更新されているかチェック。
 //   [NSThread detachNewThreadSelector:@selector(chkPhotoData) toTarget:self withObject:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//画面が隠れたとき
- (void)viewWillDisappear:(BOOL)animated
{
    
}
//画面が再表示したとき
- (void)viewWillAppear:(BOOL)animated
{
    LOGLOG;
    
    if (self.mode == SET_MODE_SETTING) {
        self.mode = SET_MODE_IMPORT;
    }
    
    if (self.mode == SET_MODE_IMPORT) {
        self.title = @"Import";
        self.navigationItem.titleView.userInteractionEnabled = YES;
        // すべてのジェスチャーにた対して処理を実行
        for(UIGestureRecognizer *gesture in [self.navigationItem.titleView gestureRecognizers]) {
            // UIGestureRecognizerのSubclassを判別
            if([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
                [self.navigationItem.titleView removeGestureRecognizer:gesture];
            }
        }
        
        // セレクタを指定して、パンジェスチャーリコジナイザーを生成する
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confOpenD)];
        //singleタップ
        gesture.numberOfTapsRequired = 1;
        [self.navigationItem.titleView addGestureRecognizer:gesture];
        [gesture release];
        [self modeChg:SET_MODE_IMPORT];
    }
    else {
        self.navigationItem.titleView.userInteractionEnabled = NO;
        
    }
    [self reloadTblData];
    
    /*
    [self modeChg:0];
    [self reloadTblData];*/
}
- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)confOut
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}
- (void)slideAction:(UIButton*)button
{
    if (button.tag == 1) {
        [self slideOpen];
    }
    else{
        [self slideClose];
    }
}
- (void)slideOpen
{
    LOGLOG;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.collectionView.frame = CGRectMake(SLIDEMENU_WIDTH, (HEAD_HEIGHT_PLUS_HEIGHT), self.view.frame.size.width, self.view.frame.size.height - (HEAD_HEIGHT_PLUS_HEIGHT));
                     }
                     completion:^(BOOL finished){
                         UIBarButtonItem* item = self.navigationItem.leftBarButtonItem;
                         item.tag = 10;
                     }];
}
- (void)slideClose
{
    LOGLOG;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.collectionView.frame = CGRectMake(0, (HEAD_HEIGHT_PLUS_HEIGHT), self.view.frame.size.width, self.view.frame.size.height - (HEAD_HEIGHT_PLUS_HEIGHT));
                     }
                     completion:^(BOOL finished){
                         UIBarButtonItem* item = self.navigationItem.leftBarButtonItem;
                         item.tag = 1;
                     }];
}
- (void)modeChg:(NSInteger)targetMode
{
    
    /*
    // すべてのジェスチャーにた対して処理を実行
    for(UIGestureRecognizer *gesture in [self.navigationItem.titleView gestureRecognizers]) {
        // UIGestureRecognizerのSubclassを判別
        if([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.navigationItem.titleView removeGestureRecognizer:gesture];
        }
     }*/
    titleTouch* titleLabel = [[titleTouch alloc]init];
    titleLabel.frame  =CGRectMake(0, 0, IPAD_CONTENTS_WIDTH_LANDSCAPE, IPAD_CONTENTS_HEIGHT_LANDSCAPE);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.delegate = self;
    titleLabel.userInteractionEnabled = YES;
    NSMutableAttributedString* labelText = [[NSMutableAttributedString alloc]init];
    NSAttributedString* labelTextUnit1 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ ", self.title]
                                                                        attributes:@{NSForegroundColorAttributeName:UICOLOR_BLU_01,
                                                                                     NSFontAttributeName:BASE_SYS_FONT_P1}];
    NSAttributedString* labelTextUnit2 = [[NSAttributedString alloc]initWithString:[FontAwesomeStr getICONStr:@"fa-cog"]
                                                                        attributes:@{NSForegroundColorAttributeName:UICOLOR_BLU_01,
                                                                                     NSFontAttributeName:FA_ICON_FONT_0}];
    
    
    [labelText appendAttributedString:labelTextUnit1];
    [labelText appendAttributedString:labelTextUnit2];
    
    if (targetMode == SET_MODE_IMPORT) {
        titleLabel.attributedText = labelText;
    }
    else {
        titleLabel.text = self.title;
    }
    [labelText release];
    [labelTextUnit1 release];
    [labelTextUnit2 release];
    
    self.navigationItem.titleView = nil;
    
    self.navigationItem.titleView = titleLabel;
    
    float height = self.view.frame.size.height - (HEAD_HEIGHT_PLUS_HEIGHT);
    float btnAreaY = self.view.frame.size.height;
    
    if (targetMode == SET_MODE_EXPORT) {
        height = self.view.frame.size.height - (HEAD_HEIGHT_PLUS_HEIGHT) - (HEAD_HEIGHT_PLUS_HEIGHT);
        btnAreaY = btnAreaY - (HEAD_HEIGHT_PLUS_HEIGHT);
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.collectionView.frame = CGRectMake(0, (HEAD_HEIGHT_PLUS_HEIGHT), self.view.frame.size.width, height);
                         _btnArea.frame = CGRectMake(0, btnAreaY, self.view.frame.size.width, (HEAD_HEIGHT_PLUS_HEIGHT));
                     }
                     completion:^(BOOL finished){
                         UIBarButtonItem* item = self.navigationItem.leftBarButtonItem;
                         item.tag = 1;
                         self.mode = targetMode;
                         [self reloadTblData];
                         
                         if (targetMode == SET_MODE_COMPARE) {
                             compareViewController* compView = [[compareViewController alloc]init];
                             compView.title = @"Compare";
                             [self.navigationController pushViewController:compView animated:YES];
                             [compView release];
                         }
                         else if (targetMode == SET_MODE_SETTING) {
                             [self goSettingView];
                         }
                     }];
}


//基本別スレで動作させる
- (void)chkPhotoData
{
    LOGLOG;
    
    bool status = true;
    
    while (status) {
        if ([base_DataController selCnt:2 strWhere:@"WHERE stat = 1 AND get_flg = 1 AND fadein_flg = 0"] > 0 && _selectSW == NO && _refreshSW == YES) {
            [self performSelectorOnMainThread:@selector(reloadTblData) withObject:nil waitUntilDone:YES];
            [NSThread sleepForTimeInterval:0.5f];
            continue;
        }
        
        [NSThread sleepForTimeInterval:0.5f];
    }
    
    [NSThread exit];
}

- (void)reloadPrTblData
{
    if (_selectSW == NO) {
        [self reloadTblData];
    }
    
}

- (void)reloadTblData
{
    LOGLOG;
  //  [_selectedData removeAllObjects];
    _photoData = [[NSMutableArray alloc]init];
    [base_DataController selTBL:2
                           data:_photoData
                       strWhere:@"WHERE stat = 1 AND get_flg = 1 ORDER BY id DESC"];
    
    //   [_tableView reloadData];
    //選択が外れた時
    if ([_selectedData count] <= 0){
        _selectSW = NO;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_acBtn, _chkBtn, nil];
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:NO];
    }
    else if ([_selectedData count] < [_photoData count]) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_acBtn, _unChkBtn2, nil];
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:YES];
    }
    else {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_acBtn, _unChkBtn, nil];
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:YES];
    }
    [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setEnabled:YES];
    [self.collectionView reloadData];
    NSLog(@"_photoData cnt = %ld", (long)[_photoData count]);
}

- (void)selectMode
{
    //モード変更時は選択状態を解除
    for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
        [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO];
    }
    //選択状態を解除するので、選択したデータも削除
    [_selectedData removeAllObjects];
    
    //選択モード->通常モードへ
    if (_selectSW) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = _chkBtn;
        //通常モードなので、ボタンは選択
    //    item.title = [FontAwesomeStr getICONStr:@"fa-check"];
        _selectSW = NO;
        
        self.collectionView.allowsMultipleSelection = NO;
    }
    //defaultの状態、通常モード->選択モードへ
    else{
        //選択モードなので、ボタンは通常
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = _acBtn;
        
     //   item.title = [FontAwesomeStr getICONStr:@"fa-times"];
        _selectSW = YES;
        
        self.collectionView.allowsMultipleSelection = YES;
    }
}

- (void)selectAction
{
    //アラートを準備
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"選択した写真"
                                                                   message:@"どのようにするか決めて下さい"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"閉じる"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {}]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"選択した写真の一括設定"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                // ボタンが押された時の処理
                                                [self confOpen];
                                            }]];
    /*
    [alert addAction:[UIAlertAction actionWithTitle:@"すべてのチェックを外す"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                // ボタンが押された時の処理
                                                //モード変更時は選択状態を解除
                                                for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
                                                    [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO];
                                                }
                                                //選択状態を解除するので、選択したデータも削除
                                                [_selectedData removeAllObjects];
                                            }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"すべてチェックする"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                // ボタンが押された時の処理
                                                //選択状態を一旦解除するので、選択したデータも削除
                                                [_selectedData removeAllObjects];
                                                
                                                for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
                                                    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                                                    [_selectedData setObject:[NSString stringWithFormat:@"%ld", (long)row]
                                                                      forKey:[[_photoData objectAtIndex:row] objectForKey:@"id"]];
                                                    
                                                }
                                            }]];
*/
    [alert addAction:[UIAlertAction actionWithTitle:@"チェックした写真を削除"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction *action) {
                                                // ボタンが押された時の処理
                                                [self removePhotoChk];
                                            }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)rightBarButtonItemChg:(NSInteger)selNum
{
    self.navigationItem.rightBarButtonItems = nil;
    
    
    
}

//すべてチェックする
- (void)acAllCheck
{
    // ボタンが押された時の処理
    //選択状態を一旦解除するので、選択したデータも削除
    [_selectedData removeAllObjects];
    
    for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
        NSLog(@"row1=%ld", (long)row);
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [_selectedData setObject:[NSString stringWithFormat:@"%ld", (long)row]
                          forKey:[[_photoData objectAtIndex:row] objectForKey:@"id"]];
        
    }
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_acBtn, _unChkBtn, nil];
    [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:YES];
    [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setEnabled:YES];
    
//    [self reloadTblData];
}
//すべてチェックを外す
- (void)acAllUncheck
{
    for (NSInteger row = 0; row < [self.collectionView numberOfItemsInSection:0]; row++) {
        NSLog(@"row2=%ld", (long)row);
        [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:NO];
    }
    //選択状態を解除するので、選択したデータも削除
    [_selectedData removeAllObjects];
    
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_acBtn, _chkBtn, nil];
    [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:NO];
    [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setEnabled:YES];
    
    //    [self reloadTblData];
}

- (void)removePhotoChk
{
    LOGLOG;
    //アラートを準備
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"削除しますか？"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"閉じる"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {}]];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:@"削除する"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *action) {
                                                // ボタンが押された時の処理
                                                [self removePhotoData];
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)removePhotoData
{
    LOGLOG;
    //更新するデータ
    NSMutableDictionary* upDic = [[NSMutableDictionary alloc]init];
    [upDic setObject:@"9" forKey:@"stat"];
    
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // 削除したいファイルのパスを作成
    NSError *error;
    
    NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/thumbnail/%@"];
    NSString* filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/collection/%@"];
    
    for (id key in [_selectedData keyEnumerator]) {
        //ファイル名
        NSString* fileName = [NSString stringWithFormat:@"%@_%@", [[_photoData objectAtIndex:[[_selectedData objectForKey:key] integerValue]] objectForKey:@"card_ssid"], [[_photoData objectAtIndex:[[_selectedData objectForKey:key] integerValue]] objectForKey:@"file_name"]];
        
        // ファイルを移動
        BOOL result = [fileManager removeItemAtPath:[NSString stringWithFormat:thumbPath, fileName]
                                              error:&error];
       
    //    NSLog(@"result1=%@", (result)? @"YES": @"NO");
        if(result){
            result = [fileManager removeItemAtPath:[NSString stringWithFormat:filePath, fileName]
                                             error:&error];
  //          NSLog(@"result2=%@", (result)? @"YES": @"NO");
        }
        if(result){
            [base_DataController simpleUpd:2
                                  upColumn:upDic
                                  strWhere:[NSString stringWithFormat:@"WHERE id = %@", key]];
    //        NSLog(@"where = %@", [NSString stringWithFormat:@"WHERE id = %@", key]);
        }
    }
    [upDic release];
    [self reloadTblData];
}

- (void)imageOpen:(UIButton*)button
{
    imageViewController* imageViewCon = [[imageViewController alloc]init];
    imageViewCon.targetID = button.tag;
    
    UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:imageViewCon];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
    [navCon release];
    [imageViewCon release];
}


- (void)titleTouch
{
    LOGLOG;
    [self confOpenD];
}

- (void)confOpenD
{
    LOGLOG;
    configViewController* confView = [[configViewController alloc]init];
    confView.target = 0;
    
    UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:confView];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
    [navCon release];
    [confView release];
    
}
- (void)confOpen
{
    LOGLOG;
    configViewController* confView = [[configViewController alloc]init];
    confView.target = 0;
    
    if (_selectSW) {
        confView.targetList = _selectedData;
    }
        
    UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:confView];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
    [navCon release];
    [confView release];
    
}
- (void)confOpen:(UIButton*)button
{
    LOGLOG;
    
    configViewController* confView = [[configViewController alloc]init];
    confView.target = button.tag;
    UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:confView];
    
    [self presentViewController:navCon animated:YES completion:nil];
    
    [navCon release];
    [confView release];
}

- (void)goSettingView
{
    settingViewController* settingView = [[settingViewController alloc]init];
    settingView.title = @"Setting";
    [self.navigationController pushViewController:settingView animated:YES];
    [settingView release];
}

- (void)fileUpload
{
    LOGLOG;/*
    if (_chkedUpSW == NO && [_photoData count] > _upCnt) {
        [self upload];
    }
    else if(_chkedUpSW == YES && [_selectedData count] > _upCnt){
        [self upload];
    }*/
    if ([_photoData count] > _upCnt) {
        [self upload];
    }
}

- (void)fileUploadChk
{
    LOGLOG;
    _chkedUpSW = YES;
    [self fileUpload];
}

- (void)upload
{
    LOGLOG;
    
    //選択したIDに含まれるかどうかチェック
    //通常処理
    if (
        (
         _chkedUpSW == NO ||
         (_chkedUpSW == YES && [[_selectedData allKeys] containsObject:[[_photoData objectAtIndex:_upCnt] objectForKey:@"id"]] == YES)
         ) &&
        [[[_photoData objectAtIndex:_upCnt] objectForKey:@"up_flg"] isEqualToString:@"0"] == YES &&
        [[[_photoData objectAtIndex:_upCnt] objectForKey:@"date"] length] > 0 &&
        [[[_photoData objectAtIndex:_upCnt] objectForKey:@"number"] length] > 0 &&
        [[[_photoData objectAtIndex:_upCnt] objectForKey:@"name"] length] > 0
        ) {
        NSAutoreleasePool* arp = [[NSAutoreleasePool alloc]init];
        
        NSString* fullPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/collection/%@_%@", [[_photoData objectAtIndex:_upCnt] objectForKey:@"card_ssid"], [[_photoData objectAtIndex:_upCnt] objectForKey:@"file_name"]]];
        NSLog(@"upload fullPath = %@", fullPath);
        UserDataCheck* usrchk = [[UserDataCheck alloc]init];
        usrchk.delegateView = self.view;
        usrchk.delegate = self;
        
        UIImage* image = [[UIImage alloc] initWithContentsOfFile:fullPath];
        
        UIImage* img;
        if (
            [[[_photoData objectAtIndex:_upCnt] objectForKey:@"face_tag"] isEqualToString:@"2"] == YES ||
            [[[_photoData objectAtIndex:_upCnt] objectForKey:@"face_tag"] isEqualToString:@"8"] == YES
            ) {
        //    NSLog(@"Mirror Mirror!!!");
            img =  [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationDownMirrored];
        }else{
            img =  [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationUp];
        }
        NSData* imageData = UIImageJPEGRepresentation(img, 1.0);
        
      //  NSData *imageData = [[NSData alloc]initWithData:UIImagePNGRepresentation(img)];
        [usrchk prc_UserProf_update_data:imageData targetId:[[[_photoData objectAtIndex:_upCnt] objectForKey:@"id"] integerValue]];
    //    [imageData release];
        [image release];
        
        [arp release];
    }
    //含まれない場合はスルー
    else {
        [self acThrough];
    }
}

- (void)acThrough
{
    LOGLOG;
    //カウントアップ
    _upCnt++;
    
    //カウントが_photoDataの個数に達しない内は繰り返す
    if ([_photoData count] > _upCnt) {
        [self upload];
    }
    else{
        _upCnt = 0;
        _chkedUpSW = NO;
        [self reloadTblData];
    }
}


- (void)acSuccess:(NSInteger)num
{
    LOGLOG;
    NSMutableDictionary* upDic = [[NSMutableDictionary alloc]init];
    [upDic setObject:@"1" forKey:@"up_flg"];
    
    [base_DataController simpleUpd:2
                          upColumn:upDic
                          strWhere:[NSString stringWithFormat:@"WHERE stat = 1 AND id = %@", [[_photoData objectAtIndex:_upCnt] objectForKey:@"id"]]];
    
    //アップに成功したらカウントアップ
    _upCnt++;
    
    //カウントが_photoDataの個数に達しない内は繰り返す
    if ([_photoData count] > _upCnt) {
        [self upload];
    }
    else{
        _upCnt = 0;
        _chkedUpSW = NO;
        [self reloadTblData];
    }
}

- (void)acFalse:(NSInteger)num
{
    LOGLOG;
}







#pragma mark - UICollectionViewDelegate
//セクションの数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//headerセクションのViewを返す
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        photoCollectionSectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor clearColor];
        
        NSMutableArray* ary = [[NSMutableArray alloc]init];
        [base_DataController selTBL:10 data:ary strWhere:@""];
        //getモード
        if (self.mode == SET_MODE_IMPORT) {
            NSString* headerTitle;
            if ([base_DataController selCnt:11 strWhere:@""] <= 0) {
                headerTitle = @"カメラWifiのSSIDが設定されていません。";
                headerView.backgroundColor = [UIColor redColor];
            }
            //SSIDは登録されているが、現在のSSIDと違う>>confOut
            else if ([base_DataController selCnt:11 strWhere:[NSString stringWithFormat:@"WHERE ssid_label = '%@'", [common getSSID]]] <= 0){
                headerTitle = @"機器のWifiが登録されたカメラSSIDと違います";
                headerView.backgroundColor = [UIColor redColor];
            }
            else {
                headerTitle = @"カメラのSDカードに接続して画像を取得します。";
                headerView.backgroundColor = [UIColor blueColor];
            }
            
            NSMutableArray* ary1 = [[NSMutableArray alloc]init];
            [base_DataController selTBL:1 data:ary1 strWhere:@""];
            NSString* defText;
            
            if ([ary1 count] > 0) {
                NSString* face_tag;
                switch ([[[ary1 objectAtIndex:0] objectForKey:@"face_tag"]integerValue]) {
                    case 1:
                        face_tag = @"左上";
                        break;
                    case 2:
                        face_tag = @"上";
                        break;
                    case 3:
                        face_tag = @"右上";
                        break;
                    case 4:
                        face_tag = @"左";
                        break;
                    case 5:
                        face_tag = @"中央";
                        break;
                    case 6:
                        face_tag = @"右";
                        break;
                    case 7:
                        face_tag = @"左下";
                        break;
                    case 8:
                        face_tag = @"下";
                        break;
                    case 9:
                        face_tag = @"右下";
                        break;
                    default:
                        face_tag = @"----";
                        break;
                }
                
                NSString* date;
                NSString* number;
                NSString* name;
                
                if ([[[ary1 objectAtIndex:0] objectForKey:@"date"] length] > 0) {
                    date = [[ary1 objectAtIndex:0] objectForKey:@"date"];
                }else{
                    date = @"----";
                }
                if ([[[ary1 objectAtIndex:0] objectForKey:@"number"] length] > 0) {
                    number = [[ary1 objectAtIndex:0] objectForKey:@"number"];
                }else{
                    number = @"----";
                }
                if ([[[ary1 objectAtIndex:0] objectForKey:@"name"] length] > 0) {
                    name = [[ary1 objectAtIndex:0] objectForKey:@"name"];
                }else{
                    name = @"----";
                }
                
                defText = [NSString stringWithFormat:
                                       @"[日付:%@ 番号:%@ 名前:%@ タグ:%@]",
                                       date,
                                       number,
                                       name,
                                       face_tag
                                       ];
            }
            else{
                defText = @"[初期値なし]";
            }
            
            headerView.titleLabel.text = [NSString stringWithFormat:@"%@  %@", headerTitle, defText];
            [ary1 release];
            
            // セレクタを指定して、パンジェスチャーリコジナイザーを生成する
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(confOpenD)];
            //singleタップ
            gesture.numberOfTapsRequired = 1;
            [headerView addGestureRecognizer:gesture];
            [gesture release];
            
        }
        //postモード
        else{
            
            if ([ary count] > 0 && [[[ary objectAtIndex:0] objectForKey:@"app_serv"] length] <= 0) {
                headerView.titleLabel.text = @"アプリケーションサーバが設定されていません。";
                headerView.backgroundColor = [UIColor redColor];
            }
            //SSIDは登録されているが、現在のSSIDと違う>>confOut
            else if ([base_DataController selCnt:11 strWhere:[NSString stringWithFormat:@"WHERE ssid_label = '%@'", [common getSSID]]] > 0){
                headerView.titleLabel.text = @"カメラWifiに接続されています。変更して下さい。";
                headerView.backgroundColor = [UIColor redColor];
            }
            else {
                headerView.titleLabel.text = @"画像データをアップします。";
                headerView.backgroundColor = [UIColor blueColor];
            }
        }
        headerView.titleLabel.textColor = [UIColor whiteColor];
        
        [ary release];
        return headerView;
    } else {
        return nil;
    }
}


/*セクションに応じたセルの数*/
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    /*
     int nums[] = {8,5,10};
     return nums[section];*/
    NSLog(@"cellcoll = %ld", (long)[_photoData count]);
    return [_photoData count];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    
    for (UIView *view in [cell.backgroundView subviews]) {
        [view removeFromSuperview];
    }
    cell.backgroundView = nil;
    
    cell.backgroundColor = [UIColor blackColor];
    NSString* thumbPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/thumbnail/%@_%@", [[_photoData objectAtIndex:indexPath.row] objectForKey:@"card_ssid"], [[_photoData objectAtIndex:indexPath.row] objectForKey:@"file_name"]]];
    
    
    if ([common fileExistsAtPath:thumbPath] && [[NSData dataWithContentsOfFile:thumbPath] length] > 0) {
        cell.backgroundView = nil;
        
        UIImage* img = [[UIImage alloc] initWithContentsOfFile:thumbPath];
        UIImage* image;
        if (
            [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"face_tag"] isEqualToString:@"2"] == YES ||
            [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"face_tag"] isEqualToString:@"8"] == YES
            ) {
         //   NSLog(@"row=%ld, 逆", (long)indexPath.row);
            image =  [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationDownMirrored];
        }else{
         //    NSLog(@"row=%ld, 普通", (long)indexPath.row);
            image =  [UIImage imageWithCGImage:img.CGImage scale:img.scale orientation:UIImageOrientationUp];
        }
        
        UIImageView* imgView = [[UIImageView alloc]initWithImage:image];
     //   NSLog(@"size height = %f", image.size.height);
       // NSLog(@"size width = %f", image.size.width);
       // NSLog(@"img.scale=%f", img.scale);
        cell.backgroundView = imgView;
        
        if (image.size.height < image.size.width) {
            cell.backgroundView.frame = CGRectMake(0, 0, 240, 180);
        }
        else{
            float sh = 180 / image.size.height;
            float rw = sh * image.size.width;
            float rx = (240 - rw) / 2;
      //      NSLog(@"resize sh = %f, rw = %f, rx = %f", sh, rw, rx);
            cell.backgroundView.frame = CGRectMake(rx, 0, rw, 180);
        }
        [imgView release];
        [img release];
        
        //保存したので、flgを1に
        NSMutableDictionary* upDic = [[NSMutableDictionary alloc]init];
        [upDic setObject:@"1" forKey:@"fadein_flg"];
        
        if ([[[_photoData objectAtIndex:indexPath.row] objectForKey:@"fadein_flg"] isEqualToString:@"0"] == YES) {
            [base_DataController simpleUpd:2
                                  upColumn:upDic
                                  strWhere:[NSString stringWithFormat:@"WHERE stat = 1 AND id = %@", [[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]]];
            
            cell.alpha = 0;
            [UIView animateWithDuration:1.0
                             animations:^{
                                 cell.alpha = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
        else{
            cell.alpha = 1;
        }
        [upDic release];
    }
    
    else if (
         ([common fileExistsAtPath:thumbPath] == YES && [[NSData dataWithContentsOfFile:thumbPath] length] <= 0) ||
         [common fileExistsAtPath:thumbPath] == NO
         ) {
        NSLog(@"nai node upd");
        //データが0なので、flgを0に
        NSMutableDictionary* upDic = [[NSMutableDictionary alloc]init];
        [upDic setObject:@"0" forKey:@"get_flg"];
        
        [base_DataController simpleUpd:2
                              upColumn:upDic
                              strWhere:[NSString stringWithFormat:@"WHERE id = %@", [[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]]];
        [upDic release];
   //     [self reloadTblData];
    }
    
    NSString* face_tag;
    switch ([[[_photoData objectAtIndex:indexPath.row] objectForKey:@"face_tag"]integerValue]) {
        case 1:
            face_tag = @"左上";
            break;
        case 2:
            face_tag = @"上";
            break;
        case 3:
            face_tag = @"右上";
            break;
        case 4:
            face_tag = @"左";
            break;
        case 5:
            face_tag = @"中央";
            break;
        case 6:
            face_tag = @"右";
            break;
        case 7:
            face_tag = @"左下";
            break;
        case 8:
            face_tag = @"下";
            break;
        case 9:
            face_tag = @"右下";
            break;
        default:
            face_tag = @"----";
            break;
    }
    
    UILabel* photoLabel = [[UILabel alloc]init];
    photoLabel.frame = CGRectMake(0, 0, 240, 180);
    photoLabel.textAlignment = NSTextAlignmentRight;
    photoLabel.textColor = [UIColor whiteColor];
    photoLabel.numberOfLines = 4;
    photoLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", [[_photoData objectAtIndex:indexPath.row] objectForKey:@"date"], [[_photoData objectAtIndex:indexPath.row] objectForKey:@"number"], [[_photoData objectAtIndex:indexPath.row] objectForKey:@"name"], face_tag];
    [cell.contentView addSubview:photoLabel];
    [photoLabel release];
    
    
    //未設定
    if (
        self.mode == SET_MODE_EXPORT &&
        (
         [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"date"] length] <= 0 ||
         [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"number"] length] <= 0 ||
         [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"name"] length] <= 0
        )
        ) {
        UILabel* exMark = [[UILabel alloc]init];
        exMark.frame = CGRectMake(0, 0, 30, 30);
        exMark.backgroundColor = [UIColor blueColor];
        exMark.text = [FontAwesomeStr getICONStr:@"fa-exclamation"];
        exMark.font = FA_ICON_FONT_0;
        exMark.textColor = [UIColor blackColor];
        exMark.backgroundColor = [UIColor yellowColor];
        exMark.textAlignment = NSTextAlignmentCenter;
     //   exMark.layer.cornerRadius = 5;
     //   exMark.clipsToBounds = true;
      //  [[exMark layer] setCornerRadius:15];
        [cell.contentView addSubview:exMark];
        [exMark release];
    }
    //送信済
    else if (self.mode == SET_MODE_EXPORT && [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"up_flg"] isEqualToString:@"1"] == YES){
        UILabel* upMark = [[UILabel alloc]init];
        upMark.frame = CGRectMake(0, 0, 30, 30);
        upMark.backgroundColor = [UIColor blueColor];
        upMark.text = @"済";
        upMark.font = BASE_SYS_FONT_P1;
        upMark.textColor = [UIColor blackColor];
        upMark.backgroundColor = [UIColor greenColor];
        upMark.textAlignment = NSTextAlignmentCenter;
        //   exMark.layer.cornerRadius = 5;
        //   exMark.clipsToBounds = true;
        //  [[exMark layer] setCornerRadius:15];
        [cell.contentView addSubview:upMark];
        [upMark release];
    }
    
    UIButton* confBtn = [[UIButton alloc]init];
  //  confBtn.hidden = YES;
    confBtn.frame = CGRectMake(205, 145, 30, 30);
    confBtn.backgroundColor = [UIColor grayColor];
    [confBtn setTitle:[FontAwesomeStr getICONStr:@"fa-cog"] forState:UIControlStateNormal];
    [confBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confBtn.titleLabel.font = FA_ICON_FONT_0;
    confBtn.tag = [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]integerValue];
    [confBtn addTarget:self action:@selector(confOpen:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:confBtn];
    [confBtn release];
    
    UIButton* picBtn = [[UIButton alloc]init];
    picBtn.frame = CGRectMake(5, 145, 30, 30);
    picBtn.backgroundColor = [UIColor grayColor];
    [picBtn setTitle:[FontAwesomeStr getICONStr:@"fa-picture-o"] forState:UIControlStateNormal];
    [picBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    picBtn.titleLabel.font = FA_ICON_FONT_0;
    picBtn.tag = [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]integerValue];
    [picBtn addTarget:self action:@selector(imageOpen:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:picBtn];
    [picBtn release];
    
    for (UIView *view in [cell.selectedBackgroundView subviews]) {
        [view removeFromSuperview];
    }
    cell.selectedBackgroundView = nil;
    
    UIView* selectedView = [[UIView alloc]init];
    selectedView.frame = CGRectMake(0, 0, 240, 180);
    selectedView.backgroundColor = [UIColor clearColor];
    [[selectedView layer] setBorderColor:[[UIColor blueColor] CGColor]];
    [[selectedView layer] setBorderWidth:4.0f];
    
    UILabel* checkmark = [[UILabel alloc]init];
    checkmark.frame = CGRectMake(0, 0, 30, 30);
    checkmark.backgroundColor = [UIColor blueColor];
    checkmark.text = [FontAwesomeStr getICONStr:@"fa-check"];
    checkmark.font = FA_ICON_FONT_0;
    checkmark.textColor = [UIColor whiteColor];
    checkmark.textAlignment = NSTextAlignmentCenter;
    [selectedView addSubview:checkmark];
    [checkmark release];
    
    cell.selectedBackgroundView = selectedView;
    [selectedView release];
    
    if ([[_selectedData allKeys] containsObject:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]] == YES) {
        cell.selected = YES;
        [_collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];

    }
    else{
        cell.selected = NO;
    }
    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    LOGLOG;
    if ([[_selectedData allKeys] containsObject:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]] == YES) {
        // 存在する場合の処理
        //消す
        [_selectedData removeObjectForKey:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]];
  //      UICollectionViewCell* cell = [self collectionView:_collectionView cellForItemAtIndexPath:indexPath];
    //    cell.selected = NO;
    //    NSLog(@"cell.selected");
    }
    
    self.navigationItem.rightBarButtonItems = nil;
    //選択が外れた時
    if ([_selectedData count] <= 0){
        _selectSW = NO;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_acBtn, _chkBtn, nil];
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:NO];
    }
    else if ([_selectedData count] < [_photoData count]) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_acBtn, _unChkBtn2, nil];
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:YES];
    }
    else {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_acBtn, _unChkBtn, nil];
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:YES];
    }
    [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setEnabled:YES];
//    NSLog(@"selected=%@", _selectedData);
    /*
    if ([_selectedData count] <= 0) {
        _selectSW = NO;
        
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:NO];
        [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setEnabled:YES];
        [[self.navigationItem.rightBarButtonItems objectAtIndex:2] setEnabled:NO];
    }*/
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LOGLOG;
    NSLog(@"selectedData = %@", _selectedData);
    if ([[_selectedData allKeys] containsObject:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]] == NO) {
        // 存在しない場合の処理
        [_selectedData setObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row] forKey:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]];
        NSLog(@"end selectedData = %@", _selectedData);
        _selectSW = YES;
    }
    
    self.navigationItem.rightBarButtonItems = nil;/*
    if ([_selectedData count] < [_photoData count]) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_acBtn, _unChkBtn2, nil];
    }else{
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_acBtn, _unChkBtn, nil];
    }
    [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:YES];
    [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setEnabled:YES];
    */
    if ([_selectedData count] <= 0){
        _selectSW = NO;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_acBtn, _chkBtn, nil];
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:NO];
    }
    else if ([_selectedData count] < [_photoData count]) {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_acBtn, _unChkBtn2, nil];
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:YES];
    }
    else {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:_acBtn, _unChkBtn, nil];
        [[self.navigationItem.rightBarButtonItems objectAtIndex:0] setEnabled:YES];
    }
    [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setEnabled:YES];
    
    /*
    if (_selectSW) {
        if ([[_selectedData allKeys] containsObject:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]] == NO) {
            // 存在しない場合の処理
            [_selectedData setObject:[NSString stringWithFormat:@"%ld", (long)indexPath.row] forKey:[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"]];
            //      NSLog(@"end selectedData = %@", _selectedData);
        }
        
    }
    else {
        
        imageViewController* imageViewCon = [[imageViewController alloc]init];
        imageViewCon.targetID = [[[_photoData objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
        //    NSLog(@"selectedE=%ld", (long)imageViewCon.targetID);
        
        UINavigationController* navCon = [[UINavigationController alloc]initWithRootViewController:imageViewCon];
        
        [self presentViewController:navCon animated:YES completion:^(void){
            //            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
        }];
        
        [navCon release];
        [imageViewCon release];
    }*/
}

- (void)didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSAutoreleasePool* arp = [[NSAutoreleasePool alloc]init];
    
    switch (indexPath.row) {
            //getモード
        case SET_MODE_IMPORT:
            self.title = @"Import";
            
            [self modeChg:SET_MODE_IMPORT];
            break;
            //postモード
        case SET_MODE_EXPORT:
            self.title = @"Export";
            [self modeChg:SET_MODE_EXPORT];
            break;
            //Viewerモード
        case SET_MODE_VIEWER:
            self.title = @"Viewer";
            [self modeChg:SET_MODE_VIEWER];
            break;
            //Compareモード
        case SET_MODE_COMPARE:
            [self modeChg:SET_MODE_COMPARE];
            break;
            //Makeモード
        case SET_MODE_MAKE:
            self.title = @"Make";
            [self modeChg:SET_MODE_MAKE];
            break;
            //設定へ
        case SET_MODE_SETTING:
            self.title = @"setting";
            [self modeChg:SET_MODE_SETTING];
          //  [self goSettingView];
            break;
        default:
            break;
    }
    [arp release];
}
@end
